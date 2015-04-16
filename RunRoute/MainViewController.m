//
//  MainViewController.m
//  RunRoute
//
//  Created by TheBestGroup on 3/2/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController
{
    UIAlertView *alertView;
}

@synthesize map, points, locationManager, currentSession, lastLine, dss, isSession, nsTimer;

//NSDateFormatter *dateFormatter;
float dist;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [map setDelegate:self];
    
    points = [[NSMutableArray alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    dss = [DataSourceSingleton instance];
    isSession = NO;
    
    // Seta a precisão da informção
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDelegate:self];
    
    // Requisição de Permissão do GPS
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization )]) {
        [locationManager requestWhenInUseAuthorization];
    }

    map.showsUserLocation = YES;
    
    // Centraliza na localização do usuário, mas nao o segue
    [locationManager startUpdatingLocation];
    
    // Esconde o botão de stop
    _stopButtonOutlet.hidden = YES;
    
    // Defini o default do tipo de exercício
    _auxType = @"Walk";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    // Quando acessa o mapa pela primeira vez, ainda sem sessão, centraliza na posição do usuário
    if (!isSession) {
        CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
       
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
        
        [map setRegion:region animated:YES];
        
        [locationManager stopUpdatingLocation];
    }
    
    // Bloco para atualizações durante as sessões
    else {
        CLLocation *clPoint = [locations lastObject];
        
        //Cria nova entrada de ponto para persistir no Core Data
        RoutePoint *rrPoint = [NSEntityDescription insertNewObjectForEntityForName:@"RoutePoint" inManagedObjectContext:[[CorePersistenceManager sharedInstance]managedObjectContext]];
        [rrPoint setX:[NSNumber numberWithFloat:clPoint.coordinate.latitude]];
        [rrPoint setY:[NSNumber numberWithFloat:clPoint.coordinate.longitude]];
        [rrPoint setSpeed:[NSNumber numberWithFloat:clPoint.speed]];
        [rrPoint setTimestamp:clPoint.timestamp];
        [currentSession addPointsObject:rrPoint];
        [points addObject:[locations lastObject]];
        int aux = (int)points.count;
        if(aux>1){
            dist += [[points objectAtIndex:aux-1]distanceFromLocation:[points objectAtIndex:aux-2]];
        }
        [self showInfo];
        [self drawRoute: points];
    }
}

-(void)showInfo{
    if(isSession){
        // Atualiza o timer na tela com o tempo a partir do começo da sessão
        int seconds = (int)round([[NSDate date]timeIntervalSinceDate:[(CLLocation*)[points firstObject]timestamp]]);
        NSString *timeString = [NSString stringWithFormat:@"%02u:%02u:%02u", seconds / 3600, (seconds / 60) % 60, seconds % 60];
        _timeDisplay.text = timeString;
        
        NSString *distString = [NSString stringWithFormat:@"%.2f m",dist];
        _distDisplay.text = distString;
    }
}


- (IBAction)startButton:(id)sender {
    // Inicia a atualização da localização dentro de uma sessão
    [locationManager startUpdatingLocation];
    
    currentSession = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:[[CorePersistenceManager sharedInstance]managedObjectContext]];
    isSession = YES;
    dist = 0.0;
    currentSession.typeExercise = _auxType;
    
    // Esconde o botão play e o tipo de exercício
    _startButtonOutlet.hidden = YES;
    _typeExercise.hidden = YES;
    _viewType.hidden = YES;
    
    // Mostra o botão stop
    _stopButtonOutlet.hidden = NO;
    
    // "Segue" o usuário
    map.userTrackingMode = YES;
}

- (IBAction)stopButton:(id)sender {
    alertView = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Deseja mesmo encerrar o exercício?"delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Sim", nil];
    [alertView show];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        isSession = NO;
        
        [locationManager stopUpdatingLocation];
        
        
        [currentSession setDate:[(CLLocation*)[points firstObject]timestamp]];
        
        [currentSession calcDist];
        [currentSession calcTime];
        //    NSLog(@"Distancia: %f", [currentSession calcDist]);
        //    NSLog(@"Tempo: %f", [currentSession calcTime]);
        
        [dss addSession:currentSession];
        
        [[CorePersistenceManager sharedInstance]saveContext];
        
        // Esvazia os objetos
        currentSession = nil;
        
        // Recria os pontos
        points = [[NSMutableArray alloc] init];
        
        // Cria e exibe um alerta no final do exercício
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"Exercício Concluído" message:@"Exercício salvo no seu histórico 😁"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertV show];
        
        // Esconde o stop
        _stopButtonOutlet.hidden = YES;
        
        // Mostra o play e tipo de exercício
        _startButtonOutlet.hidden = NO;
        _typeExercise.hidden = NO;
        _viewType.hidden = NO;
    }
}

#pragma mark - PolyLine

// Cria um overlay a partir de um objeto MKPolyline; é uma linha traçada sobre o mapa com base em coordenadas
-(void)drawRoute:(NSMutableArray*)pontos{
    
    // Para evitar de criar infinitas linhas e sobrecarregar a memoria
    if(nil!=lastLine)
        [map removeOverlay:lastLine];
    
    // Como precisamos apenas das coordenadas, e não do CLLocation inteiro, passamos para um vetor auxiliar
    CLLocationCoordinate2D coords[points.count];
    for(int i=0; i< points.count; i++){
        CLLocation *local = [points objectAtIndex:i];
        CLLocationCoordinate2D coord = local.coordinate;
        
        coords[i] = coord;
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:points.count];
    lastLine = polyline;
    
    //adiciona o overlay ao mapa; um renderer então cuida de sua exibição na tela
    [map addOverlay:polyline];
}

#pragma mark - MKMapViewDelegate

//configura o renderer que vai tratar de desenhar o overylay no mapa; é chamado pelo delegate (esta própria classe) quando um novo overlay é adicionado (no caso, durante a execução do método drawRoute)
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        // É ESSE QUE DEFINE A COR
        renderer.strokeColor = [[UIColor colorWithRed:249.0/255.0 green:66.0/225.0 blue:7.0/255.0 alpha:1] colorWithAlphaComponent:0.7];
        //largura da linha desenahda
        renderer.lineWidth   = 5;
        
        return renderer;
    }
    return nil;
}

- (IBAction)typeExercise:(id)sender{
    // Tipo de exercício
    switch (((UISegmentedControl*) sender).selectedSegmentIndex) {
        case 0:
            _auxType = @"Walk";
            break;
        case 1:
            _auxType = @"Run";
            break;
        case 2:
            _auxType = @"Bike";
            break;
        default:
            _auxType = @"Walk";
            break;
    }
}

- (IBAction)locationButton:(id)sender {
    // "Segue" o usuário
    map.userTrackingMode = YES;
}

// Seta o texto da status bar, preto
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end

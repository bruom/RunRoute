//
//  MainViewController.m
//  RunRoute
//
//  Created by TheBestGroup on 3/2/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    if (nil == currentSession) {
        CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
        
        // Determinar região com as coordenadas de localização atual e os limites N/S e L/O no zoom em metros
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
        
        // Mudar a região atual para visualização de forma animada
        [map setRegion:region animated:YES];
        
        [locationManager stopUpdatingLocation];
    }
    else {
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
        // Atualiza o timer no tela com o tempo a partir do começo da sessão
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
    
    currentSession = [[Session alloc] init];
    isSession = YES;
    dist = 0.0;
    currentSession.typeExercise = _auxType;
    
    // Esconde o botão play e o tipo de exercício
    _startButtonOutlet.hidden = YES;
    _typeExercise.hidden = YES;
    
    // Mostra o botão stop
    _stopButtonOutlet.hidden = NO;
    
    // "Segue" o usuário
    map.userTrackingMode = YES;
}

- (IBAction)stopButton:(id)sender {
    
    isSession = NO;
    
    [locationManager stopUpdatingLocation];
    
    // Grava os dados da sessão
    currentSession.points = points;
    [currentSession calcDist];
    [currentSession calcTime];
//    NSLog(@"Distancia: %f", [currentSession calcDist]);
//    NSLog(@"Tempo: %f", [currentSession calcTime]);
    
    [dss addSession:currentSession];
    
    // Esvazia os objetos
    currentSession = nil;
    
    // Recria os pontos
    points = [[NSMutableArray alloc] init];
    
    // Cria e exibe um alerta no final do exercício
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exercício Concluído" message:@"Exercício salvo no seu histórico 😁"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    // Esconde o stop
    _stopButtonOutlet.hidden = YES;
    
    // Mostra o play e tipo de exercício
    _startButtonOutlet.hidden = NO;
    _typeExercise.hidden = NO;
}

#pragma mark - PolyLine

-(void)drawRoute:(NSMutableArray*)pontos{
    
    // Para evitar de criar infinitas linhas e sobrecarregar a memoria
    if(nil!=lastLine)
        [map removeOverlay:lastLine];
    CLLocationCoordinate2D coords[points.count];
    for(int i=0; i< points.count; i++){
        CLLocation *local = [points objectAtIndex:i];
        CLLocationCoordinate2D coord = local.coordinate;
        
        coords[i] = coord;
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:points.count];
    lastLine = polyline;
    [map addOverlay:polyline];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        // É ESSE QUE DEFINE A COR
        renderer.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
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

// Seta o texto da status bar, branco
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end

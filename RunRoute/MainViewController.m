//
//  MainViewController.m
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/2/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
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
    //nsTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showInfo) userInfo:nil repeats:YES];
    //dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"HH:mm:ss"];
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
    
    // Do any additional setup after loading the view.
    _stopButtonOutlet.hidden = YES;
    
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
        
        //Determinar região com as coordenadas de localização atual e os limites N/S e L/O no zoom em metros
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
        
        //Mudar a região atual para visualização de forma animada
        [map setRegion:region animated:YES ];
        
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
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSDate date]timeIntervalSinceDate:[(CLLocation*)[points firstObject]timestamp]]];
//        _timeDisplay.text = [dateFormatter stringFromDate:date];
        
        
        
        //atualiza o timer no tela com o tempo a partir do começo da sessão
        int seconds = (int)round([[NSDate date]timeIntervalSinceDate:[(CLLocation*)[points firstObject]timestamp]]);
        NSString *timeString = [NSString stringWithFormat:@"%02u:%02u:%02u",
                            seconds / 3600, (seconds / 60) % 60, seconds % 60];
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
    
    _stopButtonOutlet.hidden = NO;
    _startButtonOutlet.hidden = YES;

}

- (IBAction)stopButton:(id)sender {
    
    isSession = NO;
    
    [locationManager stopUpdatingLocation];
    
    
    // Grava os dados da sessão
    currentSession.points = points;
    [currentSession calcDist];
    [currentSession calcTime];
    NSLog(@"Distancia: %f", [currentSession calcDist]);
    NSLog(@"Tempo: %f", [currentSession calcTime]);
    
    [dss addSession:currentSession];
    
    // Esvazia os objetos
    currentSession = nil;
    
    // Recria o pontos
    points = [[NSMutableArray alloc] init];
    

    
    _stopButtonOutlet.hidden = YES;
    _startButtonOutlet.hidden = NO;
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
@end

//
//  DetailsTableViewController.m
//  RunRoute
//
//  Created by João Marcos on 08/06/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "DetailsTableViewController.h"

@interface DetailsTableViewController ()

@end

@implementation DetailsTableViewController

@synthesize session, map;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [map setDelegate:self];
    
    NSMutableArray *coords = [[NSMutableArray alloc]init];
    
    //retorna os pontos do NSSet de forma ordenada por timestamp
    NSArray *pontosArray = [[session.routePoints allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(RoutePoint *)obj1 timestamp] compare:[(RoutePoint *)obj2 timestamp]];
    }];
    for(RoutePoint* rp in pontosArray){
        CLLocation *coord = [[CLLocation alloc]initWithLatitude:[[rp x] doubleValue] longitude:[[rp y] doubleValue]];
        [coords addObject:coord];
    }
    
    // Converte o tempo para texto
    int seconds = (int)round([session calcTime]);
    NSString *timeString = [NSString stringWithFormat:@"%02u:%02u:%02u", seconds / 3600, (seconds / 60) % 60, seconds % 60];
    
    // Seta os textos das labels de informação
    _timeLabel.text = timeString;
    _speedLabel.text = [[NSString alloc] initWithFormat:@"%.2f km/h",[session calcSpeed]];
    _dateLabel.text = [[NSString alloc] initWithFormat:@"%@", [session startDateWithHour]];
    _distLabel.text = [[NSString alloc] initWithFormat:@"%.2f m", [session calcDist]];
    _maxSpeedDisplay.text = [[NSString alloc] initWithFormat:@"%.2f km/h",[session getMaxSpeed]];
    
    
    //não foi possível implementar cálculo de altitude nesta versão
    //_slope.text = [[NSString alloc] initWithFormat:@"%.2f m", [session totalDownSlope]];
    
    [self drawRoute:coords];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[coords firstObject]coordinate], 250, 250);
    
    // Mudar a região atual para visualização de forma não-animada
    [map setRegion:region animated:NO ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (IBAction)voltarButton:(id)sender {
//    // Volta pra tela anterior
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - PolyLine

-(void)drawRoute:(NSArray*)points{
    
    // Mesmo metodo do main view para desenhar a rota no mapa, desenha a partir da lista de pontos no objeto Session
    
    CLLocationCoordinate2D coords[points.count];
    for(int i=0; i< points.count; i++){
        CLLocation *local = [points objectAtIndex:i];
        CLLocationCoordinate2D coord = local.coordinate;
        
        coords[i] = coord;
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:points.count];
    [map addOverlay:polyline];
}

#pragma mark - MKMapViewDelegate

//mesmo renderer pro overlay do mapa, igual ao usado no main view

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        // É ESSE QUE DEFINE A COR
        renderer.strokeColor = [[UIColor colorWithRed:249.0/255.0 green:66.0/225.0 blue:7.0/255.0 alpha:1] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 5;
        
        return renderer;
    }
    return nil;
}
@end

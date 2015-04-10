//
//  DetailsViewController.m
//  RunRoute
//
//  Created by TheBestGroup on 3/2/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

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
    
    // Configura o scroll view
    _scroll.scrollEnabled = YES;
    _scroll.contentSize = CGSizeMake(300, 200);
                             
    [self drawRoute:coords];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[coords firstObject]coordinate], 250, 250);
    
    // Mudar a região atual para visualização de forma não-animada
    [map setRegion:region animated:NO ];
    
    
    // Reconhecimento do gesto
    UIScreenEdgePanGestureRecognizer *leftSwipe = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    leftSwipe.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    // Muda o tipo da transição de telas
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)voltarButton:(id)sender {
    // Volta pra tela anterior
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)leftSwipe{
    // Volta pra tela anterior
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
        renderer.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 5;
        
        return renderer;
    }
    return nil;
}

@end

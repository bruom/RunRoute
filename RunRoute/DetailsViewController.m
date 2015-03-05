//
//  DetailsViewController.m
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/2/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize session, map;

- (void)viewDidLoad {
    [super viewDidLoad];
    [map setDelegate:self];
    
    _speedLabel.text = [[NSString alloc] initWithFormat:@"%.2f km/h",[session calcSpeed]];
    
    int seconds = (int)round([session calcTime]);
    NSString *timeString = [NSString stringWithFormat:@"%02u:%02u:%02u",
                            seconds / 3600, (seconds / 60) % 60, seconds % 60];
    _timeLabel.text = timeString;
    _dateLabel.text = [[NSString alloc] initWithFormat:@"%@", [session startDate]];
    _distLabel.text = [[NSString alloc] initWithFormat:@"%.2f m", [session calcDist]];
    [self drawRoute:session.points];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[session.points firstObject]coordinate], 250, 250);
    
    //Mudar a região atual para visualização de forma animada
    [map setRegion:region animated:NO ];
    
    //[map setScrollEnabled:NO];
    
    
    // Do any additional setup after loading the view.
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PolyLine

-(void)drawRoute:(NSArray*)points{
    
    // Para evitar de criar infinitas linhas e sobrecarregar a memoria

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

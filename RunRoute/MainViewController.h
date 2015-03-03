//
//  MainViewController.h
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/2/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Session.h"
#import "DataSourceSingleton.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property CLLocationManager *locationManager;
@property Session *currentSession;
@property MKPolyline *lastLine;
@property NSMutableArray* points;
@property (weak, nonatomic) IBOutlet UIButton *startButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *stopButtonOutlet;

- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;
- (IBAction)typeExercise:(id)sender;

@end

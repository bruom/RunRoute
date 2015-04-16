//
//  MainViewController.h
//  RunRoute
//
//  Created by TheBestGroup on 3/2/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Session.h"
#import "DataSourceSingleton.h"
#import "CorePersistenceManager.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property CLLocationManager *locationManager;
@property Session *currentSession;
@property MKPolyline *lastLine;
@property NSMutableArray* points;
@property (weak, nonatomic) IBOutlet UIButton *startButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *stopButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *timeDisplay;
@property (weak, nonatomic) IBOutlet UILabel *distDisplay;
@property DataSourceSingleton *dss;
@property NSTimer *nsTimer;
@property BOOL isSession;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeExercise;
@property (weak, nonatomic) IBOutlet UIView *viewType;
@property NSString* auxType;

- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;
- (IBAction)typeExercise:(id)sender;
- (IBAction)locationButton:(id)sender;

@end

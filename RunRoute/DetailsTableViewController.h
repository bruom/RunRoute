//
//  DetailsTableViewController.h
//  RunRoute
//
//  Created by João Marcos on 08/06/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Session.h"
#import "RoutePoint.h"

@interface DetailsTableViewController : UITableViewController <MKMapViewDelegate>

@property Session* session;

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeedDisplay;

//- (IBAction)voltarButton:(id)sender;

@end

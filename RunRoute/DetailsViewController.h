//
//  DetailsViewController.h
//  RunRoute
//
//  Created by TheBestGroup on 3/2/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Session.h"

@interface DetailsViewController : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate>

@property Session* session;

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeedDisplay;
@property (weak, nonatomic) IBOutlet UILabel *slope;
- (IBAction)voltarButton:(id)sender;


@end

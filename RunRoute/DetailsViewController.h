//
//  DetailsViewController.h
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/2/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Session.h"

@interface DetailsViewController : UIViewController

@property Session* session;

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
- (IBAction)voltarButton:(id)sender;


@end

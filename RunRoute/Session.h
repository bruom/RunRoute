//
//  Session.h
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/3/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Session : NSObject

@property NSArray* points;
@property float distance;
@property NSTimeInterval time;


-(float)calcDist;

-(NSTimeInterval)calcTime;

-(float)calcSpeed;

@end

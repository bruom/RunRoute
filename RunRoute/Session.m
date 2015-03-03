//
//  Session.m
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/3/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "Session.h"

@implementation Session

@synthesize points, distance, time;

-(float)calcDist{
    if(nil==points || points.count == 0){
        return 0.0;
    }
    float dist = 0.0;
    for(int i=1;i<points.count-1;i++){
        dist += (float)[[points objectAtIndex:i]distanceFromLocation:[points objectAtIndex:i+1]];
    }
    distance = dist;
    return dist;
}

-(NSTimeInterval)calcTime{
    NSDate *start = [[points firstObject]date];
    NSDate *end = [[points lastObject]date];
    NSTimeInterval aux = [end timeIntervalSinceDate:start];
    time = aux;
    return aux;
}

-(float)calcSpeed{
    return [self calcDist]/[self calcTime]*3.6;
}

@end

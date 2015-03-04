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
    for(int i=0;i<points.count-1;i++){
        dist += (float)[[points objectAtIndex:i]distanceFromLocation:[points objectAtIndex:i+1]];
    }
    distance = dist;
    return dist;
}

-(NSTimeInterval)calcTime{
    NSDate *start = [[points firstObject]timestamp];
    NSDate *end = [[points lastObject]timestamp];
    NSTimeInterval aux = [end timeIntervalSinceDate:start];
    time = aux;
    return aux;
}

-(float)calcSpeed{
    return [self calcDist]/[self calcTime]*3.6;
}

-(NSString*) startDate{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy - HH:mm"];
    
    return [df stringFromDate:[[points firstObject]timestamp]];
}

@end

//
//  Session.m
//  RunRoute
//
//  Created by Patricia de Abreu on 07/04/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "Session.h"
#import "RoutePoint.h"


@implementation Session

@dynamic date;
@dynamic distance;
@dynamic time;
@dynamic typeExercise;
@dynamic routePoints;

@synthesize points;


-(float)calcDist{
    float pit;
    if(nil==points || points.count == 0){
        return 0.0;
    }
    float dist = 0.0;
    for(int i=0;i<points.count-1;i++){
       // dist += [[points objectAtIndex:i]distanceFromLocation:[points objectAtIndex:i+1]];
        NSNumber* x = [(RoutePoint*)[points objectAtIndex:i]x];
        NSNumber* y = [(RoutePoint*)[points objectAtIndex:i+1]y];
        
        pit = sqrt(pow([x floatValue], 2)+pow([y floatValue], 2));
        dist+=pit;
        
    }
    self.distance = [NSNumber numberWithFloat:dist];
    return dist;
}

-(NSTimeInterval)calcTime{
    NSDate *start = [[points firstObject]timestamp];
    NSDate *end = [[points lastObject]timestamp];
    NSTimeInterval aux = [end timeIntervalSinceDate:start];
    
#warning tem que arrumar isso pra virar time interval
    self.time = [NSNumber numberWithFloat:aux];
    return aux;
}

-(float)calcSpeed{
    return [self calcDist]/[self calcTime]*3.6;
}

-(NSString*) startDate{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    return [df stringFromDate:[[points firstObject]timestamp]];
}

-(NSString*) startDateWithHour{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy - HH:mm"];
    
    return [df stringFromDate:[[points firstObject]timestamp]];
}

-(float)getMaxSpeed{
    float aux = 0.0;
    for(int i=0; i<points.count;i++){
        if([[[points objectAtIndex:i] speed]floatValue]>aux)
            aux = [[[points objectAtIndex:i] speed]floatValue];
    }
    return aux*3.6;
}

@end

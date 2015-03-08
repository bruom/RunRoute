//
//  Session.m
//  RunRoute
//
//  Created by TheBestGroup on 3/3/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import "Session.h"

@implementation Session

@synthesize points, distance, time, typeExercise;

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
        if([[points objectAtIndex:i] speed]>aux)
            aux = (float)[[points objectAtIndex:i] speed];
    }
    return aux*3.6;
}

-(float)totalDownSlope{
    float aux=0.0;
    float max=0.0;
    for(int i=1;i<points.count;i++){
        if([[points objectAtIndex:i] altitude]<=[[points objectAtIndex:i-1] altitude]){
            aux+=[[points objectAtIndex:i-1] altitude]-[[points objectAtIndex:i] altitude];
            NSLog(@"%f",aux);
            if(aux>max)
                max=aux;
        }
        else
            aux=0.0;
    }
    NSLog(@"%f",max);
    return max;
}

@end

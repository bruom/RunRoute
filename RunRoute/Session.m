//
//  Session.m
//  RunRoute
//
//  Created by Patricia de Abreu on 07/04/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "Session.h"
#import "RoutePoint.h"
#import <CoreLocation/CoreLocation.h>


@implementation Session

@dynamic date;
@dynamic distance;
@dynamic time;
@dynamic typeExercise;
@dynamic routePoints;

@synthesize points;


-(float)calcDist{
    
    //retorna os pontos do NSSet de forma ordenada por timestamp
    NSArray *pontosArray = [[self.routePoints allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(RoutePoint *)obj1 timestamp] compare:[(RoutePoint *)obj2 timestamp]];
    }];
    
    //float pit;
    if(nil==self.routePoints || self.routePoints.count == 0){
        return 0.0;
    }
    float dist = 0.0;
    for(int i=0;i<pontosArray.count-1;i++){
        CLLocation *coord = [[CLLocation alloc]initWithLatitude:[[(RoutePoint*)[pontosArray objectAtIndex:i]x] doubleValue] longitude:[[(RoutePoint*)[pontosArray objectAtIndex:i]y] doubleValue]];
        CLLocation *coord2 = [[CLLocation alloc]initWithLatitude:[[(RoutePoint*)[pontosArray objectAtIndex:i+1]x] doubleValue] longitude:[[(RoutePoint*)[pontosArray objectAtIndex:i+1]y] doubleValue]];
        dist += [coord distanceFromLocation:coord2];
//        float x = [[[pontosArray objectAtIndex:i+1]x] floatValue] -  [[[pontosArray objectAtIndex:i]x] floatValue];
//        float y = [[[pontosArray objectAtIndex:i+1]y] floatValue] -  [[[pontosArray objectAtIndex:i]y] floatValue];
//        
//        pit = sqrt(pow(x, 2)+pow(y, 2));
//        dist+=pit;
        
    }
    self.distance = [NSNumber numberWithFloat:dist];
    return dist;
}

-(NSTimeInterval)calcTime{
    
    //retorna os pontos do NSSet de forma ordenada por timestamp
    NSArray *pontosArray = [[self.routePoints allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(RoutePoint *)obj1 timestamp] compare:[(RoutePoint *)obj2 timestamp]];
    }];
    
    NSDate *start = [[pontosArray firstObject]timestamp];
    NSDate *end = [[pontosArray lastObject]timestamp];
    NSTimeInterval aux = [end timeIntervalSinceDate:start];
    
//#warning tem que arrumar isso pra virar time interval
    self.time = [NSNumber numberWithFloat:aux];
    return aux;
}

-(float)calcSpeed{
    return [self calcDist]/[self calcTime]*3.6;
}

-(NSString*) startDate{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    return [df stringFromDate:[[[self.routePoints allObjects] firstObject]timestamp]];
}

-(NSString*) startDateWithHour{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy - HH:mm"];
    
    return [df stringFromDate:[[[self.routePoints allObjects] firstObject]timestamp]];
}

-(float)getMaxSpeed{

    //retorna os pontos do NSSet de forma ordenada por timestamp
    NSArray *pontosArray = [[self.routePoints allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(RoutePoint *)obj1 timestamp] compare:[(RoutePoint *)obj2 timestamp]];
    }];
    
    float aux = 0.0;
    for(int i=0; i<pontosArray.count;i++){
        if([[(RoutePoint*)[pontosArray objectAtIndex:i] speed]floatValue]>aux)
            aux = [[(RoutePoint*)[pontosArray objectAtIndex:i] speed]floatValue];
    }
    return aux*3.6;
}

-(void)addPointsObject:(RoutePoint *)value{
    NSMutableSet *set = [[NSMutableSet alloc]initWithSet:self.routePoints];
    [set addObject:value];
    [self setRoutePoints:[[NSSet alloc]initWithSet:set]];
}

@end

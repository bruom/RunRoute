//
//  Session.h
//  RunRoute
//
//  Created by Patricia de Abreu on 07/04/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RoutePoint.h"

@class RoutePoint;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * typeExercise;
@property (nonatomic, retain) NSSet *routePoints;

@property NSArray *points;

@end

@interface Session (CoreDataGeneratedAccessors)

- (void)addPointsObject:(Point *)value;
- (void)removePointsObject:(Point *)value;
- (void)addPoints:(NSSet *)values;
- (void)removePoints:(NSSet *)values;


-(float)calcDist;

-(NSTimeInterval)calcTime;

-(float)calcSpeed;

-(NSString*) startDate;

-(NSString*) startDateWithHour;

-(float)getMaxSpeed;

@end

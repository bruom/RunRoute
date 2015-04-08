//
//  Point.h
//  RunRoute
//
//  Created by Patricia de Abreu on 07/04/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface RoutePoint : NSManagedObject

@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Session *session;

@end

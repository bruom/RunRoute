//
//  DataSourceSingleton.h
//  RunRoute
//
//  Created by TheBestGroup on 3/3/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@interface DataSourceSingleton : NSObject

@property NSMutableArray* sessions;

+(DataSourceSingleton *)instance;

-(void)addSession:(Session*)session;

@end

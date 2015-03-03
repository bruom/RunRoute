//
//  DataSourceSingleton.h
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/3/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@interface DataSourceSingleton : NSObject

@property NSMutableArray* sessions;

+(DataSourceSingleton *)instance;

-(void)addSession:(Session*)session;

@end

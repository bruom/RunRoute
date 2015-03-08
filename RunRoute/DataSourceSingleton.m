//
//  DataSourceSingleton.m
//  RunRoute
//
//  Created by TheBestGroup on 3/3/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import "DataSourceSingleton.h"

@implementation DataSourceSingleton

@synthesize sessions;

static DataSourceSingleton *instance;

-(instancetype)init{
    self = [super init];
    if(self){
        sessions = [[NSMutableArray alloc]init];
    }
    return self;
}

+(DataSourceSingleton *)instance{
    if(instance == nil){
        instance = [[DataSourceSingleton alloc]init];
    }
    return instance;
}

-(void)addSession:(Session *)session{
    if(nil!=session){
        [sessions addObject:session];
    }
}

@end

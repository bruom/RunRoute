//
//  Timer.m
//  RunRoute
//
//  Created by Patricia Machado de Abreu on 03/03/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "Timer.h"

@implementation Timer

-(id) init
{
    self=[super init];
    if (self != nil) {
        start = nil;
        end = nil;
    }
    return self;
}

-(void) startTimer{
    start = [NSDate date];
}

-(void) stopTimer{
    end = [NSDate date];
}

-(double) timeElapsedInSeconds{
    return [end timeIntervalSinceDate:start];
}

-(double) timeElapsedInMilliSeconds{
    return [self timeElapsedInSeconds] * 1000.0f;
}

-(double) timeElapsedInMinutes{
    return [self timeElapsedInSeconds] / 60.0f;
}

-(double) timeElapsedInHours{
    return [self timeElapsedInSeconds] / 360.0f;
}

@end

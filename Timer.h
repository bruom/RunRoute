//
//  Timer.h
//  RunRoute
//
//  Created by Patricia Machado de Abreu on 03/03/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject
{
    NSDate *start;
    NSDate *end;
}

-(void) startTimer;
-(void) stopTimer;
-(double) timeElapsedInSeconds;
-(double) timeElapsedInMilliSeconds;
-(double) timeElapsedInMinutes;
-(double) timeElapsedInHours;

@end

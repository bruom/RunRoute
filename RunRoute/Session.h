//
//  Session.h
//  RunRoute
//
//  Created by TheBestGroup on 3/3/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Session : NSObject

//array que contem os pontos da rota; a partir dos quais é possivel redesenhar e calcular todos os detalhes
@property NSArray* points;

@property float distance;
@property NSTimeInterval time;
@property NSString* typeExercise;


-(float)calcDist;

-(NSTimeInterval)calcTime;

-(float)calcSpeed;

-(NSString*) startDate;

-(NSString*) startDateWithHour;

-(float)getMaxSpeed;

//não foi possível impementar cálculo de altitude nesta versão
//-(float)totalDownSlope;
@end

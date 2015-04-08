//
//  GraficoView.m
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 4/4/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "GraficoView.h"
#import "DataSourceSingleton.h"
#import "Session.h"

@implementation GraficoView

@synthesize kDefaultGraphWidth;

- (void)lineGraphWithContext:(CGContextRef)context{
    
    float varStepX = kDefaultGraphWidth/_dados.count;
    NSLog(@"%f",varStepX);
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:.15 green:.48 blue:.8 alpha:1] CGColor]);
    
    int maxGraphHeight = kGraphHeight - kOffsetY;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * [[_dados firstObject]floatValue]);
    
    for (int i = 0; i < _dados.count; i++){
        CGContextAddLineToPoint(context, kOffsetX + i * varStepX, kGraphHeight - maxGraphHeight * [[_dados objectAtIndex:i]floatValue]);
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:.15 green:.48 blue:.8 alpha:1] CGColor]);
    
    //cria circulos inscritos a retangulos em cada data point, e entao preenche os circulos
    for (int i = 0; i < _dados.count; i++)
    {
        float x = kOffsetX + i * varStepX;
        float y = kGraphHeight - maxGraphHeight * [[_dados objectAtIndex:i] floatValue];
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(context, rect);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //cor para preencher a area do grafico
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:.15 green:.48 blue:.8 alpha:0.5] CGColor]);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * [[_dados firstObject]floatValue]);
    for (int i = 0; i < _dados.count; i++)
    {
        CGContextAddLineToPoint(context, kOffsetX + i * varStepX, kGraphHeight - maxGraphHeight * [[_dados objectAtIndex:i]floatValue]);
    }
    CGContextAddLineToPoint(context, kOffsetX + (_dados.count - 1) * varStepX, kGraphHeight);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFill);
    
    //"inverte o sistema de coordenadas da tela"; se não fizer isso, o texto vai ser escrito de cabeça para baixo
    CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    
    //colocando texto no grafico, para identificar os pontos
    CGContextSelectFont(context, "Helvetica", 14, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM"];
    
    for (int i = 0; i < _dias.count; i++){
        NSString *texto = [NSString stringWithFormat:@"%@", [formatter stringFromDate:[_dias
                                                                                       objectAtIndex:i]]];
        CGContextShowTextAtPoint(context, kOffsetX + i * varStepX - [texto sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]].width/2, kGraphBottom - 5, [texto cStringUsingEncoding:NSUTF8StringEncoding], [texto length]);
    }
    
    
}


- (void)drawRect:(CGRect)rect {
    
    
    /* VALORES PARA TESTE, DEPOIS VAMOS PEGAR ELES PELA PERSISTENCIA
     */
    _dados = [[NSMutableArray alloc]init];
    _dias = [[NSMutableArray alloc]init];
    
    for(int i=0; i<10;i++){
        if(i<[[DataSourceSingleton instance].sessions count]){
            Session *thisSession = [[DataSourceSingleton instance].sessions objectAtIndex:i];
            [_dados addObject:[NSNumber numberWithFloat:thisSession.distance/1000]];
            [_dias addObject:[[NSString alloc] initWithFormat:@"%@", [thisSession startDate]]];
        }
    }
    
    if(_dados.count==0)
       [_dados addObject:[NSNumber numberWithFloat:0.001]];
    
    float varStepX = kDefaultGraphWidth/_dados.count;
    NSLog(@"VAR STEP X = %f",varStepX);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //configura como serão traçadas as linhas da grid
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    
    //numero de linhas que cabem no grafico
    int linhasGrid = (kDefaultGraphWidth - kOffsetX) / varStepX;
    
    //desenhar a grid
    for (int i = 0; i <= linhasGrid; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * varStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * varStepX, kGraphBottom);
    }
    
    //numero de linhas horizontais que cabem
    int linhasGridHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    //desenahr linhas horizontais
    for (int i = 0; i <= linhasGridHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
    }
    
    //faz as linhas da grid serem desenhadas tracejadas
    //formato: tamanho do traço, tamanho do espaço entre traços
    CGFloat tracejado[] = {1.0, 1.0};
    CGContextSetLineDash(context, 0.0, tracejado, 2);
    
    CGContextStrokePath(context);
    
    //faz as proximas linhas não serem tracejadas
    CGContextSetLineDash(context, 0, NULL, 0);
    
    [self lineGraphWithContext:context];
    
}


@end

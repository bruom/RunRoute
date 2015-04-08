//
//  GraficoView.h
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 4/4/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraficoView : UIView

//dados para traçar o grafico
/**
 * valores entre 0.0 e 1.0 que determinam cada ponto no grafico
 */
@property NSMutableArray *dados;

@property NSMutableArray *dias;

//dimensoes do grafico
#define kGraphHeight 300
@property float kDefaultGraphWidth;

//constantes das linhas verticais
#define kOffsetX 30
#define kStepX 50

//offset do grafico na subview
#define kGraphBottom 10
#define kGraphTop 0

//constantes das linhas horizontais
#define kStepY 50
#define kOffsetY 10

//tamanho do circulo de data point
#define kCircleRadius 3

//-(instancetype)initWithDados:(NSMutableArray *)dados;

@end

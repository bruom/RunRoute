//
//  GraficoViewController.m
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 4/4/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "GraficoViewController.h"

@interface GraficoViewController ()

@end

@implementation GraficoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _graficoView.kDefaultGraphWidth = self.view.frame.size.width;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [_graficoView setNeedsDisplay];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

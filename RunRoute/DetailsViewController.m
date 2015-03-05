//
//  DetailsViewController.m
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/2/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize session;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _speedLabel.text = [[NSString alloc] initWithFormat:@"%.2f km/h",[session calcSpeed]];
    
    int seconds = (int)round([session calcTime]);
    NSString *timeString = [NSString stringWithFormat:@"%02u:%02u:%02u",
                            seconds / 3600, (seconds / 60) % 60, seconds % 60];
    _timeLabel.text = timeString;
    _dateLabel.text = [[NSString alloc] initWithFormat:@"%@", [session startDate]];
    _distLabel.text = [[NSString alloc] initWithFormat:@"%.2f m", [session calcDist]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)voltarButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

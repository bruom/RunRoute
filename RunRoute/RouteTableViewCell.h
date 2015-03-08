//
//  RouteTableViewCell.h
//  RunRoute
//
//  Created by TheBestGroup on 3/2/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

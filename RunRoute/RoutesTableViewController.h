//
//  RoutesTableViewController.h
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/2/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoutesTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)editButton:(id)sender;

@end

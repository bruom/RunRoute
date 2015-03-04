//
//  RoutesTableViewController.m
//  RunRoute
//
//  Created by Bruno Omella Mainieri on 3/2/15.
//  Copyright (c) 2015 Bruno Omella. All rights reserved.
//

#import "RoutesTableViewController.h"
#import "DataSourceSingleton.h"
#import "RouteTableViewCell.h"
#import "DetailsViewController.h"

@interface RoutesTableViewController ()

@end

@implementation RoutesTableViewController

NSArray *sessions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataSourceSingleton *dss = [DataSourceSingleton instance];
    
    sessions = dss.sessions;
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0, 0.0f, 0.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return sessions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteCell" forIndexPath:indexPath];
    long row = [indexPath row];
    
    cell.speed.text = [[NSString alloc] initWithFormat:@"%.2f km/h",[[sessions objectAtIndex:row] calcSpeed]];
    
    int seconds = (int)round([[sessions objectAtIndex:row] calcTime]);
    NSString *timeString = [NSString stringWithFormat:@"%02u:%02u:%02u",
                            seconds / 3600, (seconds / 60) % 60, seconds % 60];
                              
    cell.timeLabel.text = timeString;
    cell.dateLabel.text = [[NSString alloc] initWithFormat:@"%@", [[sessions objectAtIndex:row]startDate]];
    cell.distLabel.text = [[NSString alloc] initWithFormat:@"%.2f m", [[sessions objectAtIndex:row] calcDist]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowDetails"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailsViewController *appView = segue.destinationViewController;
        
        long row = [indexPath row];
//        NSString *speed = [[NSString alloc] initWithFormat:@"%.2f km/h",[[sessions objectAtIndex:row] calcSpeed]];
//        int seconds = (int)round([[sessions objectAtIndex:row] calcTime]);
//        
//        NSString *time = [NSString stringWithFormat:@"%02u:%02u:%02u",seconds / 3600, (seconds / 60) % 60, seconds % 60];
//        NSString *dist = [[NSString alloc] initWithFormat:@"%.2f m", [[sessions objectAtIndex:row] calcDist]];
//        NSString *date = [[NSString alloc] initWithFormat:@"%@", [[sessions objectAtIndex:row]startDate]];
//        NSArray *aux = [NSArray arrayWithObjects:speed,time,dist,date,nil];
        DataSourceSingleton* dss = [DataSourceSingleton instance];
        appView.session = [dss.sessions objectAtIndex:row];
    }
}

@end

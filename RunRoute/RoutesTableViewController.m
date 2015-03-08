//
//  RoutesTableViewController.m
//  RunRoute
//
//  Created by TheBestGroup on 3/2/15.
//  Copyright (c) 2015 TheBestGroup. All rights reserved.
//

#import "RoutesTableViewController.h"
#import "DataSourceSingleton.h"
#import "RouteTableViewCell.h"
#import "DetailsViewController.h"

@interface RoutesTableViewController ()

@end

@implementation RoutesTableViewController

NSMutableArray *sessions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataSourceSingleton *dss = [DataSourceSingleton instance];
    
    sessions = dss.sessions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

// Retorna o numero de seçoes da Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Criando a label que exibe a mensagem
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];

    // Verifica se a tableview está vazia
    if (sessions.count == 0) {
        //Se estiver vazia, exibe uma mensagem de lista vazia

        // Mensagem de tableview vazia
        messageLabel.text = @"Sem Exercícios Registrados...";
        // Tipo de alinhamento da label, centralizado
        messageLabel.textAlignment = NSTextAlignmentCenter;
        // Tamanho do texto da label
        messageLabel.font = [UIFont italicSystemFontOfSize:22];
        // Cor da label
        messageLabel.textColor = [UIColor whiteColor];

        //Coloca a label no fundo da tableview
        self.tableView.backgroundView = messageLabel;
        
        return 1;
    }
    else {
        // Se não estiver vazia apaga a mensagem
        messageLabel.text = @"";
        self.tableView.backgroundView = messageLabel;

        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return sessions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteCell" forIndexPath:indexPath];
    long row = [indexPath row];
    
    int seconds = (int)round([[sessions objectAtIndex:row] calcTime]);
    NSString *timeString = [NSString stringWithFormat:@"%02u:%02u:%02u",
                            seconds / 3600, (seconds / 60) % 60, seconds % 60];
                              
    cell.timeLabel.text = timeString;
    cell.dateLabel.text = [[NSString alloc] initWithFormat:@"%@", [[sessions objectAtIndex:row]startDate]];
    cell.distLabel.text = [[NSString alloc] initWithFormat:@"%.2f m", [[sessions objectAtIndex:row] calcDist]];
    
    NSString *aux = [[sessions objectAtIndex:row] typeExercise];
    
    if ([aux isEqualToString:@"Walk"]){
        NSLog(@"%@", aux);
        cell.image.image =[UIImage imageNamed: @"walkicon.png"];
    }
    if ([aux isEqualToString:@"Run"])
        cell.image.image =[UIImage imageNamed: @"runicon.png"];
    if([aux isEqualToString:@"Bike"])
        cell.image.image =[UIImage imageNamed: @"bikeicon.png"];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [sessions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

- (IBAction)editButton:(id)sender {
    // Transforma o botão da navigation bar
    if (self.editing == YES) {
        self.editing = NO;
        _editButton.title = @"Editar";
    }
    else{
        self.editing = YES;
        _editButton.title = @"Ok";
    }
}

@end

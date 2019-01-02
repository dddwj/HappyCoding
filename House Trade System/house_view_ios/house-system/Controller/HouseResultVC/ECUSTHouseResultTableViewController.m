//
//  ECUSTHouseResultTableViewController.m
//  house-system
//
//  Created by 董文杰 on 2018/12/27.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "ECUSTHouseResultTableViewController.h"
#import "HouseItem.h"
#import "ECUSTEditHouseViewController.h"
@interface ECUSTHouseResultTableViewController ()/* <UITableViewDataSource,UITableViewDelegate> */
@property (nonatomic, strong) HouseItem* selectedHouse;
@end

@implementation ECUSTHouseResultTableViewController




- (void)viewDidLoad {
    [super viewDidLoad];
//    self.resultField.text =  [[NSString alloc]initWith:self.searchResult encoding:NSUTF8StringEncoding];
//    NSLog(@"text field: %@",self.resultField.text);
    NSLog(@"searchResult: %@", self.searchResult);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.imageView.image = [UIImage imageNamed:@"house.jpg"];
    cell.detailTextLabel.numberOfLines = 6;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;

    HouseItem *house = self.searchResult[indexPath.row];
    NSLog(@"house: %@",house);
    cell.textLabel.text = [NSString stringWithFormat:@"总价：%@", house.total];    // 数字必须强制转为字符串
    cell.detailTextLabel.text = [NSString stringWithFormat:@"房源编号：%@\n房子面积：%@\n小区：%@，朝向：%@", house.ID, house.acreage, house.diskName, house.direction];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    self.selectedHouse = self.searchResult[row];
    NSLog(@"Clicked Row Index: %ld", (long)row);
    [self performSegueWithIdentifier:@"editHouseVC" sender:nil];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ECUSTEditHouseViewController* editVC = (ECUSTEditHouseViewController *)segue.destinationViewController;
    editVC.house = self.selectedHouse;
    editVC.user = self.user;
    editVC.fromVC = self.fromVC;
}
 

@end

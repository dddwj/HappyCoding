//
//  ECUSTEditHouseTableViewController.m
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "ECUSTEditHouseViewController.h"

@interface ECUSTEditHouseViewController ()
//@property (nonatomic,strong) NSMutableArray* data;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UITextField *totalTextF;

@end

@implementation ECUSTEditHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Received House ID: %@", self.house.ID);
    self.IDLabel.text = self.house.ID;
    self.totalTextF.text = self.house.total;
    
//    self.data = [NSMutableArray array];
//    [self.data addObject:self.house.ID];
//    [self.data addObject:self.house.total];
//    [self.data addObject:self.house.acreage];
//    [self.data addObject:self.house.diskName];
//    [self.data addObject:self.house.direction];
//    [self.tableView reloadData];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 3;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.data.count;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    static NSString *ID = @"CELLID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//    }
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    cell.imageView.image = [UIImage imageNamed:@"house.jpg"];
//    cell.detailTextLabel.numberOfLines = 6;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
//    switch (indexPath.row) {
//        case 0:
//            cell.textLabel.text = [NSString stringWithFormat:@"唯一识别号：%@",self.data[0]];    // 数字必须强制转为字符串
//            break;
//        case 1:
//            cell.textLabel.text = [NSString stringWithFormat:@"总价：%@", self.data[1]];
//            break;
//        default:
//            cell.textLabel.text = [NSString stringWithFormat:@"信息"];
//            break;
//    }
//    cell.textLabel.text = @"input string";
//    cell.textInputMode =
//
//    return cell;
//}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

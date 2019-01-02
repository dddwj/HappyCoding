//
//  ECUSTEditHouseViewController.m
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "ECUSTEditHouseViewController.h"
#import "ECUSTMainViewController.h"

@interface ECUSTEditHouseViewController ()
//@property (nonatomic,strong) NSMutableArray* data;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UITextField *totalTextF;
@property (weak, nonatomic) IBOutlet UITextField *directionTextF;
@property (weak, nonatomic) IBOutlet UITextField *diskNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *acreageTextF;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteHouseBtn;

@end

@implementation ECUSTEditHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Updating House ID: %@", self.house.ID);
    self.IDLabel.text = [NSString stringWithFormat:@"%@", self.house.ID];
    self.totalTextF.text = [NSString stringWithFormat:@"%@", self.house.total];
    self.directionTextF.text = [NSString stringWithFormat:@"%@", self.house.direction];
    self.diskNameTextF.text = [NSString stringWithFormat:@"%@", self.house.diskName];
    self.diskNameTextF.enabled = NO;
    self.acreageTextF.text = [NSString stringWithFormat:@"%@", self.house.acreage];
    if([self.fromVC isEqualToString:@"ECUSTSearchHouseViewController"]){
        self.totalTextF.enabled = NO;
        self.directionTextF.enabled = NO;
        self.acreageTextF.enabled = NO;
        self.updateBtn.title = @"购买！";
        self.deleteHouseBtn.hidden = YES;
    }
    //    self.data = [NSMutableArray array];
    //    [self.data addObject:self.house.ID];
    //    [self.data addObject:self.house.total];
    //    [self.data addObject:self.house.acreage];
    //    [self.data addObject:self.house.diskName];
    //    [self.data addObject:self.house.direction];
    //    [self.tableView reloadData];
}

- (IBAction)updateHouseBtnClick:(id)sender {
    if([self.fromVC isEqualToString:@"ECUSTSearchHouseViewController"]){
        return;
    }
    HouseItem* house = [HouseItem itemWithID:self.house.ID total:self.totalTextF.text acreage:self.acreageTextF.text diskName:self.diskNameTextF.text direction:self.directionTextF.text address: @"Edited by ios"];
    [self doUpdate: house];

}
- (IBAction)deleteHouseBtnClick:(id)sender {
    HouseItem* house = [HouseItem itemWithID:self.house.ID total:self.totalTextF.text acreage:self.acreageTextF.text diskName:self.diskNameTextF.text direction:self.directionTextF.text address:@"Edited by ios"];
    [self doDelete: house];
}

//NSURLSession
-(void)doUpdate: (HouseItem*) updatingHouse{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // 地址
//    NSURL* url = [NSURL URLWithString:@"http://localhost:8090/controlHouse/update"];
    NSURL* url = [NSURL URLWithString:@"http://101.132.154.2:8090/controlHouse/update"];
    // 请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    // 超时
    request.timeoutInterval = 2;
    // 请求方式
    request.HTTPMethod = @"POST";
    
    // 设置请求体和参数
    NSDictionary* userInfo = @{
                               @"userID": self.user.userID,
                               @"houseID": updatingHouse.ID,
                               @"address": @"edited by ios",
                               @"diskName": updatingHouse.diskName,
                               @"acreage": updatingHouse.acreage,
                               @"direction": updatingHouse.direction,
                               @"total": updatingHouse.total
                               };
    // OC对象转JSON
    NSData* json = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    // 设置请求头
    request.HTTPBody = json;
    // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //3.获得会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@", response);
        NSDictionary *data_dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//        NSString* data_str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"updating_response_Data: %@", data_dict);
        // 错误判断
        if (error||data_dict[@"error"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法更新数据" message:@"网络遇到问题" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更新成功！" message:@"请重新查询你的挂牌房源" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
            /*
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray *temArray = self.navigationController.viewControllers;
                for(UIViewController *temVC in temArray){
                    if ([temVC isKindOfClass:[ECUSTMainViewController class]]){
                        [self.navigationController popToViewController:temVC animated:YES];
                    }
                }
            });
              */
        }
        
        // 唤醒等待的信号量
        dispatch_semaphore_signal(semaphore);
    }];
    
    //5.执行任务
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}


//NSURLSession
-(void)doDelete: (HouseItem*) updatingHouse{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // 地址
//    NSURL* url = [NSURL URLWithString:@"http://localhost:8090/controlHouse/delete"];
    NSURL* url = [NSURL URLWithString:@"http://101.132.154.2:8090/controlHouse/delete"];
    // 请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    // 超时
    request.timeoutInterval = 2;
    // 请求方式
    request.HTTPMethod = @"POST";
    
    // 设置请求体和参数
    NSDictionary* userInfo = @{
                               @"userID": self.user.userID,
                               @"houseID": updatingHouse.ID
                               };
    // OC对象转JSON
    NSData* json = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    // 设置请求头
    request.HTTPBody = json;
    // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //3.获得会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSLog(@"%@", response);
        NSDictionary *data_dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //        NSString* data_str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"updating_response_Data: %@", data_dict);
        // 错误判断
        if (error||data_dict[@"error"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法删除" message:@"网络遇到问题" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除成功！" message:@"请重新查询你的挂牌房源" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
        
        // 唤醒等待的信号量
        dispatch_semaphore_signal(semaphore);
    }];
    
    //5.执行任务
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
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

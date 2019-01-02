//
//  ECUSTSellHouseViewController.m
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "ECUSTSellHouseViewController.h"
#import "ECUSTSellDetailViewController.h"
#import "DiskEntity.h"

@interface ECUSTSellHouseViewController ()
@property (weak, nonatomic) IBOutlet UITextField *diskNameTextF;
@property (strong, nonatomic) DiskEntity* selectedDisk;
@end

@implementation ECUSTSellHouseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Received User: %@", self.user.userID);
    // Do any additional setup after loading the view.
}


- (IBAction)confirmBtnClick:(id)sender {
    NSString* diskName = self.diskNameTextF.text;
    NSLog(@"%@",diskName);
    [self doSearchWithDiskName: diskName];
}

-(void) doSearchWithDiskName: (NSString*) diskName{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // 地址
//    NSURL* url = [NSURL URLWithString:@"http://localhost:8090/selectDiskID"];
    NSURL* url = [NSURL URLWithString:@"http://101.132.154.2:8090/selectDiskID"];
    // 请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    // 超时
    request.timeoutInterval = 2;
    // 请求方式
    request.HTTPMethod = @"POST";
    
    // 设置请求体和参数
    NSDictionary* diskInfo = @{
                               @"DiskName": diskName    // 注意接口中"DiskName"的D是大写的！
                               };
    // OC对象转JSON
    NSData* json = [NSJSONSerialization dataWithJSONObject:diskInfo options:NSJSONWritingPrettyPrinted error:nil];
    
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
        NSLog(@"selecting_response_Data: %@", data_dict);
        // 错误判断
        if (error||data_dict[@"error"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络问题" message:@"请重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else if([data_dict[@"diskID"] isEqualToString:@"Not Found!"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法找到小区数据" message:@"请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else{
            self.selectedDisk = [DiskEntity initWithID:data_dict[@"diskID"]
                                              diskName:diskName];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"sellDetailVC" sender:nil];
            });
        }
        
        // 唤醒等待的信号量
        dispatch_semaphore_signal(semaphore);
    }];
    
    //5.执行任务
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"sellDetailVC"]){
        ECUSTSellDetailViewController *detailVC = (ECUSTSellDetailViewController *)segue.destinationViewController;
        detailVC.disk = self.selectedDisk;
        detailVC.user = self.user;
    }
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

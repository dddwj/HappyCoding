//
//  ECUSTMainViewController.m
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "ECUSTMainViewController.h"
#import "HouseItem.h"
#import "ECUSTHouseResultTableViewController.h"
#import "ECUSTSearchHouseViewController.h"
#import "ECUSTSellHouseViewController.h"

@interface ECUSTMainViewController ()

@property NSMutableArray* searchResult;


@end

@implementation ECUSTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"欢迎你，%@",self.user.userName];
    
}

//-(void) setAccountName:(NSString *)accountName{     // 重写setter方法，用于接收accountName参数
//    _accountName = accountName;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logOut:(id)sender {
    UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:@"确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定退出" otherButtonTitles: nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)searchDiskBtnClick:(id)sender {
    [self performSegueWithIdentifier:@"searchDiskVC" sender:nil];
}
- (IBAction)sellHouseBtnClick:(id)sender {
    if([self.user.userName  isEqual: @"游客"]){
        UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:@"你还没有登录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"去登录" otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    }
    else{
        [self performSegueWithIdentifier:@"sellHouseVC" sender:nil];
    }
}

- (IBAction)managerBtnClick:(id)sender {
    if([self.user.userName  isEqual: @"游客"]){
        UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:@"你还没有登录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"去登录" otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    }
    else{
        [self doSearch: self.user.userName];
    }
    
}

//NSURLSession
-(void)doSearch: (NSString*) userName{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // 地址
//    NSURL* url = [NSURL URLWithString:@"http://localhost:8090/selectUserHouses"];
    NSURL* url = [NSURL URLWithString:@"http://101.132.154.2:8090/selectUserHouses"];
    // 请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    // 超时
    request.timeoutInterval = 2;
    // 请求方式
    request.HTTPMethod = @"POST";
    
    // 设置请求体和参数
    NSDictionary* userInfo = @{
                               @"userID": self.user.userID
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
                NSLog(@"%@", response);
        //        NSLog(@"%lu", data.length);
        // 错误判断
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取数据" message:@"网络遇到问题" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else if(data.length == 2){ // 要是查询结果为空，服务器返回的是字符串"[]",因此length为2。
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取数据" message:@"不存在你挂牌的房源" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else{
            
            /* JSON数据格式和OC对象的一一对应关系
             {} -> 字典
             [] -> 数组
             "" -> 字符串
             */
            
            NSArray* result_arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //            NSLog(@"array: %@", result_arr);
            //            NSLog(@"array[0]: %@", result_arr[0]);
            //            NSLog(@"array[0]: %@", result_arr[0][@"address"]);
            self.searchResult = [NSMutableArray array];     //实例化，分配地址
            NSLog(@"%@",result_arr);
            for (NSInteger count = 0; count < result_arr.count; count++) {
                HouseItem *h = [HouseItem itemWithID:result_arr[count][@"id"]
                                               total:result_arr[count][@"total"]
                                             acreage:result_arr[count][@"acreage"]
                                            diskName:result_arr[count][@"diskName"]
                                           direction:result_arr[count][@"direction"]
                                        address:@"Haven't built"];
                [self.searchResult addObject: h];
                //                NSLog(@"House: %@", h);
            }
            //            NSLog(@"houseResults: %@", self.houseResults);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"myHouseVC" sender:nil];
            });
        }
        
        // 唤醒等待的信号量
        dispatch_semaphore_signal(semaphore);
    }];
    
    //5.执行任务
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{        //把参数传入下一个跳转到的页面，由performSegueWithIdentifier自动调用
    NSLog(@"destinationVC: %@",segue.destinationViewController);
    NSLog(@"sourceVC: %@",segue.sourceViewController);
    NSLog(@"identifier: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"myHouseVC"]){
        ECUSTHouseResultTableViewController *resultVC = (ECUSTHouseResultTableViewController *)segue.destinationViewController;
        resultVC.searchResult = self.searchResult;
        resultVC.user = self.user;
        resultVC.fromVC = @"ECUSTMainViewController";
    }else if([segue.identifier isEqualToString:@"searchDiskVC"]){
        ECUSTSearchHouseViewController *searchVC = (ECUSTSearchHouseViewController *)segue.destinationViewController;
        searchVC.user = self.user;
    }else if([segue.identifier isEqualToString:@"sellHouseVC"]){
        ECUSTSellHouseViewController *sellVC = (ECUSTSellHouseViewController*)segue.destinationViewController;
        sellVC.user = self.user;
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


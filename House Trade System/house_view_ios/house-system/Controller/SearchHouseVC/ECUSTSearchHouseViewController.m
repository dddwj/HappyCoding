//
//  ECUSTSearchHouseViewController.m
//  house-system
//
//  Created by 董文杰 on 2018/12/27.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "ECUSTSearchHouseViewController.h"
#import "ECUSTHouseResultTableViewController.h"
#import "HouseItem.h"

@interface ECUSTSearchHouseViewController ()
@property (weak, nonatomic) IBOutlet UITextField *diskNameField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtn;

@property NSData *searchResult;
@property NSMutableArray *houseResults;
@end

@implementation ECUSTSearchHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)searchBtnClick:(id)sender {
    NSString* diskName = self.diskNameField.text;
    [self doSearch: diskName];
    
}





//NSURLSession
-(void)doSearch: (NSString*) diskName{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    NSString *unicodeURL = [NSString stringWithFormat:@"http://localhost:8090/selectByXiaoqu/%@", [diskName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSString *unicodeURL = [NSString stringWithFormat:@"http://101.132.154.2:8090/selectByXiaoqu/%@", [diskName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
//    NSLog(@"%@", unicodeURL);
    
    //1. 创建一个网络请求
    NSURL *url = [NSURL URLWithString: unicodeURL];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
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
//        NSLog(@"%lu", data.length);
        // 错误判断
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取数据" message:@"网络遇到问题" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else if(data.length == 2){ // 要是查询结果为空，服务器返回的是字符串"[]",因此length为2。
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取数据" message:@"不存在该小区下的房源" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else{
            self.searchResult = data;
            
            /* JSON数据格式和OC对象的一一对应关系
             {} -> 字典
             [] -> 数组
             "" -> 字符串
             */
            
            NSArray* result_arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"array: %@", result_arr);
//            NSLog(@"array[0]: %@", result_arr[0]);
//            NSLog(@"array[0]: %@", result_arr[0][@"address"]);
            self.houseResults = [NSMutableArray array];     //实例化，分配地址
//            NSLog(@"%@",result_arr);
            for (NSInteger count = 0; count < result_arr.count; count++) {
                HouseItem *h = [HouseItem itemWithID:result_arr[count][@"id"]
                                              total:result_arr[count][@"total"]
                                            acreage:result_arr[count][@"acreage"]
                                            diskName:result_arr[count][@"diskName"]
                                           direction: @"服务器不支持"
                                             address:result_arr[count][@"address"]];
                [self.houseResults addObject: h];
//                NSLog(@"House: %@", h);
            }
//            NSLog(@"houseResults: %@", self.houseResults);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"searchResultVC" sender:nil];
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
    
    ECUSTHouseResultTableViewController *resultVC = (ECUSTHouseResultTableViewController *)segue.destinationViewController;
    resultVC.searchResult = self.houseResults;
    resultVC.fromVC = @"ECUSTSearchHouseViewController";
}



@end

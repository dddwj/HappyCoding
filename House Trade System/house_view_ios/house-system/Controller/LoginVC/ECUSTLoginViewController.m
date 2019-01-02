//
//  ECUSTLoginViewController.m
//  house-system
//
//  Created by 董文杰 on 2018/12/26.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "ECUSTLoginViewController.h"
#import "ECUSTMainViewController.h"
#import "UserEntity.h"

//#import "AFNetworking/AFNetworking/AFNetworking.h"
//#import "AFNetworking/AFNetworking/AFHTTPSessionManager.h"

@interface ECUSTLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *remPwdSwitch;
@property UserEntity *user;
@property NSString *userName;
@property NSString *userID;

@end

@implementation ECUSTLoginViewController
- (IBAction)loginBtnClick:(UIButton *)sender {
    NSString* userID = self.accountTextF.text;
    NSString* password = self.pwdTextF.text;
    NSInteger success = [self validate:userID password:password];
    if(success){
        [self performSegueWithIdentifier:@"loginVC" sender:nil];
    }
//   这一部分逻辑已经放到URLSession中完成了。 这里注释掉。
//    if(success){
//        [self performSegueWithIdentifier:@"loginVC" sender:nil];
//    }else{
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"无法登录" message:@"用户名错误" preferredStyle:UIAlertControllerStyleActionSheet];
//
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//            NSLog(@"点击了取消");
//
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//
//        [alertVC addAction:action];
//
//        [self presentViewController:alertVC animated:YES completion:nil];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginBtn.enabled = NO;
    
    // 监听账号密码同时有的时候，才可以点击登录按钮.
//    self.accountTextF.delegate = self;
//    self.pwdTextF.delegate = self;
    [self.accountTextF addTarget:self action: @selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextF addTarget:self action: @selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChange{
    if (self.accountTextF.text.length && self.pwdTextF.text.length){
            self.loginBtn.enabled = YES;
        }else{
            self.loginBtn.enabled = NO;
        }
}


// 使用代理的方法
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{   // return NO to not change text
//    NSLog(@"%@",string);
//    if (self.accountTextF.text.length && self.pwdTextF.text.length){
//        self.loginBtn.enabled = YES;
//    }else{
//        self.loginBtn.enabled = NO;
//    }
//    return YES;
//}


- (IBAction)remPwdChange:(UISwitch *)sender {
    if(self.remPwdSwitch.on == NO){
//        self.autoLoginSwitch.on = NO;  不带动画效果
        [self.autoLoginSwitch setOn:NO animated:YES];
    }
    
}


- (IBAction)autoLoginChange:(UISwitch *)sender {
    if(self.autoLoginSwitch.on == YES){
        [self.remPwdSwitch setOn:YES animated:YES];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) validate: (NSString *) userName password: (NSString *) password{
    __block NSInteger status = 0;       // 函数内部的变量需要使用__block修饰，这样才能在后面赋值。
    
    NSLog(@"%@-----%@",userName,password);
//    NSString *unicodeURL = [NSString stringWithFormat:@"http://localhost:8090/login/%@", [@"" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSString *unicodeURL = [NSString stringWithFormat:@"http://101.132.154.2:8090/login/%@", [@"" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSLog(@"%@", unicodeURL);
    
    //创建信号量，使用信号量机制实现:化异步为同步。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // 地址
//    NSURL* url = [NSURL URLWithString:@"http://localhost:8090/user/login"];
    NSURL* url = [NSURL URLWithString:@"http://101.132.154.2:8090/user/login"];
    
    // 请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    // 超时
    request.timeoutInterval = 2;
    // 请求方式
    request.HTTPMethod = @"POST";
    
    // 设置请求体和参数
    // 创建一个描述订单的JSON数据
    NSDictionary* userInfo = @{
                              @"userID": userName,
                              @"password": password
                              };
    // OC对象转JSON
    NSData* json = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    // 设置请求头
    request.HTTPBody = json;
    // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 错误判断
        if (data==nil||error){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法登录" message:@"网络遇到问题" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
            status = 0;
            // return;
        }else{
            // 解析JSON
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dic);
            NSString* result = dic[@"data"];
            if([result isEqualToString:@"User not exists!"]){
                status = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法登录" message:@"用户不存在" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];
                });
           }else if([result isEqualToString:@"Wrong Password!"]){
               status = 0;
               dispatch_async(dispatch_get_main_queue(), ^{
                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法登录" message:@"密码错误" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                   [alert show];
               });
           }else{
//               self.userName = dic[@"userName"];
//               self.userID = userName;
               self.user = [UserEntity initWithID:userName
                                         userName:dic[@"userName"]];
//               NSLog(@"%@",result);
//               NSLog(@"%@",dic[@"userName"]);
               status = 1;
           }
        }
        
        // 唤醒等待的信号量
        dispatch_semaphore_signal(semaphore);
    }];
    
    // 执行请求
    [task resume];
    
    // 等待网络请求结束后的唤醒
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return status;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{        //把参数传入下一个跳转到的页面，由performSegueWithIdentifier自动调用
    NSLog(@"%@",segue.destinationViewController);
    NSLog(@"%@",segue.sourceViewController);
    
    NSLog(@"%@",sender);
    ECUSTMainViewController *mainVC = (ECUSTMainViewController *)segue.destinationViewController;
//        mainVC.accountName = self.userName;
//        mainVC.userID = self.userID;
        mainVC.user = self.user;
}


- (IBAction)guestBtnClick:(id)sender {
    self.user = [UserEntity initWithID:@"0"
                                    userName:@"游客"];
    [self performSegueWithIdentifier:@"loginVC" sender:nil];
    
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

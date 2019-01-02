//
//  ECUSTMainViewController.h
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface ECUSTMainViewController : UIViewController
// 用于接受上一页传来的参数
@property (nonatomic, strong) UserEntity *user;
@end

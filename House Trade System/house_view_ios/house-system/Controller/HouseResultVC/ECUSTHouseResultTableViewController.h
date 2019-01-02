//
//  ECUSTHouseResultTableViewController.h
//  house-system
//
//  Created by 董文杰 on 2018/12/27.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface ECUSTHouseResultTableViewController : UITableViewController

@property (nonatomic, strong) UserEntity* user;
@property (nonatomic, strong) NSMutableArray *searchResult;    // 用于接受上一页传来的参数
@property (nonatomic, strong) NSString* fromVC;


@end

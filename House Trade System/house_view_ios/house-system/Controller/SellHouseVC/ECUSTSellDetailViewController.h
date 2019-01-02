//
//  ECUSTSellDetailViewController.h
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiskEntity.h"
#import "UserEntity.h"
#import "HouseItem.h"

@interface ECUSTSellDetailViewController : UIViewController
@property (strong, nonatomic) UserEntity* user;
@property (strong, nonatomic) DiskEntity* disk;
@property (strong, nonatomic) HouseItem* house;
@end

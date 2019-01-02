//
//  ECUSTSearchHouseViewController.h
//  house-system
//
//  Created by 董文杰 on 2018/12/27.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECUSTHouseResultTableViewController.h"
#import "UserEntity.h"
@interface ECUSTSearchHouseViewController : UIViewController
@property (nonatomic, strong) UserEntity* user;
@property (nonatomic, strong) ECUSTSearchHouseViewController *resultVC;
@end

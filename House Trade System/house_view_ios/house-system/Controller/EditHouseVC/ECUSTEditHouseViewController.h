//
//  ECUSTEditHouseViewController.h
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseItem.h"
#import "UserEntity.h"

@interface ECUSTEditHouseViewController : UIViewController
@property (nonatomic, strong) HouseItem* house;
@property (nonatomic, strong) UserEntity* user;
@property (nonatomic, strong) NSString* fromVC;
@end

//
//  HouseItem.m
//  house-system
//
//  Created by 董文杰 on 2018/12/27.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "HouseItem.h"

@implementation HouseItem

+ (instancetype) itemWithID:(NSString *)ID
                      total:(NSString *)total
                    acreage:(NSString *)acreage
                   diskName:(NSString*) diskName
                  direction:(NSString *) direction
                    address:(NSString*) address{
    HouseItem *house = [[HouseItem alloc] init];
    house.acreage = acreage;
    house.ID = ID;
    house.total = total;
    house.diskName = diskName;
    house.direction = direction;
    house.address = address;
    return house;
}
@end

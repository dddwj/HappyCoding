//
//  DiskEntity.m
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "DiskEntity.h"

@implementation DiskEntity

+ (instancetype) initWithID: (NSString*) diskID
                   diskName: (NSString*) diskName{
    DiskEntity* disk = [[DiskEntity alloc] init];
    disk.diskID = diskID;
    disk.diskName = diskName;
    return disk;
}

@end

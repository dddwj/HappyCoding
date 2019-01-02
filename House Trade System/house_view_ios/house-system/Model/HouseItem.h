//
//  HouseItem.h
//  house-system
//
//  Created by 董文杰 on 2018/12/27.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseItem : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *acreage;
@property (nonatomic, strong) NSString *diskName;
@property (nonatomic, strong) NSString *direction;
@property (nonatomic, strong) NSString *address;

+ (instancetype) itemWithID:(NSString *)ID total:(NSString *)total acreage:(NSString *)acreage diskName: (NSString*) diskName direction: (NSString *) direction address: (NSString*) address;


@end

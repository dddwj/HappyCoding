//
//  DiskEntity.h
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskEntity : NSObject
@property (nonatomic, strong) NSString* diskName;
@property (nonatomic, strong) NSString* diskID;
+ (instancetype) initWithID: (NSString*) diskID
                   diskName: (NSString*) diskName;

@end

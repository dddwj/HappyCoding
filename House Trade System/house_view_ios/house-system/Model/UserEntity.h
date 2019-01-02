//
//  UserEntity.h
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* userID;

+ (instancetype) initWithID: (NSString*) userID
                   userName: (NSString*) userName;

@end

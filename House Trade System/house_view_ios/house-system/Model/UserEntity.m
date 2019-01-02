//
//  UserEntity.m
//  house-system
//
//  Created by 董文杰 on 2018/12/28.
//  Copyright © 2018年 董文杰. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

+ (instancetype) initWithID: (NSString*) userID
                   userName: (NSString*) userName{
    UserEntity* user = [[UserEntity alloc] init];
    user.userID = userID;
    user.userName = userName;
    return user;
}


@end

//
//  TXUserModel.m
//  TailorX
//
//  Created by Qian Shen on 24/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXUserModel.h"
#import "TXModelAchivar.h"
#import <objc/runtime.h>

@implementation TXUserModel

+ (TXUserModel *)defaultUser {
    static TXUserModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [TXModelAchivar unachiveUserModel];
        if (!model) {
            model = [[TXUserModel alloc]init];
            model.isShowLeading = true;
            model.unreadMsgCount = 0;
            // 默认定位为成都市
            model.longitude = @"104.064095";
            model.latitude = @"30.551882";
        }
    });
    return model;
}

MJCodingImplementation

/**
 * 字典转模型
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    [[TXUserModel defaultUser] setValuesForKeysWithDictionary:dictionary];
    return [TXUserModel defaultUser];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setUnreadMsgCount:(NSInteger)unreadMsgCount {
    _unreadMsgCount = unreadMsgCount;
    // [[UIApplication sharedApplication] setApplicationIconBadgeNumber: unreadMsgCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationFindUnreadMsgCount object:nil userInfo:nil];
}

/**
 * 清楚用户数据
 */
- (void)resetModelData {
    self.isUnreadMessages = NO;
    self.hxLoginStatus = false;
    self.isLogin = @"0";
    self.st = @"UTOUU-ST-INVALID";
    self.tgt = nil;
    self.password = nil;
    self.udid = nil;
    self.deviceToken = nil;
    self.password = nil;
    self.account = nil;
    
    self.address = nil;
    self.genderText = nil;
    self.nickName = nil;
    self.phone = nil;
    self.photo = nil;
    self.userId = 0;
    self.height = 0;
    self.weight = 0;
    self.mobileBindDate = 0;
    self.unreadMsgCount = 0;
    
    self.hasBodyData = false;
    self.hasFinishCustomerInfo = false;
    self.payBind = false;
    self.weixinBind = false;
    self.qqBind = false;
    self.realAuth = false;
    
    self.accessToken = nil;
    self.unionId = nil;
    self.openId = nil;
    self.videoPath = nil;
}

/**
 判断用户登录状态
 
 @return true：登录 false：未登录
 */
- (BOOL)userLoginStatus {
    return [[TXModelAchivar getUserModel].isLogin isEqualToString:@"1"];
}

@end

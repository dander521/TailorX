//
//  TXKfLoginManager.m
//  TailorX
//
//  Created by Qian Shen on 2/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXKfLoginManager.h"


@implementation TXKfLoginManager

/**
 * 登录IM
 */
+ (void)loginKefuSDKcomplete:(void (^)(bool success))complete {
    HChatClient *client = [HChatClient sharedClient];
    if (client.isLoggedInBefore) {
        if (complete) {
            NSLog(@"环信登录成功");
            EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
            emoptions.displayStyle = EMPushDisplayStyleMessageSummary;
            [[EMClient sharedClient] updatePushOptionsToServer];
            complete(YES);
        }
    }else {
        [self registerIMuserComplete:^(bool success) {
            [self loginComplete:^(bool success) {
                if (complete) {
                    complete(success);
                    if (success) {
                        NSLog(@"环信登录成功");
                        EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
                        emoptions.displayStyle = EMPushDisplayStyleMessageSummary;
                        [[EMClient sharedClient] updatePushOptionsToServer];
                    }else {
                        NSLog(@"环信登录失败");
                    }
                }
            }];
        }];
    }
}

+ (BOOL)loginComplete:(void (^)(bool success))complete {
    NSString *userName = nil;
    if (![NSString isTextEmpty:GetUserInfo.accountA]) {
        userName = [NSString stringWithFormat:@"tailorx%@",GetUserInfo.accountA];
    }
    HError *error = [[HChatClient sharedClient] loginWithUsername:userName password:HX_PassWord];
    if (!error) { //IM登录成功
        complete(YES);
    } else { //登录失败
        NSLog(@"登录失败 error code :%d,error description:%@",error.code,error.errorDescription);
        complete(NO);
    }
    return NO;
}

+ (void)registerIMuserComplete:(void (^)(bool success))complete { //举个栗子。注册建议在服务端创建环信id与自己app的账号一一对应，\
    而不要放到APP中，可以在登录自己APP时从返回的结果中获取环信账号再登录环信服务器
    HError *error = nil;
    NSString *userName = nil;
    if (![NSString isTextEmpty:GetUserInfo.accountA]) {
        userName = [NSString stringWithFormat:@"tailorx%@",GetUserInfo.accountA];
    }else {
        // 跳转登录页
    }
    error = [[HChatClient sharedClient] registerWithUsername:userName password:HX_PassWord];
    if (error) {
        complete(NO);
        NSLog(@"error.code = %zd errorDescription = %@",error.code,error.errorDescription);
    }else {
        complete(YES);
    }
}

@end

//
//  TXServiceUtil.h
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXNavigationViewController.h"

@interface TXServiceUtil : NSObject

/**
 * 获取ST
 */

+ (void) getSTbyTGT:(NSString*)tgt
                url:(NSString*)url
            success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success
            failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure;

/**
 * 获取头部参数
 */
+ (NSMutableDictionary *)getSTHeadDictionary:(NSDictionary *)dic_params
                                      strurl:(NSString*)url;

/**
 跳转到登录页面
 
 @param target 推送控制器，要求推送控制带导航条
 */
+ (BOOL)LoginController:(TXNavigationViewController *)target;

/**
 退出登录
 */
+ (void)logout;

/**
 强行跳转到登录页面
 
 @param target 推送控制器，要求推送控制带导航条
 */

+ (void)loginViewControllerWithTarget:(UINavigationController*)target;

@end

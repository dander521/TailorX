//
//  PassportRequest.h
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ReqCompletion)(id obj,NSError * error);

@interface PassportRequest : NSObject

/**
 登录
 
 @param parame 登录参数
 @param compeletion 回调
 */
+ (void)loginRequestWithParame:(NSDictionary *)parame
               compeletion:(ReqCompletion)compeletion;

/**
 获取短信验证码
 
 @param headDic 请求参数
 @param callback 回调
 */
+ (void)getMessageVerifycodeWithDic:(NSDictionary *)bodyDic completion:(ReqCompletion)completion;


/**
 找回密码时的短信验证
 
 @param password 请求参数
 
 @param callback 回调
 */
+ (void)verifyMessageWithDic:(NSDictionary *)bodyDic completion:(ReqCompletion)completion;

/**
 注册
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+ (void)registerUserAccountWithDic:(NSDictionary *)bobyDic completion:(ReqCompletion)completion;

/**
 获取图形验证码
 
 @param callback 回调
 */
+ (void)applyforTxVerifyCodeCompletion:(ReqCompletion)completion;

/**
 重新发送找回密码验证码(找回密码时使用)
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+(void)getForgotYourPasswordAgain:(NSString *)phone completion:(ReqCompletion)completion;
/**
 发送找回密码验证码
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+(void)getForgotYourPasswordBodyDict:(NSDictionary *)bodyDict completion:(ReqCompletion)completion;

/**
 找回密码
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+ (void)findBackPassword:(NSDictionary *)dic completion:(ReqCompletion)completion;

/**
 找回密码时验证
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+ (void)verifyPhonePassword:(NSDictionary *)password completion:(ReqCompletion)completion;

/**
 *  修改密码
 */
+ (void)modifyPasswordWithDic:(NSDictionary *)dic  callBack:(ReqCompletion)callBack;

/**
 *  第三方登录 - 绑定联合账号
 */
+ (void)bindThirdAccountWithDic:(NSDictionary *)dic completion:(ReqCompletion)completion;

@end

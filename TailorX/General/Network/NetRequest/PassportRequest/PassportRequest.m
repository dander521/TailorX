//
//  PassportRequest.m
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "PassportRequest.h"
#import "TXRequestUtil.h"
#import "PassportResult.h"
#import "TXKVPO.h"

@implementation PassportRequest

/**
 登录

 @param parame 登录参数
 @param compeletion 回调
 */

+ (void)loginRequestWithParame:(NSDictionary *)parame compeletion:(ReqCompletion)compeletion {
    // 读取本地缓存中是否有tgt，如果有则不调用登录接口，如果没有则调用登录接口
    PassportResult *result = [[PassportResult alloc]init];
    
   if ([NSString isTextEmpty:GetUserInfo.tgt]) {
        NSString *strMissionList = [strPassport stringByAppendingString:strst];
        NSDictionary *head_dic = [TXServiceUtil getSTHeadDictionary:parame strurl:strMissionList];
       [[TXRequestUtil shareInstance]requestLgoninWithURL:strMissionList requestType:APIRequestPost requsetHeadDictionary:head_dic requestBodyDictionary:parame success:^(AFHTTPSessionManager *operation, id responseObject) {
           result.success = [[responseObject objectForKey:@"success"] boolValue];
           result.msg = [responseObject objectForKey:@"msg"];
           NSDictionary *tgtdic = [responseObject objectForKey:@"data"];
           result.data = tgtdic;
           NSString *tgtStr = [tgtdic objectForKey:@"tgt"];
           SaveUserInfo(tgt, tgtStr);
           NSLog(@"  tgt ================ %@",GetUserInfo.tgt);
           
           if (result.success) {
               [TXServiceUtil getSTbyTGT:tgtStr url:strUtouuAPI success:^(AFHTTPSessionManager *operation, id responseObject) {
                   result.success = YES;
                   NSDictionary *stObj = (NSDictionary *)responseObject;
                   NSString *stStr = [stObj objectForKey:@"st"];
                   SaveUserInfo(st, stStr);
                   compeletion(result,nil);
                   NSLog(@"  st ================ %@",GetUserInfo.st);
                   
               } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                   compeletion(nil,error);
               }];
           }
           else{
               result.success = NO;
               if ([[responseObject objectForKey:@"code"]isKindOfClass:[NSString class]]) {
                   result.code = [responseObject objectForKey:@"code"];
               }else{
                   result.code = [[responseObject objectForKey:@"code"]stringValue];
               }
               compeletion(result,nil);
           }
       } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            compeletion(nil,error);
       } isLogin:nil];
    }else{
        // 如果本地缓存中有tgt，则判断本地缓存中是否有ST，如果没有，取ST，如果有则直接登录
        if ([GetUserInfo.st isEqualToString:@"UTOUU-ST-INVALID"] || [NSString isTextEmpty:GetUserInfo.st]){
            [TXServiceUtil getSTbyTGT:GetUserInfo.tgt url:strUtouuAPI success:^(AFHTTPSessionManager *operation, id responseObject) {
                NSDictionary *stObj = (NSDictionary *)responseObject;
                NSString *stStr = [stObj objectForKey:@"st"];
                SaveUserInfo(st,stStr);
                result.success = true;
                result.msg = @"登录成功";
                compeletion(result,nil);
            } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                result.success = false;
                SaveUserInfo(tgt, nil);
                [TXServiceUtil logout];
                result.msg = @"获取ST令牌失败,请尝试重新登录";
                compeletion(result,nil);
            }];
            
        }else{
            result.success = true;
            result.msg = @"登录成功";
            compeletion(result,nil);
        }
    }
}



/**
 创建客户

 @param dic 请求参数
 @param callBack 回调
 */

+ (void)addCustomerWithDic:(NSDictionary *)dic completion:(ReqCompletion)completion {
    
}


/**
 获取短信验证码

 @param headDic 请求参数
 @param callback 回调
 */
+ (void)getMessageVerifycodeWithDic:(NSDictionary *)bodyDic completion:(ReqCompletion)completion {
    
    NSString * url = [strPassport stringByAppendingString:strRequestMessageResult];
    [[TXRequestUtil shareInstance]requestWithURL:url requestType:APIRequestPost requsetHeadDictionary:nil requestBodyDictionary:bodyDic success:^(AFHTTPSessionManager *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        completion(nil,error);
    } isLogin:nil];
}



/**
 找回密码时的短信验证

 @param password 请求参数

 @param callback 回调
 */
+ (void)verifyMessageWithDic:(NSDictionary *)bodyDic completion:(ReqCompletion)completion {
    NSString * strUrl = [strPassport stringByAppendingString:@"api/user/forget/check-sms-vcode"];
    [[TXRequestUtil shareInstance]requestWithURL:strUrl requestType:APIRequestPost requsetHeadDictionary:nil requestBodyDictionary:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        completion(nil,error);
    } isLogin:nil];
    
}


/**
 获取图形验证码

 @param callback 回调
 */
+ (void)applyforTxVerifyCodeCompletion:(ReqCompletion)completion {
    //NSString * const strRegister = @"http://msg.dev.utouu.com/"
    //NSString * const strSMSPic = @"v1/img/vcode";
    NSString *url = [strRegister stringByAppendingString:strSMSPic];
    
    NSString *uuid = [NSString stringWithFormat:@"%d",arc4random()];
    
    [TXKVPO setVerifyCodeUUID:uuid];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uuid,@"key",
                         @"3600",@"time",
                         @"31",@"source",
                         //@"32",@"source",//ios
                         @"100",@"width",
                         @"40",@"height",
                         @"",@"sign",
                         @"4",@"len", nil];
    
    NSMutableDictionary *headDic = [TXServiceUtil getSTHeadDictionary:dic strurl:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}


/**
 注册

 @param bobyDic 请求参数
 @param completion 回调
 */
+ (void)registerUserAccountWithDic:(NSDictionary *)bobyDic completion:(ReqCompletion)completion {
    NSString *url = [strPassport stringByAppendingString:strRegisterResult];
    NSDictionary * headDict = [TXServiceUtil getSTHeadDictionary:bobyDic strurl:url];
    [[TXRequestUtil shareInstance]requestWithURL:url requestType:APIRequestPost requsetHeadDictionary:headDict requestBodyDictionary:bobyDic success:^(AFHTTPSessionManager *operation, id responseObject) {
        PassportResult *result = [[PassportResult alloc]init];
        NSString *success = [[responseObject objectForKey:@"success"]stringValue];
        NSString *message = [responseObject objectForKey:@"msg"];
        if ([success isEqualToString:@"1"]) {
            result.success = YES;
        }else{
            result.success = NO;
        }
        result.msg = message;
        completion(result,nil);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        completion(nil,error);
    } isLogin:nil];
}


/**
 发送找回密码验证码
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+(void)getForgotYourPasswordBodyDict:(NSDictionary *)bodyDict completion:(ReqCompletion)completion {
    NSString *strURL =[strPassport stringByAppendingString:str_forget_sendSms];
    NSDictionary *head_dic =[TXServiceUtil getSTHeadDictionary:bodyDict strurl:strURL];
    [[TXRequestUtil shareInstance] requestWithURL:strURL requestType:APIRequestPost requsetHeadDictionary:head_dic requestBodyDictionary:bodyDict success:^(AFHTTPSessionManager *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        completion(nil, error);
    } isLogin:nil];
}

/**
 重新发送找回密码验证码
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+ (void)getForgotYourPasswordAgain:(NSString *)phone completion:(ReqCompletion)completion {
    NSString *strURL =[strPassport stringByAppendingString:str_forget_resendSms];
    NSDictionary *dic = @{@"username": phone};
    [[TXRequestUtil shareInstance]requestWithURL:strURL requestType:APIRequestPost requsetHeadDictionary:nil requestBodyDictionary:dic success:^(AFHTTPSessionManager *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        completion(nil,error);
    } isLogin:nil];
}

/**
 找回密码
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+ (void)findBackPassword:(NSDictionary *)dic completion:(ReqCompletion)completion {
    NSString *url = [strPassport stringByAppendingString:findBack_password];
    NSDictionary *head_dic = [TXServiceUtil getSTHeadDictionary:dic strurl:url];
    [[TXRequestUtil shareInstance]requestWithURL:url requestType:APIRequestPost requsetHeadDictionary:head_dic requestBodyDictionary:dic success:^(AFHTTPSessionManager *operation, id responseObject) {
         completion(responseObject,nil);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        completion(nil,error);
    } isLogin:nil];
    
}

/**
 找回密码时验证
 
 @param bobyDic 请求参数
 @param completion 回调
 */
+ (void)verifyPhonePassword:(NSDictionary *)password completion:(ReqCompletion)completion {
    NSString * strUrl = [strPassport stringByAppendingString:@"api/user/forget/check-sms-vcode"];
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:password[@"account"] forKey:@"mobile"];
    [paramDict setObject:password[@"smsVerfiyCode"] forKey:@"code"];
    [[TXRequestUtil shareInstance] requestWithURL:strUrl requestType:APIRequestPost requsetHeadDictionary:nil requestBodyDictionary:paramDict success:^(AFHTTPSessionManager *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        completion(nil,error);
    } isLogin:nil];
    
}


/**
 *  第三方登录 - 绑定联合账号
 */
+ (void)bindThirdAccountWithDic:(NSDictionary *)dic completion:(ReqCompletion)completion {
    NSString * url = [strPassport stringByAppendingString:@"api/v2/account/bind-open-account"];
    NSDictionary * head_dic = [TXServiceUtil getSTHeadDictionary:dic strurl:url];
    [[TXRequestUtil shareInstance]requestWithURL:url requestType:APIRequestPost requsetHeadDictionary:head_dic requestBodyDictionary:dic success:^(AFHTTPSessionManager *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        completion(nil,error);
    } isLogin:nil];
}

/**
 *  修改密码
 */
+ (void)modifyPasswordWithDic:(NSDictionary *)dic  callBack:(ReqCompletion)callBack {
    NSString * url = [strPassport stringByAppendingString:@"app/v1/update-pwd"];
    
//    [TXBaseNetworkRequset requestWithURL:url params:dic success:^(id responseObject) {
//        callBack(responseObject,nil);
//    } failure:^(NSError *error) {
//        callBack(nil,error);
//    }];
    
    [TXBaseNetworkRequset requestWithURL:url params:dic success:^(id responseObject) {
         callBack(responseObject,nil);
    } failure:^(NSError *error) {
         callBack(nil,error);
    } isLogin:^{
        
    }];
}


@end

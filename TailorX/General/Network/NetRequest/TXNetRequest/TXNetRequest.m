//
//  TXNetRequest.m
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXNetRequest.h"

@implementation TXNetRequest

#pragma mark - Common Method

/**
 * 拼接全路径Url
 */
+ (NSString *)getFullPathUrlWithRelativeUrl:(NSString *)relativeUrl {
    return [strTailorxAPI stringByAppendingString:relativeUrl];
}

#pragma - mark 首页

/**
 Home页网络请求
 
 @param params 请求参数
 @param relativeUrl 相对路径
 @param completion 回调
 */

+ (void)homeRequestMethodWithParams:(NSDictionary *)params
                        relativeUrl:(NSString *)relativeUrl
                         completion:(ReqCompletion)completion isLogin:(void(^)())login{
    [[TXRequestUtil shareInstance] requestWithURL: [self getFullPathUrlWithRelativeUrl:relativeUrl]
                                      requestType:APIRequestPost
                            requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:relativeUrl]]
                            requestBodyDictionary:params
                                          success:^(AFHTTPSessionManager *operation, id responseObject) {
                                              // NSLog(@"%@",responseObject);
                                              [self setUpOutLogWithUrl:[self getFullPathUrlWithRelativeUrl:relativeUrl] withRespon:responseObject];
                                              completion(responseObject,nil);
                                          }
                                          failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                              completion(nil,error);
                                              NSLog(@"\nurl = %@\n参数 = %@\n错误 = %@", [self getFullPathUrlWithRelativeUrl:relativeUrl], params, error.localizedDescription);
                                          } isLogin:^{
                                              if (login) {
                                                  login();
                                              }
                                          }];
}

/**
 添加用户
 @param params 请求参数
 @param relativeUrl 相对路径
 @param completion 回调
 */

+ (void)userCenterAddCustomerMethodWithParams:(NSDictionary *)params
                                  relativeUrl:(NSString *)relativeUrl
                                   completion:(ReqCompletion)completion isLogin:(void(^)())login {
    [[TXRequestUtil shareInstance] requestLgoninWithURL: [self getFullPathUrlWithRelativeUrl:relativeUrl]
                                      requestType:APIRequestPost
                            requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:relativeUrl]]
                            requestBodyDictionary:params
                                          success:^(AFHTTPSessionManager *operation, id responseObject) {
                                              //NSLog(@"%@",responseObject);
                                              [self setUpOutLogWithUrl:[self getFullPathUrlWithRelativeUrl:relativeUrl] withRespon:responseObject];
                                              completion(responseObject,nil);
                                          }
                                          failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                              completion(nil,error);
                                              NSLog(@"\nurl = %@\n参数 = %@\n错误 = %@", relativeUrl, params, error.localizedDescription);
                                          } isLogin:^{
                                              if (login) {
                                                  login();
                                              }
                                          }];
}


/**
 * 提交预约信息
 */

+ (void)homeCommitAppointmentWithParams:(NSDictionary *)params
                            relativeUrl:(NSString *)relativeUrl
                             pictureKey:(NSArray *)pictureKey
                               pictures:(NSArray *)imageArray
                             completion:(ReqCompletion)completion{
    [[TXRequestUtil shareInstance] postPictureWithRequestWithURL:[self getFullPathUrlWithRelativeUrl:relativeUrl]
                                                     requestType:APIRequestPost
                                           requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:relativeUrl]]
                                           requestBodyDictionary:params
                                                      pictureKey:pictureKey
                                                         NSArray:imageArray
                                                         success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                             if (responseObject != nil) {
                                                                 NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                                 NSDictionary *returnDic = [self dictionaryWithJsonString:returnStr];
                                                                 completion(returnDic, nil);
                                                             } else {
                                                                 completion(nil, nil);
                                                             }
                                                         } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                                             completion(nil, error);
                                                             NSLog(@"\nurl = %@\n参数 = %@\n错误 = %@", relativeUrl, params, error.localizedDescription);
                                                         }];
}

/**
 * 提交参考图片
 */

+ (void)userCenterCommitRePictureWithParams:(NSDictionary *)params
                            relativeUrl:(NSString *)relativeUrl
                             pictureKey:(NSArray *)pictureKey
                               pictures:(NSArray *)imageArray
                               progress:(void (^)(CGFloat))progress
                             completion:(ReqCompletion)completion {
    [[TXRequestUtil shareInstance] postPictureWithRequestWithURL:[self getFullPathUrlWithRelativeUrl:relativeUrl]
                                                     requestType:APIRequestPost
                                           requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:relativeUrl]]
                                           requestBodyDictionary:params
                                                      pictureKey:pictureKey
                                                         NSArray:imageArray
                                                        progress:^(CGFloat pro) {
                                                            progress(pro);
                                                        }
                                                         success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                             if (responseObject != nil) {
                                                                 NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                                 NSDictionary *returnDic = [self dictionaryWithJsonString:returnStr];
                                                                 completion(returnDic, nil);
                                                             } else {
                                                                 completion(nil, nil);
                                                             }
                                                         } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                                             completion(nil, error);
                                                             NSLog(@"\nurl = %@\n参数 = %@\n错误 = %@", relativeUrl, params, error.localizedDescription);
                                                         }];
}


#pragma - mark 资讯
+ (void)informationRequestMethodWithParams:(NSDictionary *)params
                               relativeUrl:(NSString *)relativeUrl
                                completion:(ReqCompletion)completion isLogin:(void(^)())login{
    
    [[TXRequestUtil shareInstance] requestWithURL: [self getFullPathUrlWithRelativeUrl:relativeUrl]
                                      requestType:APIRequestPost
                            requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:relativeUrl]]
                            requestBodyDictionary:params
                                          success:^(AFHTTPSessionManager *operation, id responseObject) {
                                              [self setUpOutLogWithUrl:[self getFullPathUrlWithRelativeUrl:relativeUrl] withRespon:responseObject];
                                              completion(responseObject,nil);
                                          }
                                          failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                              completion(nil,error);
                                              NSLog(@"\nurl = %@\n参数 = %@\n错误 = %@", relativeUrl, params, error.localizedDescription);
                                          }isLogin:^{
                                              if (login) {
                                                  login();
                                              }
                                          }];

    
}


#pragma - mark 排号

#pragma - mark 门店

#pragma - mark 个人中心

/**
 订单接口
 
 @param params 请求参数
 @param relativeUrl 相对路径
 @param completion 回调
 */
+ (void)userCenterRequestMethodWithParams:(NSDictionary *)params
                              relativeUrl:(NSString *)relativeUrl
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure
                                  isLogin:(void(^)())login {
    [[TXRequestUtil shareInstance] requestWithURL:[self getFullPathUrlWithRelativeUrl:relativeUrl]
                                      requestType:APIRequestPost
                            requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:relativeUrl]]
                            requestBodyDictionary:params
                                          success:^(AFHTTPSessionManager *operation, id responseObject) {
                                              [TXNetRequest setUpOutLogWithUrl:[self getFullPathUrlWithRelativeUrl:relativeUrl] withRespon:responseObject];
                                              if (responseObject) {
                                                  success(responseObject);
                                              } else {
                                                  success(nil);
                                              }
                                          }
                                          failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                              failure(error);
                                          }isLogin:^{
                                              if (login) {
                                                  login();
                                              }
                                          }];
}

/**
 上传头像
 
 @param dic body 字典
 @param pictureKey 图片服务器键
 @param imageArray 图片数组
 @param completion 回调
 */
+ (void)userCenterUploadAvatarWithParams:(NSDictionary *)params
                              pictureKey:(NSArray *)pictureKey
                                pictures:(NSArray *)imageArray
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure {
    [[TXRequestUtil shareInstance] postPictureWithRequestWithURL:[self getFullPathUrlWithRelativeUrl:strUserCenterModifyCustomerAvatar]
                                                     requestType:APIRequestPost
                                           requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:strUserCenterModifyCustomerAvatar]]
                                           requestBodyDictionary:params
                                                      pictureKey:pictureKey
                                                         NSArray:imageArray
                                                         success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                             if (responseObject != nil) {
                                                                 success(responseObject);
                                                             } else {
                                                                 success(nil);
                                                             }
                                                         } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                                             failure(error);
                                                         }];
}

/**
 实名认证
 
 @param dic body 字典
 @param pictureKey 图片服务器键
 @param imageArray 图片数组
 @param completion 回调
 */
+ (void)userCenterRealNameAuthWithParams:(NSDictionary *)params
                              pictureKey:(NSArray *)pictureKey
                                pictures:(NSArray *)imageArray
                                progress:(void (^)(CGFloat))progress
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure {
    [[TXRequestUtil shareInstance] postPictureWithRequestWithURL:[self getFullPathUrlWithRelativeUrl:strUserCenterRealNameAuth]
                                                     requestType:APIRequestPost
                                           requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:strUserCenterRealNameAuth]]
                                           requestBodyDictionary:params
                                                      pictureKey:pictureKey
                                                         NSArray:imageArray
     progress:^(CGFloat num) {
         progress(num);
     } success:^(AFHTTPSessionManager *operation, id responseObject) {
         if (responseObject != nil) {
             success(responseObject);
         } else {
             success(nil);
         }
     } failure:^(AFHTTPSessionManager *operation, NSError *error) {
         failure(error);
     }];
}


/**
 *  绑定第三方账号
 */
+ (void)goToBlindThirdAccountWithParams:(NSDictionary *)params
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure {
    NSString *url = [strUtouuAPI stringByAppendingString:@"/v2/user/open-account-bind"];
    NSDictionary *head_dic = [TXServiceUtil getSTHeadDictionary:params strurl:url];
    [[TXRequestUtil shareInstance] requestWithURL:url
                                      requestType:APIRequestPost
                            requsetHeadDictionary:head_dic
                            requestBodyDictionary:params
                                          success:^(AFHTTPSessionManager *operation, id responseObject) {
                                              [TXNetRequest setUpOutLogWithUrl:url withRespon:responseObject];
                                              if (responseObject) {
                                                  success(responseObject);
                                              } else {
                                                  success(nil);
                                              }
                                          }
                                          failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                              if (error) {
                                                  failure(error);
                                              }
                                          } isLogin:^{
                                              
                                          }];
}

/**
 获取用户未读消息数量
 */
+ (void)findUserUnreadMsgCount {
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                   relativeUrl:strUserCenterFindUnreadMsgCount
                                    success:^(id responseObject) {
                                        if ([responseObject[ServerResponse_success] boolValue]) {
                                            [TXModelAchivar updateUserModelWithKey:@"unreadMsgCount" value:responseObject[ServerResponse_data]];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationFindUnreadMsgCount object:nil];
                                        } else {
                                            
                                        }
                                    } failure:^(NSError *error) {
                                    } isLogin:^{
                                    }];
}

/**
 获取视频验证码
 
 @param success
 @param failure
 */
+ (void)getVideoPincodeSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure {
    [[TXRequestUtil shareInstance] requestWithURL:[self getFullPathUrlWithRelativeUrl:strUserCenterGetVedioCode]
                                      requestType:APIRequestPost
                            requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:nil strurl:[self getFullPathUrlWithRelativeUrl:strUserCenterGetVedioCode]]
                            requestBodyDictionary:nil
                                          success:^(AFHTTPSessionManager *operation, id responseObject) {
       
                                              if (responseObject) {
                                                  success(responseObject);
                                              } else {
                                                  success(nil);
                                              }
                                          }
                                          failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                              if (error) {
                                                  failure(error);
                                              }
                                          } isLogin:^{
                                              
                                          }];
}

/**
 上传视频
 
 @param success
 @param failure
 */
+ (void)uploadVideoWithParam:(NSDictionary *)param
                    keyArray:(NSArray *)keyArray
               fileDataArray:(NSArray *)fileData
                    progress:(void (^)(CGFloat))progress
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    [[TXRequestUtil shareInstance] postVideoWithRequestWithURL:[self getFullPathUrlWithRelativeUrl:strUserCenterUploadVedio]
                                                   requestType:APIRequestPost
                                         requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:param strurl:[self getFullPathUrlWithRelativeUrl:strUserCenterUploadVedio]]
                                         requestBodyDictionary:param
                                                      videoKey:keyArray
                                                    videoArray:fileData
                                                      progress:^(CGFloat num) {
        progress(num);
    } success:^(AFHTTPSessionManager *operation, id responseObject) {
        if (responseObject != nil) {
            success(responseObject);
        } else {
            success(nil);
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        failure(error);
    }];
}

#pragma - mark 订单

/**
 评价订单
 
 @param dic body 字典
 @param pictureKey 图片服务器键
 @param imageArray 图片数组
 @param completion 回调
 */
+ (void)orderFeedbackPictureWithParams:(NSDictionary *)params
                            pictureKey:(NSArray *)pictureKey
                              pictures:(NSArray *)imageArray
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure {
    [[TXRequestUtil shareInstance] postPictureWithRequestWithURL:[self getFullPathUrlWithRelativeUrl:strOrderComment]
                                                     requestType:APIRequestPost
                                           requsetHeadDictionary:[TXServiceUtil getSTHeadDictionary:params strurl:[self getFullPathUrlWithRelativeUrl:strOrderComment]]
                                           requestBodyDictionary:params
                                                      pictureKey:pictureKey
                                                         NSArray:imageArray
                                                         success:^(AFHTTPSessionManager *operation, id responseObject) {
        if (responseObject != nil) {
            success(responseObject);
        } else {
            success(nil);
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        failure(error);
    }];
}

#pragma mark - Description

// 网络请求日志输出
+ (void)setUpOutLogWithUrl:(NSString *)url withRespon:(id) responseObj {
    
    if (responseObj == nil){
        NSLog(@"%@__数据为空", url);
        return;
    }
    if ([responseObj isKindOfClass:[NSData class]]) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        if (dic == nil) {
            NSLog(@"%@__数据返回为Null", url);
            return;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"url地址=%@\n转码后内容 = %@", url, str.length > 0 ? str:@"数据内容为空");
    }else{
        
        NSString * str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObj options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        if (str == nil){
            NSLog(@"%@__数据返回为Null", url);
            return;
        }
        NSLog(@"url地址=%@\n转码后内容 = %@", url, str.length > 0 ? str : @"数据内容为空");
    }
    
}

/**
 * JSON字符串装字典
 */

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end

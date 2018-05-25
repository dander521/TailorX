//
//  TXRequestUtil.m
//  Tailorx
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年   徐安超. All rights reserved.
//

#import "TXRequestUtil.h"
#import <UIKit/UIKit.h>
#import "PassportRequest.h"
#import <Foundation/Foundation.h>

typedef void(^isLgoinBlock)(bool isSuccess);

@interface TXRequestUtil ()<UIAlertViewDelegate>

@property (nonatomic,strong) AFHTTPSessionManager * manager;

/** 登录的block*/
@property (nonatomic, copy) isLgoinBlock loginBlock;

/** 记录令牌失效次数*/
@property (nonatomic, assign) NSInteger alertTime;

@end

@implementation TXRequestUtil

+ (instancetype)shareInstance {
    static TXRequestUtil *server;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!server) {
            server = [[TXRequestUtil alloc] init];
            server.alertTime = 0;
        }
    });
    return  server;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [TXRequestUtil defaultNetManager];
    }
    return self;
}

// 防止AFN请求造成内存泄漏
+ (AFHTTPSessionManager*)defaultNetManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        manager.requestSerializer.timeoutInterval = 60;
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [manager.requestSerializer setValue:@"text/html;charset=UTF-8,application/json" forHTTPHeaderField:@"Accept"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml",@"text/plain",nil];
    });
    return manager;
}

- (void)requestWithURL:(NSString *)urlStr
           requestType:(APIRequestType)type
 requsetHeadDictionary:(NSDictionary *)headDic
 requestBodyDictionary:(NSDictionary*)bodyDic
               success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success
               failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure
               isLogin:(void(^)())login {
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    NSMutableString *body = [[NSMutableString alloc]init];
    for(NSString *key in [bodyDic allKeys]){
        NSString *value= [bodyDic objectForKey:key];
        [body appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    weakSelf(self);
    switch (type) {
        case APIRequestGet:{
            [weakSelf.manager GET:urlStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(weakSelf.manager, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(weakSelf.manager, error);
            }];
        }break;
        case APIRequestPost:{
            [weakSelf.manager POST:urlStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *returnDic = [self dictionaryWithJsonString:returnStr];
                if ([[returnDic allKeys] containsObject:@"success"]) {
                    if(![[returnDic valueForKey:@"success"] boolValue]){
                        //025令牌失效030请求非法
                        if([[returnDic valueForKey:@"code"] isEqual:@"025"] || [[NSString stringWithFormat:@"%@",[returnDic valueForKey:@"code"]] isEqualToString:@"030"]){
                        }
                        if ([[returnDic valueForKey:@"code"] isEqual:@"025"]) {
                            if (weakSelf.alertTime < 5) {
                                weakSelf.alertTime ++;
                            }else {
                                if (login) {
                                    login();
                                }
                                weakSelf.alertTime = 0;
                                [ShowMessage showMessage:@"您的身份令牌已过期, 请重新登录" withCenter:kShowMessageViewFrame];
                                [TXServiceUtil logout];
                            }
                            if (![NSString isTextEmpty:GetUserInfo.accountA] && ![NSString isTextEmpty:GetUserInfo.password]) {
                                [weakSelf autoLogin];
                            }else {
                                // [ShowMessage showMessage:@"您还未登录，请登录！" withCenter:kShowMessageViewFrame];
                                if (login) {
                                    login();
                                }
                                [TXServiceUtil logout];
                            }
                            self.loginBlock = ^(bool isSuccess){
                                weakSelf.alertTime = 0;
                                if (isSuccess) {
                                    //重新组装头部参数
                                    NSDictionary *new_head = [TXServiceUtil getSTHeadDictionary:bodyDic strurl:urlStr];
                                    [weakSelf requestWithURL:urlStr requestType:type requsetHeadDictionary:new_head  requestBodyDictionary:bodyDic success:^(AFHTTPSessionManager *operation, id responseObject) {
                                        success(operation, responseObject);
                                    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                        failure(nil,error);
                                    } isLogin:^{
                                        
                                    }];
                                }else {
                                    if (login) {
                                        login();
                                    }
                                    [ShowMessage showMessage:@"您的身份令牌已过期, 请重新登录" withCenter:kShowMessageViewFrame];
                                    [TXServiceUtil logout];
                                }
                            };
                        }else {
                            weakSelf.alertTime = 0;
                            success(weakSelf.manager, returnDic);
                        }
                    }else{
                        weakSelf.alertTime = 0;
                        success(weakSelf.manager, returnDic);
                    }
                }
            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                weakSelf.alertTime = 0;
                failure(weakSelf.manager,error);
               
            }];
        }break;
        case APIRequestPut:{
            [weakSelf.manager PUT:urlStr parameters:bodyDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(weakSelf.manager, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(weakSelf.manager, error);
            }];
        
        }break;
        case APIRequestDelete:{
            [weakSelf.manager DELETE:urlStr parameters:bodyDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(weakSelf.manager, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(weakSelf.manager, error);
            }];
        
        }break;
    }
    [weakSelf.manager.operationQueue cancelAllOperations];
}

- (void)requestLgoninWithURL:(NSString *)urlStr
           requestType:(APIRequestType)type
 requsetHeadDictionary:(NSDictionary *)headDic
 requestBodyDictionary:(NSDictionary*)bodyDic
               success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success
               failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure
               isLogin:(void(^)())login {
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    NSMutableString *body = [[NSMutableString alloc]init];
    for(NSString *key in [bodyDic allKeys]){
        NSString *value= [bodyDic objectForKey:key];
        [body appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    weakSelf(self);
    switch (type) {
        case APIRequestGet:{
            [weakSelf.manager GET:urlStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(weakSelf.manager, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(weakSelf.manager, error);
            }];
        }break;
        case APIRequestPost:{
            [weakSelf.manager POST:urlStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *returnDic = [self dictionaryWithJsonString:returnStr];
                if ([[returnDic allKeys] containsObject:@"success"]) {
                    if(![[returnDic valueForKey:@"success"] boolValue]){
                        success(weakSelf.manager, returnDic);
                    }else{
                        success(weakSelf.manager, returnDic);
                    }
                }
            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(weakSelf.manager,error);
                
            }];
        }break;
        case APIRequestPut:{
            [weakSelf.manager PUT:urlStr parameters:bodyDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(weakSelf.manager, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(weakSelf.manager, error);
            }];
            
        }break;
        case APIRequestDelete:{
            [weakSelf.manager DELETE:urlStr parameters:bodyDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(weakSelf.manager, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(weakSelf.manager, error);
            }];
            
        }break;
    }
    [weakSelf.manager.operationQueue cancelAllOperations];
}

/** 
 第三方登录
 */

+ (void)getThirdLoginTgtInfoWithBodyDic:(NSDictionary *)bodyDic mainCallBack:(MyCallback)callBack {
    PassportResult *loginResult = [PassportResult alloc];
    //判断本地缓存中是否有TGT，如果有则不调用登录接口，如果没有则调用登录接口
    if ([NSString isTextEmpty:GetUserInfo.tgt]) {
        //接口地址
        NSString *strMissionList = [strPassport stringByAppendingString:@"m1/open-account-tickets"];
        NSDictionary *head_dic = [TXServiceUtil getSTHeadDictionary:bodyDic strurl:strMissionList];

        [[TXRequestUtil shareInstance]requestWithURL:strMissionList requestType:APIRequestPost requsetHeadDictionary:head_dic requestBodyDictionary:bodyDic success:^(AFHTTPSessionManager *operation, id responseObject) {
            loginResult.success = [[responseObject objectForKey:@"success"] boolValue];
            loginResult.msg = [responseObject objectForKey:@"msg"];
            NSDictionary *tgtdic = [responseObject objectForKey:@"data"];
            NSString *strTGT = [tgtdic objectForKey:@"tgt"];
            SaveUserInfo(tgt, strTGT);
            if (loginResult.success) {
                [TXServiceUtil getSTbyTGT:strTGT url:strUtouuAPI success:^(AFHTTPSessionManager *operation, id responseObject) {
                    loginResult.success = YES;
                    NSDictionary *stObj = (NSDictionary *)responseObject;
                    NSString *stStr = [stObj objectForKey:@"st"];
                    SaveUserInfo(st, stStr);
                    callBack(loginResult,nil);
                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                    callBack(nil, error);
                }];
            }else{
                loginResult.success = NO;
                loginResult.msg = [responseObject objectForKey:@"msg"];
                if ([[responseObject objectForKey:@"code"]isKindOfClass:[NSString class]]) {
                    loginResult.code = [responseObject objectForKey:@"code"];
                }else{
                    loginResult.code = [[responseObject objectForKey:@"code"]stringValue ];
                }
                callBack(loginResult,nil);
            }
            loginResult.data = tgtdic;
        } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            
        } isLogin:nil];
    }else{
        //如果本地缓存中有TGT，则判断本地缓存中是否有ST，如果没有，取ST，如果有则直接登录
        if ([NSString isTextEmpty:GetUserInfo.st]){
            [TXServiceUtil getSTbyTGT:GetUserInfo.tgt url:strUtouuAPI success:^(AFHTTPSessionManager *operation, id responseObject) {
                NSDictionary *stObj = (NSDictionary *)responseObject;
                NSString *stStr = [stObj objectForKey:@"st"];
                SaveUserInfo(st, stStr);
                loginResult.success = true;
                loginResult.msg = @"登录成功";
                callBack(loginResult,nil);
            } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                loginResult.success = false;
                SaveUserInfo(tgt, nil);
                loginResult.msg = @"重新获取ST令牌失败,请再次尝试登录";
                callBack(nil, error);
            }];
        }else{
            loginResult.success = true;
            loginResult.msg = @"登录成功";
            callBack(loginResult, nil);
        }
    }
}


- (void)postPictureWithRequestWithURL:(NSString *)urlStr
                          requestType:(APIRequestType)type
                requsetHeadDictionary:(NSDictionary *)headDic
                requestBodyDictionary:(NSDictionary *)bodyDic
                           pictureKey:(NSArray *)pictureKeyArray
                              NSArray:(NSArray *)imageArray
                              success:(void (^)(AFHTTPSessionManager *, id))success
                              failure:(void (^)(AFHTTPSessionManager *, NSError *))failure {
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }    
    __weak typeof(self) weakself = self;
    [weakself.manager POST:urlStr parameters:bodyDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageArray != nil && imageArray.count > 0) {
            for (int i = 0 ; i < imageArray.count; i++) {
                NSData *imageData = imageArray[i];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str, i];
                if (pictureKeyArray.count == 1) {
                    [formData appendPartWithFileData:imageData name:pictureKeyArray.firstObject fileName:fileName mimeType:@"image/jpeg"];
                } else {
                    [formData appendPartWithFileData:imageData name:pictureKeyArray[i] fileName:fileName mimeType:@"image/jpeg"];
                }
            }
        }
    }
                  progress: nil
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       success(_manager, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(nil,error);
    }];
    
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}

- (void)postPictureWithRequestWithURL:(NSString *)urlStr
                          requestType:(APIRequestType)type
                requsetHeadDictionary:(NSDictionary *)headDic
                requestBodyDictionary:(NSDictionary *)bodyDic
                           pictureKey:(NSArray *)pictureKeyArray
                              NSArray:(NSArray *)imageArray
                             progress:(void (^)(CGFloat))progress
                              success:(void (^)(AFHTTPSessionManager *, id))success
                              failure:(void (^)(AFHTTPSessionManager *, NSError *))failure {
    
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    __weak typeof(self) weakself = self;
    [weakself.manager POST:urlStr parameters:bodyDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageArray != nil && imageArray.count > 0) {
            for (int i = 0 ; i < imageArray.count; i++) {
                NSData *imageData = imageArray[i];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str, i];
                if (pictureKeyArray.count == 1) {
                    [formData appendPartWithFileData:imageData name:pictureKeyArray.firstObject fileName:fileName mimeType:@"image/jpeg"];
                } else {
                    [formData appendPartWithFileData:imageData name:pictureKeyArray[i] fileName:fileName mimeType:@"image/jpeg"];
                }
            }
        }
    }
                  progress: ^(NSProgress * _Nonnull uploadProgress) {
                      progress(uploadProgress.fractionCompleted);
                  }
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       success(_manager, responseObject);
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       failure(nil,error);
                   }];
    
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}

- (void)postVideoWithRequestWithURL:(NSString *)urlStr
                          requestType:(APIRequestType)type
                requsetHeadDictionary:(NSDictionary *)headDic
                requestBodyDictionary:(NSDictionary *)bodyDic
                            videoKey:(NSArray *)videoKeyArray
                         videoArray:(NSArray *)videoArray
                             progress:(void (^)(CGFloat))progress
                              success:(void (^)(AFHTTPSessionManager *, id))success
                              failure:(void (^)(AFHTTPSessionManager *, NSError *))failure {
    
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    __weak typeof(self) weakself = self;
    [weakself.manager POST:urlStr parameters:bodyDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (videoArray != nil && videoArray.count > 0) {
            for (int i = 0 ; i < videoArray.count; i++) {
                NSData *imageData = videoArray[i];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.mp4", str, i];
                if (videoKeyArray.count == 1) {
                    [formData appendPartWithFileData:imageData name:videoKeyArray.firstObject fileName:fileName mimeType:@"video/mp4"];
                } else {
                    [formData appendPartWithFileData:imageData name:videoKeyArray[i] fileName:fileName mimeType:@"video/mp4"];
                }
            }
        }
    }
                  progress: ^(NSProgress * _Nonnull uploadProgress) {
                      progress(uploadProgress.fractionCompleted);
                  }
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       success(_manager, responseObject);
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       failure(nil,error);
                   }];
    
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
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

- (void)showAlertViewSureBlock:(void(^)())block{
    if (self.alertTime <= 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的身份令牌已过期,为了您的账号安全,请重新登录.." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        [alert show];
        self.loginBlock = ^(bool isSuccess){
            if (block) {
                block();
            }
        };
    }
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%zd",buttonIndex);
    if (buttonIndex==0) {
        self.alertTime = 0;
        return;
    }else{
        if (self.loginBlock) {
            self.loginBlock(YES);
        };
    }
}

#pragma mark - Login

- (void)autoLogin {
    /*
    NSString *udidStr = [TXCommon createUDID];
    SaveUserInfo(udid, udidStr);
    NSString *token;
    if (![NSString isTextEmpty:GetUserInfo.deviceID]) {
        token = GetUserInfo.deviceID;
    }else {
        token = @"";
    }
    // 清空st
    SaveUserInfo(st, nil);
    SaveUserInfo(tgt, nil);
    
    NSString *appVersion = [TXCommon getAppVersion];
    NSString *time = [TXMyMD5 getSystemTime];
    
    NSMutableDictionary *parameters = [@{}mutableCopy];
    [parameters setValue:GetUserInfo.accountA forKey:@"username"];
    [parameters setValue:GetUserInfo.password forKey:@"password"];
    [parameters setValue:udidStr forKey:@"device_udid"];
    [parameters setValue:TX_device_type forKey:@"device_type"];
    [parameters setValue:appVersion forKey:@"version"];
    [parameters setValue:token forKey:@"device_token"];
    [parameters setValue:TX_app_name forKey:@"app_name"];
    
    //生成sign
    NSString *strSign = [TXMyMD5 md5:parameters time:time];
    
    [parameters setValue:TX_utouuAppId forKey:@"utouuAppId"];
    [parameters setValue:strUtouuAPI forKey:@"service"];
    //登录参数
    [parameters setValue:time  forKey:@"time"];
    [parameters setValue:strSign forKey:@"sign"];
    [parameters setValue:@"2" forKey:@"push_platform"];
    [PassportRequest loginRequestWithParame:parameters compeletion:^(id obj, NSError *error) {
        if (error) {
            if (self.loginBlock) {
                self.loginBlock(NO);
            };
            return;
        }
        PassportResult *result = (PassportResult *)obj;
        NSString *loginMessage = result.msg;
        NSLog(@"%@",loginMessage);
        if (result.success == 1) {
            SaveUserInfo(isLogin, @"1");
            if (self.loginBlock) {
                self.loginBlock(YES);
            };
            // 程荣刚： 修改头像
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserAvatar object:nil];
            // 刘彦铭： 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationLoginSuccess object:nil];
        }else {
            if (self.loginBlock) {
                self.loginBlock(NO);
            };
        }
    }];
     */
    // appType  手机类型 1:iOS 2:Android
    // deviceId 设备的device_id,推送消息需要
    // 清空st
    SaveUserInfo(st, nil);
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:@"1" forKey:@"appType"];
    [dict setValue:GetUserInfo.deviceID forKey:@"deviceId"];
    // openSDK 添加的参数
    [dict setValue:GetUserInfo.accessToken forKey:@"accessToken"];
    [dict setValue:GetUserInfo.unionId forKey:@"unionId"];
    [dict setValue:GetUserInfo.openId forKey:@"openId"];
    [dict setValue:GetUserInfo.accountA forKey:@"userName"];
    
    [TXNetRequest userCenterAddCustomerMethodWithParams:dict relativeUrl:strAddCustomer completion:^(id responseObject, NSError *error) {
        if (error) {
            if (self.loginBlock) {
                self.loginBlock(NO);
            };
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]){
                SaveUserInfo(st, [responseObject objectForKey:@"data"]);
                SaveUserInfo(isLogin, @"1");
                if (self.loginBlock) {
                    self.loginBlock(YES);
                };
                // 程荣刚： 修改头像
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserAvatar object:nil];
                // 刘彦铭： 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationLoginSuccess object:nil];
            }else {
                if (self.loginBlock) {
                    self.loginBlock(NO);
                };
            }
        }
    }isLogin:^{
        if (self.loginBlock) {
            self.loginBlock(NO);
        };
    }];
}

@end

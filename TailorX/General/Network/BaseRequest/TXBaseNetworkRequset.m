//
//  TXBaseNetworkRequset.m
//  TailorX
//
//  Created by liuyanming on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseNetworkRequset.h"

@implementation TXBaseNetworkRequset

+ (void)requestWithURL:(NSString *)urlStr
                params:(id)params
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
               isLogin:(void(^)())login {
    NSLog(@"★★★★★★★★★★网络接口请求url.....:%@",urlStr);
    NSDictionary * headDict = [TXServiceUtil getSTHeadDictionary:params strurl:urlStr];
    NSLog(@"★★★★★★★★★★网络接口请求headDic.....:%@",headDict);
    NSLog(@"★★★★★★★★★★网络接口请求bodyDic.....:%@",params);
    
    [[TXRequestUtil shareInstance] requestWithURL:urlStr
                                      requestType:APIRequestPost
                            requsetHeadDictionary:headDict
                            requestBodyDictionary:params
                                          success:^(AFHTTPSessionManager *operation, id responseObject) {
       
        NSLog(@"★★★★★★★★★★网络接口返回.....:%@",responseObject);
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    } isLogin:^{
        if (login) {
            login();
        }
    }];
}

@end

//
//  TXRequestUtil.h
//  Tailorx
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年   徐安超. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^MyCallback)(id obj,NSError* error);

/**
 网络请求方式
 */
typedef NS_ENUM(NSInteger, APIRequestType) {
    APIRequestGet,
    APIRequestPost,
    APIRequestPut,
    APIRequestDelete
};

@interface TXRequestUtil : NSObject

+(instancetype)shareInstance;

/**
 * 网络请求基类
 */
- (void)requestWithURL:(NSString *)urlStr
           requestType:(APIRequestType)type
 requsetHeadDictionary:(NSDictionary *)headDic
 requestBodyDictionary:(NSDictionary*)bodyDic
               success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success
               failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure
               isLogin:(void(^)())login;

- (void)requestLgoninWithURL:(NSString *)urlStr
                 requestType:(APIRequestType)type
       requsetHeadDictionary:(NSDictionary *)headDic
       requestBodyDictionary:(NSDictionary*)bodyDic
                     success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success
                     failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure
                     isLogin:(void(^)())login;
/** 
 * 联合登录
 */
+ (void)getThirdLoginTgtInfoWithBodyDic:(NSDictionary *)bodyDic
                           mainCallBack:(MyCallback)callBack;

/**
 * 上传图片
 */
- (void)postPictureWithRequestWithURL:(NSString *)urlStr
                          requestType:(APIRequestType)type
                requsetHeadDictionary:(NSDictionary *)headDic
                requestBodyDictionary:(NSDictionary*)bodyDic
                           pictureKey:(NSArray *)pictureKeyArray
                              NSArray:(NSArray *)imageArray
                              success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success
                              failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure;
/**
 * 带进度的上传图片
 */
- (void)postPictureWithRequestWithURL:(NSString *)urlStr
                          requestType:(APIRequestType)type
                requsetHeadDictionary:(NSDictionary *)headDic
                requestBodyDictionary:(NSDictionary *)bodyDic
                           pictureKey:(NSArray *)pictureKeyArray
                              NSArray:(NSArray *)imageArray
                             progress:(void (^)(CGFloat))progress
                              success:(void (^)(AFHTTPSessionManager *, id))success
                              failure:(void (^)(AFHTTPSessionManager *, NSError *))failure;
/**
 * 带进度的上传视频
 */
- (void)postVideoWithRequestWithURL:(NSString *)urlStr
                        requestType:(APIRequestType)type
              requsetHeadDictionary:(NSDictionary *)headDic
              requestBodyDictionary:(NSDictionary *)bodyDic
                           videoKey:(NSArray *)videoKeyArray
                         videoArray:(NSArray *)videoArray
                           progress:(void (^)(CGFloat))progress
                            success:(void (^)(AFHTTPSessionManager *, id))success
                            failure:(void (^)(AFHTTPSessionManager *, NSError *))failure;



@end

//
//  TXNetRequest.h
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXRequestUtil.h"
#import "TXServiceUtil.h"

typedef void (^ReqCompletion)(id responseObject, NSError * error);

@interface TXNetRequest : NSObject

#pragma mark - Common Method

/**
 * 拼接全路径Url
 */
+ (NSString *)getFullPathUrlWithRelativeUrl:(NSString *)relativeUrl;

#pragma - mark 首页

/**
 Home页网络请求
 
 @param params 请求参数
 @param relativeUrl 相对路径
 @param completion 回调
 */

+ (void)homeRequestMethodWithParams:(NSDictionary *)params
                                relativeUrl:(NSString *)relativeUrl
                                 completion:(ReqCompletion)completion
                                 isLogin:(void(^)())login;
/**
 添加用户
 @param params 请求参数
 @param relativeUrl 相对路径
 @param completion 回调
 */
+ (void)userCenterAddCustomerMethodWithParams:(NSDictionary *)params
                                  relativeUrl:(NSString *)relativeUrl
                                   completion:(ReqCompletion)completion isLogin:(void(^)())login;

/**
 * 提交预约信息
 */

+ (void)homeCommitAppointmentWithParams:(NSDictionary *)params
                            relativeUrl:(NSString *)relativeUrl
                             pictureKey:(NSArray *)pictureKey
                               pictures:(NSArray *)imageArray
                             completion:(ReqCompletion)completion;

/**
 * 提交参考图片
 */
+ (void)userCenterCommitRePictureWithParams:(NSDictionary *)params
                                relativeUrl:(NSString *)relativeUrl
                                 pictureKey:(NSArray *)pictureKey
                                   pictures:(NSArray *)imageArray
                                   progress:(void (^)(CGFloat))progress
                                 completion:(ReqCompletion)completion;

#pragma - mark 资讯
/**
 资讯接口
 
 @param params 请求参数
 @param relativeUrl 相对路径
 @param completion 回调
 */
+ (void)informationRequestMethodWithParams:(NSDictionary *)params
                        relativeUrl:(NSString *)relativeUrl
                         completion:(ReqCompletion)completion
                            isLogin:(void(^)())login;

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
                                  isLogin:(void(^)())login;

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
                                 failure:(void (^)(NSError *error))failure;

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
                                 failure:(void (^)(NSError *error))failure;

/**
 *  绑定第三方账号
 */
+ (void)goToBlindThirdAccountWithParams:(NSDictionary *)params
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;

/**
 获取用户未读消息数量
 */
+ (void)findUserUnreadMsgCount;

/**
 获取视频验证码

 @param success
 @param failure
 */
+ (void)getVideoPincodeSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

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
                     failure:(void (^)(NSError *error))failure;



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
                               failure:(void (^)(NSError *error))failure;



@end

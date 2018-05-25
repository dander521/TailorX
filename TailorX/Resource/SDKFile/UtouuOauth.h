//
//  UtouuOauth.h
//  有糖授权登录sdk
//
//  Created by 高习泰 on 16/10/28.
//  Copyright © 2016年 UTOUU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EnvironmentType) {
    EnvironmentTypeLive,  // 生产
    EnvironmentTypeTest,  // 测试
    EnvironmentTypeDev,   // 开发
};

typedef void (^callBack) (id obj);

typedef void (^handleCallBack) (id obj, NSError * error);

typedef void (^cancleCallBack) ();

@protocol UtouuOauthDelegate;
@interface UtouuOauth : NSObject

/**
 代理对象
 */
@property (nonatomic, assign) id<UtouuOauthDelegate> delegate;

/**
 获得当前sdk的版本号
 */
+ (NSString *)sdkVersion;

/**
 获得最新的token
 */
+ (NSString *)getNewAccessToken;

/**
 获得刷新前的token
 */
+ (NSString *)getOldAccessToken;

/**
 获得最新token的有效时间，单位为秒
 */
+ (NSString *)getExpiresIn;

/**
 获得openID
 */
+ (NSString *)getOpenID;

/**
 获得appkey
 */
+ (NSString *)getAppKey;

/**
 获得appid
 */
+ (NSString *)getAppID;

/**
 获得重定向地址
 */
+ (NSString *)getRedirentUrl;


/**
 是否安装UTOUU
 */
+ (BOOL)canOpenUTOUU;

+ (UtouuOauth *)oauthManager;

/**
 初始化SDK

 @param appID        应用的appid
 @param appKey       应用的appkey
 @param redirentUrl  重定向地址
 @param environmentType  环境

 @return 获取oauth20_state
 */
+ (UtouuOauth *)initWithAppID:(NSString *)appID appKey:(NSString *)appKey redirentUrl:(NSString *)redirentUrl delegate:(id<UtouuOauthDelegate>)delegate environmentType:(EnvironmentType)environmentType;

/**
 跳转到UTOUU授权
 
 @schemeStr      调用app注册在info.plist中的scheme
 @param callBack 授权回调信息
 */
+ (void)utouuOauthWithFromScheme:(NSString *)schemeStr callBack:(callBack)callBack;


/**
 授权回调
 
 @param url 回调信息
 */
+ (void)handleOpenURL:(NSURL *)url;

/**
 登录
 */
- (void)authorize;

- (void)authorizeWithController:(UIViewController *)presentController;


/**
 用户信息

 @param callBack 包含用户信息的字典
 */
+ (void)getUserInfoWithCallBack:(callBack)callBack;


/**
 刷新token

 @param callBack 包含刷新后的token信息 access_token：新的token  refresh_token：被刷新的token（旧的token）  expires_in：token过期时间（单位为秒）
 */
+ (void)refreshDeviceTokenWithCallBack:(callBack)callBack;

/**
 充值
 
 @param callBack 回调信息
 @param cancleCallback 返回
 */
+ (void)toChargeCallBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;

/**
 充值

 @param appID       appid
 @param openID      openID
 @param accessToken accessToken
 @param callBack 回调信息
 @param cancleCallback 返回
 */
+ (void)toChargeWithAppID:(NSString *)appID openID:(NSString *)openID accessToken:(NSString *)accessToken callBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;

/**
 提现
 
 @param callBack 回调信息
 @param cancleCallback 返回
 */
+ (void)toCashCallBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;


/**
 提现

 @param appID       appid
 @param openID      openID
 @param accessToken accessToken
 @param callBack 回调信息
 @param cancleCallback 返回
 */
+ (void)toCashWithAppID:(NSString *)appID openID:(NSString *)openID accessToken:(NSString *)accessToken callBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;

/**
 支付道具

 @param itemCode 道具CODE
 @param amount   道具个数
 @param code     第三方可用确定唯一的订单信息  可不传
 @param accountType 传“0”或不传（nil）
 @param callBack 支付结果回调
 @param cancleCallback 返回
 */
+ (void)payOrderWithPayItemCode:(NSString *)itemCode amount:(int)amount code:(NSString *)code accountType:(NSString *)accountType callBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;


/**
 支付道具  自定义传入appid  openid token

 @param itemCode    道具CODE
 @param amount      道具个数
 @param code        第三方可用确定唯一的订单信息  可不传
 @param appID       appid
 @param openID      openid
 @param accessToken token
 @param accountType 传“0”或不传（nil）
 @param callBack    支付结果回调
 @param cancleCallback 返回
 */
+ (void)payOrderWithPayItemCode:(NSString *)itemCode amount:(int)amount code:(NSString *)code appID:(NSString *)appID openID:(NSString *)openID accessToken:(NSString *)accessToken accountType:(NSString *)accountType callBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;


/**
 支付非道具

 @param payName     支付名称
 @param orderAmount 支付金额
 @param code        第三方可用确定唯一的订单信息  可不传
 @param accountType 传“0”或不传（nil）
 @param callBack    支付结果回调
 @param cancleCallback 返回
 */
+ (void)unItemPayOrderWithPayName:(NSString *)payName orderAmount:(float)orderAmount code:(NSString *)code accountType:(NSString *)accountType callBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;



/**
 支付非道具   自定义传入appid  openid token

 @param payName     支付名称
 @param orderAmount 支付金额
 @param code        第三方可用确定唯一的订单信息  可不传
 @param appID       appid
 @param openID      openID
 @param accessToken token
 @param accountType 传“0”或不传（nil）
 @param callBack    支付结果回调
 @param cancleCallback 返回
 */
+ (void)unItemPayOrderWithPayName:(NSString *)payName orderAmount:(float)orderAmount code:(NSString *)code appID:(NSString *)appID openID:(NSString *)openID accessToken:(NSString *)accessToken accountType:(NSString *)accountType callBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;


/**
 支付宝支付道具
 
 @param payName     支付名称
 @param orderAmount 支付金额
 @param code        第三方可用确定唯一的订单信息  可不传
 @param callBack    支付结果回调
 */
+ (void)alipayOrderWithPayName:(NSString *)payName orderAmount:(int)orderAmount code:(NSString *)code callBack:(callBack)callBack;



/**
 支付宝支付道具   自定义传入appid  openid token
 
 @param payName     支付名称
 @param orderAmount 支付金额
 @param code        第三方可用确定唯一的订单信息  可不传
 @param appID       appid
 @param openID      openID
 @param accessToken token
 @param callBack    支付结果回调
 */
+ (void)alipayOrderWithPayName:(NSString *)payName orderAmount:(int)orderAmount code:(NSString *)code appID:(NSString *)appID openID:(NSString *)openID accessToken:(NSString *)accessToken callBack:(callBack)callBack;


/**
 获取ticket

 @param url      url地址
 @param dic      参数
 @param callBack 请求结果回调
 */
+ (void)getTheTicketWithRequestUrl:(NSString *)url dictionary:(NSDictionary *)dic callBack:(callBack)callBack;

/**
 获取加密后的sign

 @param dicParamer 请求参数
 @param time       系统时间

 @return 加密后的sign
 */
+(NSString*)getStrSign:(NSDictionary*)dicParamer time:(NSString *)time;

/**
 获取系统时间
 */
+(NSString*)getSystemTime;


/**
 获取ticket
 */
+ (NSString *)getTicket;


/**
 推出注册界面
 
 @param callBack 注册回调
 */
+ (void)presentRegistViewControllerWithCallBack:(callBack)callBack;


/**
 用户行为事件上报

 @param value       事件值
 @param eventCode   事件code
 @param eventType   事件类型
 @param planKey     推广计划ID
 @param series     是否是上报连续登陆事件（“0”或“1”）
 */
+ (void)postEventWithValue:(NSString *)value eventCode:(NSString *)eventCode eventType:(NSString *)eventType planKey:(NSString *)planKey series:(NSString *)series callBack:(callBack)callBack;


/**
 用户上报事件，自定义传入参数字典

 @param dictionary 参数字典
 @param callBack 事件回调
 */
+ (void)postEventWithDictionary:(NSDictionary *)dictionary callBack:(callBack)callBack;

/**
 用户行为事件上报（根据用户设备号）

 @param value 事件值
 @param eventCode 事件code
 @param eventType 事件类型
 @param planKey 推广计划ID
 @param series 是否是上报连续登陆事件（“0”或“1”）
 @param deviceCode 设备号（唯一）
 @param callBack 是否是上报连续登陆事件（“0”或“1”）
 */
+ (void)postEventWithValue:(NSString *)value eventCode:(NSString *)eventCode eventType:(NSString *)eventType planKey:(NSString *)planKey series:(NSString *)series deviceCode:(NSString *)deviceCode callBack:(callBack)callBack;

/**
 用户上报事件，自定义传入参数字典（根据用户设备号）
 
 @param dictionary 参数字典
 @param callBack 事件回调
 */
+ (void)postEventWithDeviceCodeDictionary:(NSDictionary *)dictionary callBack:(callBack)callBack;

/**
 打开某个URL
 返回信息{@"msg":@"TGT error",@"code":@"9002",@"success":@"0"},表明TGT失效，需要重新登录
 @param urlString      url地址
 @param callBack       回调
 @param cancleCallback 返回
 */
+ (void)openTheURLWithUrlString:(NSString *)urlString callBack:(callBack)callBack cancleCallback:(cancleCallBack)cancleCallback;

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>自定义登录注册相关接口

/**
 获取授权信息

 @param callBack 授权信息
 */
+ (void)oauthListCallBack:(handleCallBack)callBack;


/**
 登录

 @param account 账号
 @param password 密码
 @param callBack 登录结果
 */
+ (void)loginWithAccount:(NSString *)account password:(NSString *)password callBack:(handleCallBack)callBack;


/**
 获取短信验证码

 @param account 手机号
 @param callBack 验证码信息
 */
+ (void)messageWithAccount:(NSString *)account callBack:(handleCallBack)callBack;


/**
 检测手机号码是否注册

 @param account 手机号
 @param callBack 验证信息
 */
+ (void)checkAccount:(NSString *)account callBack:(handleCallBack)callBack;


/**
 注册

 @param account 账号
 @param password 密码
 @param message 短信验证码
 @param callBack 注册信息
 */
+ (void)registWithAccount:(NSString *)account password:(NSString *)password message:(NSString *)message callBack:(handleCallBack)callBack;


/**
 找回密码第一步，验证手机号

 @param message 短信验证码
 @param account 手机号
 @param callBack 回调信息（信息中包含“forgetID”）
 */
+ (void)findPasswordWithMessage:(NSString *)message account:(NSString *)account callBack:(handleCallBack)callBack;


/**
 找回密码第二步，更新密码

 @param password 新密码
 @param forgetID 第一步中获取的forgetID
 @param callBack 回调信息
 */
+ (void)updatePasswordWithNewPassword:(NSString *)password forgetID:(NSString *)forgetID callBack:(handleCallBack)callBack;



@end

#pragma mark - 代理方法 -

@protocol UtouuOauthDelegate <NSObject>
/// 必须实现的代理方法
@required
/**
 sdk初始化之后的回调，如果初始化失败，无法在授权页面展示授权列表，但不影响后续功能
 */
- (void)initUtouuOauthSDK:(NSDictionary *)resultDic;

/// 非必须实现的代理方法
@optional

/**
 取消登录
 */
- (void)cancleLogin;

/**
 开始登录
 */
- (void)startLogin;

/**
 登录失败

 @param resultDic 登录失败
 */
- (void)loginFailWithFailedDic:(NSDictionary *)resultDic;

/**
 登录成功
 
 @param resultDic 登录成功
 */
- (void)loginSuccessWithSuccessDic:(NSDictionary *)resultDic;

@end


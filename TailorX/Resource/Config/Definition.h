//
//  Definition.h
//  TailorX
//
//  Created by Roger on 17/3/14.
//  Copyright © 2017年 utouu. All rights reserved.
//

#ifndef Definition_h
#define Definition_h

#pragma mark - Project Environment
/*****************************************TX_Environment***********************************************/
/**
 
 TX_Environment
 
 0:生产环境
 
 1:测试环境
 
 2:开发环境
  */
#if TX_Environment == 0
#define NSLog(...) {}
//#define NSLog(format, ...) printf("\n%s %s(line%d) %s\n%s\n\n", __TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]);
#elif TX_Environment == 1
#define NSLog(format, ...) printf("\n%s %s(line%d) %s\n%s\n\n", __TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]);
#elif TX_Environment == 2
#define NSLog(format, ...) printf("\n%s %s(line%d) %s\n%s\n\n", __TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]);
#endif
/*****************************************TX_Environment***********************************************/
#pragma mark - Font
/*****************************************Font***********************************************/
#define FONT(frontSize) [UIFont systemFontOfSize:frontSize]
#define FRONTWITHSIZE(frontSize) [UIFont fontWithName:@"MicrosoftYaHei" size:frontSize]
#define FONTType(type,frontSize) [UIFont fontWithName:type size:frontSize]
/*****************************************Font***********************************************/

#pragma mark - Color
/*****************************************Color***********************************************/
#define RGB(__r, __g, __b)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:1.0]
#define RGBA(__r, __g, __b, __a)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:__a]
#define LightColor RGB(247, 247, 247)
#define RedColor RGB(246, 47, 94)
#define TitleTextColor RGB(108, 108, 108)
#define StateTextColor RGB(153, 153, 153)
#define DefaultBlackColor RGB(51, 51, 15)
/*****************************************Color***********************************************/

#pragma mark - Frame
/*****************************************Frame***********************************************/
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define TRENDVC_HEIGHT [[UIScreen mainScreen] bounds].size.height - (kTopHeight + 44 + kTabBarHeight)

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define W(w) [[UIScreen mainScreen] bounds].size.width / 320 * w
#define H(h)  ([[UIScreen mainScreen] bounds].size.height > 568? [[UIScreen mainScreen] bounds].size.height : 568) / 568 * h
#define LayoutW(w)  [[UIScreen mainScreen] bounds].size.width / 375 * w
#define LayoutH(h)  ([[UIScreen mainScreen] bounds].size.height > 667 ? [[UIScreen mainScreen] bounds].size.height : 667) / 667 * h
#define SizeScale ([[UIScreen mainScreen] bounds].size.width >= 375 ? 1 : [[UIScreen mainScreen] bounds].size.width / 375)
#define LayoutF(f)  [UIFont systemFontOfSize:f * SizeScale]
/*****************************************Frame***********************************************/

#pragma mark - Login Params
/*******************************************Login Params***********************************************/
#define TX_app_name         @"tailorx"
#define TX_device_type      @"31" // device_type  ios 31  ios-p 32
#define TX_device_token     @""
/*******************************************Login Params***********************************************/

#pragma mark - TableView Subviews Height
/*******************************************TableView***********************************************/
#define TXZJScrollViewToolBarHeight                 60
#define TableViewDefaultOriginX                     16
#define TableViewSeperateLineLogisticOriginX        47
#define TableViewSeperateLineDefaultOriginX         121
#define TableViewSeperateLineHaChoiceButtonOriginX  159
#define TableViewOrderCellRowHeight                 155
#define TableViewOrderDetailCellRowHeight           110
#define TableViewOrderCellHeaderHeight              50
#define TableViewOrderCellFooterHeight              10
#define TableViewOrderCellEstimatedRowHeight        80
#define DefaultPageNumber                           0
#define DefaultPageLength                           10
#define DefaultDataCount                            0
/*******************************************TableView***********************************************/

#pragma mark - ServerResponse Params
/****************************************ServerResponse********************************************/
#define ServerResponse_result                   @"result"
#define ServerResponse_data                     @"data"
#define ServerResponse_msg                      @"msg"
#define ServerResponse_code                     @"code"
#define ServerResponse_success                  @"success"
#define ServerResponse_resultStatus             @"resultStatus"
#define ServerResponse_alipayCodeSuccess        @"9000"
#define ServerResponse_alipayCodeDealing        @"8000"
#define ServerResponse_alipayCodeCancel         @"6001"
#define ServerResponse_alipayCodeFail           @"4000"
#define ServerResponse_codeNotEnoughCash        2020 // 余额不足
#define ServerResponse_notSetAddress            5100 // 还未设置地址
/****************************************ServerResponse********************************************/

#pragma mark - ServerRequest Params
/***********************************接口传参通用字段宏**********************************************/
#define ServerParams_type                   @"type"
#define ServerParams_page                   @"page"
#define ServerParams_pageLength             @"pageLength"
#define ServerParams_orderNo                @"orderNo"
#define ServerParams_payMethod              @"payMethod"
#define ServerParams_deliveryType           @"deliveryType"
#define ServerParams_customerAddressId      @"customerAddressId"
#define ServerParams_amount                 @"amount"
#define ServerParams_orderPayQuantity       @"orderPayQuantity"
#define ServerParams_content                @"content"
#define ServerParams_attitudeScore          @"overallScore"
#define ServerParams_designerScore          @"designerScore"
#define ServerParams_satisfactionScore      @"factoryScore"
#define ServerParams_pictureFiles           @"pictureFiles"
/***********************************接口传参通用字段宏**********************************************/

#pragma mark - User Info
/***********************************User Info**********************************************/
// 获取用户信息
#define GetUserInfo ((TXUserModel*)[TXModelAchivar unachiveUserModel])
// 保存用户信息
#define SaveUserInfo(_KEY,_VALUE) [TXUserModel defaultUser]._KEY = _VALUE;[TXModelAchivar achiveUserModel]
#define GetConstInfo ((TXConstantModel*)[TXConstantModel sharedConstantModel])
/***********************************User Info**********************************************/

#pragma mark - Default Image
/***********************************Default Image**********************************************/

// 默认头像
#define kDefaultUeserHeadImg [UIImage imageNamed:@"ic_main_username_zhan"]
/***********************************Default Image**********************************************/

#pragma mark - Others
/*****************************************Others***********************************************/
// APP版本信息
#define APP_version @"CFBundleShortVersionString"
#define weakSelf(myself) __weak typeof(myself) weakSelf = myself;
#define LocalSTR(key)    NSLocalizedString(key, nil)
#define alipayScheme @"TailorX"
#define kShowMessageViewFrame CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0) //SCREEN_HEIGHT - LayoutH(51)
#define kErrorTitle @"网络状况不太好，请检查网络。"
#define kSuccess @"success"
#define kData @"data"
#define kMsg @"msg"
#define kRedTheme [[NSUserDefaults standardUserDefaults] boolForKey:@"redTheme"]
#define kDesignerStatusBusy @""
#define kDesignerStatusWorking @""
/*****************************************Others***********************************************/

#pragma mark - SingleTon
/*****************************************SingleTon***********************************************/
// 单例化一个类
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
/*****************************************SingleTon***********************************************/

#pragma mark - 微信支付
/*****************************************WeChatPay***********************************************/

#define WX_PAY_AppId        @"wx2565cc9cf8088bc1"
#define WX_PAY_AppSecret    @"e5f3043a8659b1b7770a46da02775b47"

/*****************************************WeChatPay***********************************************/
#pragma mark - 友盟
/*****************************************UM***********************************************/

#define UM_AppKey @"57c3aad267e58efafb001c24"
#define UM_WX_AppKey @"wxd29cb50b233e5cdd"
#define UM_WX_AppSecret @"1e810e82ea21dda527e06e0792b8854e"
#define UM_QQ_AppId @"1105626248"
#define UM_QQ_AppKey @"GjlHJq8pBlGgd6Az"

/*****************************************UM***********************************************/

#pragma mark - 环信
///*****************************************环信***********************************************/
//
//#define KF_AppKey  @"1111170715178695#utoxx" // @"1162170502178227#tailorx"
//#define KF_TenantId  @"45813" // @"40770"
//#define KF_IMId @"testuser" // @"tailorx"
//#define HX_PassWord @"password"
//
///*****************************************环信***********************************************/

#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* Definition_h */

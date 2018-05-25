//
//  TXUserModel.h
//  TailorX
//
//  Created by Qian Shen on 24/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXUserModel : NSObject

/** 是否登录*/
@property (nonatomic, copy) NSString *isLogin; // 1:已登录 其他：未登录
/** 令牌*/
@property (nonatomic, copy) NSString *st;
/** TGT*/
@property (nonatomic, copy) NSString *tgt;
/** udid*/
@property (nonatomic, copy) NSString *udid;
/** Token*/
@property (nonatomic, copy) NSString *deviceToken;
/** 密码*/
@property (nonatomic, copy) NSString *password;
/** 用户名（登录时录入）*/
@property (nonatomic, copy) NSString *accountA;
/** 用户名（获取时使用）*/
@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *openType;

/** 第三方注册标记 */
@property (nonatomic, copy) NSString *thirdGisterSign;

/*****************************OPENSDK*********************************/

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *unionId;

@property (nonatomic, copy) NSString *openId;

/*****************************获取用户个人信息-返回*********************************/

/** 用户当前所在的城市 */
@property (nonatomic, strong) NSString *currentCity;
/** 用户当前的经度 */
@property (nonatomic, strong) NSString *longitude;
/** 用户当前的纬度 */
@property (nonatomic, strong) NSString *latitude;
/** 默认地址 */
@property (nonatomic, strong) NSString *address;
/** */
@property (nonatomic, strong) NSString *genderText;
/** 悠唐昵称 */
@property (nonatomic, strong) NSString *nickName;
/** 客户联系电话 */
@property (nonatomic, strong) NSString *phone;
/** 头像 */
@property (nonatomic, strong) NSString *photo;
/** 性别 女 0 男 1 */
@property (nonatomic, assign) NSInteger gender;
/** 用户ID */
@property (nonatomic, assign) NSInteger userId;
/** 身高cm */
@property (nonatomic, assign) NSInteger height;
/** 体重kg */
@property (nonatomic, assign) NSInteger weight;
/** 手机绑定时间 */
@property (nonatomic, assign) NSInteger mobileBindDate;
/** 是否设置身体数据 */
@property (nonatomic, assign) BOOL hasBodyData;
/** 是否完善个人资料 */
@property (nonatomic, assign) BOOL hasFinishCustomerInfo;
/** 支付宝是否绑定 */
@property (nonatomic, assign) BOOL payBind;
/** 微信是否绑定 */
@property (nonatomic, assign) BOOL weixinBind;
/** qq是否绑定 */
@property (nonatomic, assign) BOOL qqBind;
/** 是否实名认证 */
@property (nonatomic, assign) BOOL realAuth;
/** 实名认证视频上传路径 */
@property (nonatomic, strong) NSString *videoPath;

/*****************************获取用户个人信息-返回*********************************/

/** 未读消息数量 */
@property (nonatomic, assign) NSInteger unreadMsgCount;
/** 推送的id */
@property (nonatomic, strong) NSString * deviceID;
/** 是否显示咨询引导页 */
@property (nonatomic, assign) BOOL isShowLeading;

/** 环信是否登录成功 */
@property (nonatomic, assign) BOOL hxLoginStatus;

/** 上次登录的用户 */
@property (nonatomic, strong) NSString *lastLoginAccount;

/** 环信-是否有未读信息 */
@property (nonatomic, assign) BOOL isUnreadMessages;

+ (TXUserModel *)defaultUser;

/**
 * 清楚用户数据
 */
- (void)resetModelData;

/**
 * 字典转模型
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 判断用户登录状态

 @return true：登录 false：未登录
 */
- (BOOL)userLoginStatus;


@end

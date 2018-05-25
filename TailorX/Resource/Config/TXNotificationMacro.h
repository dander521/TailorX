//
//  TXNotificationMacro.h
//  TailorX
//
//  Created by RogerChen on 2017/4/12.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXNotificationMacro : NSObject

#pragma mark - User Center

/** 修改用户头像通知 */
extern NSString * const kNSNotificationChangeUserAvatar;
/** 修改用户性别通知 */
extern NSString * const kNSNotificationChangeUserGender;
/** 修改用户量体数据通知 */
extern NSString * const kNSNotificationChangeUserBodyData;
/** 修改用户地址通知 */
extern NSString * const kNSNotificationChangeUserAddress;
/** 选择用户地址通知 */
extern NSString * const kNSNotificationSelectUserAddress;
/** 修改用户头昵称通知 */
extern NSString * const kNSNotificationChangeUserNickName;
/** 实名认证成功通知 */
extern NSString * const kNSNotificationVerifyUserRealName;
/** 实名认证视频成功通知 */
extern NSString * const kNSNotificationVerifyVedioSuccess;
/** 绑定支付宝成功通知 */
extern NSString * const kNSNotificationVerifyBindAliPaySuccess;
/** 退出登录 */
extern NSString * const kNSNotificationLogout;
/** 获取未读消息数量通知 */
extern NSString * const kNSNotificationFindUnreadMsgCount;
/** 刷新首页banner通知*/
extern NSString * const kNSNotificationRefreshHomeBanner;
/** 未读客服消息通知（Y:有未读消息 N:无未读消息）*/
extern NSString * const kNSNotificationFindNewServiceMessage;

#pragma mark - Order

/** 支付成功通知 */
extern NSString * const kNSNotificationPayOrderSuccess;
/** 评论成功通知 */
extern NSString * const kNSNotificationCommentSuccess;
/** 确认收货成功通知 */
extern NSString * const kNSNotificationReceiveSuccess;
/** 修改配送方式成功通知 */
extern NSString * const kNSNotificationChangeDeliverySuccess;
/** 删除订单成功 */
extern NSString * const kNSNotificationDeleteOrderSuccess;
/** 订单失效 */
extern NSString * const kNSNotificationOrderInvalid;

#pragma mark - Queue

/** 排号购买用户协议的通知 */
extern NSString *  const kNSNotificationProtocol;
/** 排号购买成功通知 */
extern NSString *  const kNSNotificationQueueNoBuySucceed;
/** 排号转让、取消、购买的通知 */
extern NSString *  const kNSNotificationQueueNoHandle;

#pragma mark - Login

/** 调用第三方登录*/
extern NSString *  const kNSNotificationBindThirdAccount;
/** 登录成功状态 */
extern NSString *  const kNSNotificationLoginSuccess;
/** 个人中心收藏数据的状态 */
extern NSString *  const kNSNotificationInformationState;
/** 资讯详情收藏数据的状态 */
extern NSString *  const kNSNotificationFavoriteInformationChanged;
/** 发现详情收藏数据的状态 */
extern NSString *  const kNSNotificationFavoriteDiscoverDetailChanged;

#pragma mark - AliPay

/** 支付宝付款成功 */
extern NSString *  const kNSNotificationAliPaySuccess;

/** 微信付款成功 */
extern NSString *  const kNSNotificationWXPaySuccess;

/** 微信付款失败 */
extern NSString *  const kNSNotificationWXPayFail;

#pragma mark - Html

/** 网页定制 */
extern NSString * const kNotificationHtmlAppointmentDesigner;

#pragma mark - Discover

/** 单击发现Item */
extern NSString * const kNotificationDiscoverItemSingleTap;

/** 双击发现Item */
extern NSString * const kNotificationDiscoverItemDoubleTap;

/** 双击滑动请求数据 */
extern NSString * const kNotificationDiscoverItemPanLatest;
extern NSString * const kNotificationDiscoverItemPanHeat;
extern NSString * const kNotificationDiscoverItemScrollLatest;
extern NSString * const kNotificationDiscoverItemScrollHeat;
extern NSString * const kNotificationDiscoverDetailItemPan;
extern NSString * const kNotificationDiscoverDetailItemScroll;

extern NSString * const kNotificationDiscoverAutoLoadDataSuccess;

extern NSString * const kNotificationChangeStore;

extern NSString * const kNSNotificationBodyImageChangeSuccess;

@end

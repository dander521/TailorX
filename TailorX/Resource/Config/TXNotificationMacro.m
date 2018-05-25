//
//  TXNotificationMacro.m
//  TailorX
//
//  Created by RogerChen on 2017/4/12.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXNotificationMacro.h"

@implementation TXNotificationMacro

#pragma mark - User Center

/** 修改用户头像通知 */
NSString * const kNSNotificationChangeUserAvatar = @"kNotificationChangeUserAvatar";
/** 修改用户性别通知 */
NSString * const kNSNotificationChangeUserGender = @"kNSNotificationChangeUserGender";
/** 修改用户量体数据通知 */
NSString * const kNSNotificationChangeUserBodyData = @"kNSNotificationChangeUserBodyData";
/** 修改用户地址通知 */
NSString * const kNSNotificationChangeUserAddress = @"kNSNotificationChangeUserAddress";
/** 选择用户地址通知 */
NSString * const kNSNotificationSelectUserAddress = @"kNSNotificationSelectUserAddress";
/** 修改用户头昵称通知 */
NSString * const kNSNotificationChangeUserNickName = @"kNSNotificationChangeUserNickName";
/** 实名认证成功通知 */
NSString * const kNSNotificationVerifyUserRealName = @"kNSNotificationVerifyUserRealName";
/** 实名认证视频成功通知 */
NSString * const kNSNotificationVerifyVedioSuccess = @"kNSNotificationVerifyVedioSuccess";
/** 绑定支付宝成功通知 */
NSString * const kNSNotificationVerifyBindAliPaySuccess = @"kNSNotificationVerifyBindAliPaySuccess";
/** 退出登录 */
NSString * const kNSNotificationLogout = @"kNSNotificationLogout";
/** 获取未读消息数量通知 */
NSString * const kNSNotificationFindUnreadMsgCount = @"kNSNotificationFindUnreadMsgCount";
/** 刷新首页banner通知*/
NSString * const kNSNotificationRefreshHomeBanner = @"kNSNotificationRefreshHomeBanner";
/** 未读客服消息通知（Y:有未读消息 N:无未读消息）*/
NSString * const kNSNotificationFindNewServiceMessage = @"kNSNotificationFindNewServiceMessage";


#pragma mark - Order

/** 支付成功通知 */
NSString * const kNSNotificationPayOrderSuccess = @"kNSNotificationPayOrderSuccess";
/** 评论成功通知 */
NSString * const kNSNotificationCommentSuccess = @"kNSNotificationCommentSuccess";
/** 确认收货成功通知 */
NSString * const kNSNotificationReceiveSuccess = @"kNSNotificationReceiveSuccess";
/** 修改配送方式成功通知 */
NSString * const kNSNotificationChangeDeliverySuccess = @"kNSNotificationChangeDeliverySuccess";
/** 删除订单成功 */
NSString * const kNSNotificationDeleteOrderSuccess = @"kNSNotificationDeleteOrderSuccess";
/** 订单失效 */
NSString * const kNSNotificationOrderInvalid = @"kNSNotificationOrderInvalid";

#pragma mark - Queue

/** 排号购买用户协议的通知 */
NSString *  const kNSNotificationProtocol = @"kNSNotificationProtocol";
/** 排号转让、取消、购买的通知 */
NSString *  const kNSNotificationQueueNoHandle = @"kNSNotificationQueueNoHandle";
/** 排号购买成功通知 */
NSString *  const kNSNotificationQueueNoBuySucceed = @"kNSNotificationQueueNoBuySucceed";

#pragma mark - Login

/** 调用第三方登录*/
NSString *  const kNSNotificationBindThirdAccount = @"kNSNotificationBindThirdAccount";
/** 登录成功状态 */
NSString *  const kNSNotificationLoginSuccess = @"kNSNotificationLoginSuccess";
/** 个人中心收藏数据的状态 */
NSString *  const kNSNotificationInformationState = @"kNSNotificationInformationState";
/** 资讯详情收藏数据的状态 */
NSString *  const kNSNotificationFavoriteInformationChanged = @"favoriteInformationChanged"; //切忌修改
/** 发现详情收藏数据的状态 */
NSString *  const kNSNotificationFavoriteDiscoverDetailChanged = @"kNSNotificationFavoriteDiscoverDetailChanged"; //切忌修改

#pragma mark - AliPay

/** 支付宝付款成功 */
NSString *  const kNSNotificationAliPaySuccess = @"kNSNotificationAliPaySuccess";
/** 微信付款成功 */
NSString *  const kNSNotificationWXPaySuccess = @"kNSNotificationWXPaySuccess";
/** 微信付款成功 */
NSString *  const kNSNotificationWXPayFail = @"kNSNotificationWXPayFail";

#pragma mark - Html

/** 网页定制 */
NSString * const kNotificationHtmlAppointmentDesigner = @"kNotificationHtmlAppointmentDesigner";

#pragma mark - Discover

/** 单击发现Item */
NSString * const kNotificationDiscoverItemSingleTap = @"clickDiscoverItemSingleTap";

/** 双击发现Item */
NSString * const kNotificationDiscoverItemDoubleTap = @"clickDiscoverItemDoubleTap";
/** 双击滑动请求数据 */
NSString * const kNotificationDiscoverItemPanLatest = @"kNotificationDiscoverItemPanLatest";
NSString * const kNotificationDiscoverItemPanHeat = @"kNotificationDiscoverItemPanHeat";
NSString * const kNotificationDiscoverItemScrollLatest = @"kNotificationDiscoverItemScrollLatest";
NSString * const kNotificationDiscoverItemScrollHeat = @"kNotificationDiscoverItemScrollHeat";
NSString * const kNotificationDiscoverDetailItemPan = @"kNotificationDiscoverDetailItemPan";
NSString * const kNotificationDiscoverDetailItemScroll = @"kNotificationDiscoverDetailItemScroll";
NSString * const kNotificationDiscoverAutoLoadDataSuccess = @"kNotificationDiscoverAutoLoadDataSuccess";

NSString * const kNotificationChangeStore = @"kNotificationChangeStore";
NSString * const kNSNotificationBodyImageChangeSuccess = @"kNSNotificationBodyImageChangeSuccess";
@end

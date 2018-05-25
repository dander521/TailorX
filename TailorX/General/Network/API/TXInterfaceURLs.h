//
//  TXInterfaceURLs.h
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TXInterfaceURLs : NSObject

extern NSString * const strTailorxAPI;
extern NSString * const strPassport;

extern NSString * const TX_utouuAppId;

/**********************************************/

/** 获取st*/
extern NSString * const strst;

/** utouu登录接口*/
extern NSString * const strUtouuAPI;
/** 注册短信请求*/
extern NSString * const strRequestMessageResult;
/** 注册接口*/
extern NSString * const strRegisterResult;
/** TX接口 */
extern NSString * const strTailorxAPI;

extern NSString * const TX_utouuAppKey;
/** 图形验证码*/
extern NSString * const strRegister;
/** 获取图形验证码*/
extern NSString * const strSMSPic;
/** 重新获取验证码（找回时使用）*/
extern NSString * const str_forget_resendSms;
/**获取验证码（找回时使用）*/
extern NSString * const str_forget_sendSms;
/** 找回密码*/
extern NSString * const findBack_password;
/** 创建客户*/
extern NSString *const strAddCustomer;

// 推送
/** pushKey */
extern NSString * const pushKey;
/** pushSecre t*/
extern NSString * const pushSecret;

// 环信
extern NSString * const KF_ApnsCertName;
extern NSString * const KF_AppKey;
extern NSString * const KF_TenantId;
extern NSString * const KF_IMId;
extern NSString * const HX_PassWord;
extern NSString * const KF_QueueInfo;

#pragma mark - Order Interface

/** 订单列表 */
extern NSString * const strOrderList;
/** 订单详情 */
extern NSString * const strOrderDetail;
/** 订单支付 */
extern NSString * const strOrderPay;
/** 订单确认收货 */
extern NSString * const strOrderConfirmReceive;
/** 订单物流详情 */
extern NSString * const strOrderLogisticDetail;
/** 订单评论 */
extern NSString * const strOrderComment;
/** 保存配送方式 */
extern NSString * const strOrderSavaDeliveryType;
/** 获取订单配送方式和送货信息 */
extern NSString * const strOrderGetDeliveryAndAddress;
/** 订单评价详情 */
extern NSString * const strOrderCommentDetail;
/** 订单失效 */
extern NSString * const strOrderInvalid;

#pragma mark - User Center

/** 获取用户个人信息 */
extern NSString * const strUserCenterGetCustomerPersonalInfo;
/** 修改客户头像 */
extern NSString * const strUserCenterModifyCustomerAvatar;
/** 检查修改头像时间 */
extern NSString * const strUserCenterGetChangeAvatarTime;
/** 检查昵称时间 */
extern NSString * const strUserCenterGetChangeNicknameTime;
/** 修改客户昵称 */
extern NSString * const strUserCenterModifyNickname;
/** 更新客户性别 */
extern NSString * const strUserCenterModifyCustomSex;
/** 设置用户身高体重 */
extern NSString * const strUserCenterModifyBodydata;
/** 查询客户收货地址列表 */
extern NSString * const strUserCenterGetCustomerLogisticAddress;
/** 添加新收货地址 */
extern NSString * const strUserCenterAddNewLogisticAddress;
/** 更新收货地址 */
extern NSString * const strUserCenterUpdateLogisticAddress;
/** 设置客户的默认收货地址 */
extern NSString * const strUserCenterSetDefaultLogisticAddress;
/** 删除收货地址 */
extern NSString * const strUserCenterDeleteLogisticAddress;
/** 创建客户 */
extern NSString * const strUserCenterCreateCustomer;
/** 记录充值记录 */
extern NSString * const strUserCenterRecordChargeHistory;
/** 获取余额 */
extern NSString * const strUserCenterGetFundBalance;
/** 获取用户交易记录 */
extern NSString * const strUserCenterGetCustomerTransactionHistory;
/** 查询支付宝绑定信息 */
extern NSString * const strUserCenterCheckAliPayBindStatus;
/** 绑定修改支付宝信息 */
extern NSString * const strUserCenterUpdateAliPay;
/** 获取认证证件类型 */
extern NSString * const strUserCenterGetCertificateType;
/** 获取实名认证状态 */
extern NSString * const strUserCenterGetRealNameAuthStatus;
/** 实名认证 */
extern NSString * const strUserCenterRealNameAuth;
/** 视频认证码 */
extern NSString * const strUserCenterGetVedioCode;
/** 上传视频 */
extern NSString * const strUserCenterUploadVedio;
/** 获取用户默认地址 */
extern NSString * const strUserCenterGetUserDefaultAddress;
/** 获取未读通知条数 */
extern NSString * const strUserCenterFindUnreadMsgCount;

/** 获取个人收藏资讯 */
extern NSString * const strUserCenterfindFavoriteInfo;
/** 获取个人收藏设计师 */
extern NSString * const strUserCenterGetFavoriteDesignerList;
/** 个人收藏取消收藏设计师 */
extern NSString * const strUserCenterGetFavoriteListDelete;

/******************************3.2.0******************************/

/** 获取个人收藏精选图片 */
extern NSString * const strUserCenterfindFavoritePicture;
/** 收藏/取消收藏 精选图片 */
extern NSString * const strUserCenterAddOrCancelFavoritePicture;

/******************************3.2.0******************************/

#pragma mark information
/** 通过条件模糊查询资讯列表 */
extern NSString * const strInformationFindInformationList;
/** 获取资讯banner图 */
extern NSString * const strInformationGetInformationBanenr;
/** 获取筛选三级参数数组 */
extern NSString * const strInformationFindCategoryList;
/** 获取所有的门店名字 */
extern NSString * const findStoreNameList;
/** 获取资讯详情 */
extern NSString * const strInformationGetInformationDetail;
/** 收藏资讯 */
extern NSString * const strInformationAddFavoriteInfo;
/** 取消收藏资讯 */
extern NSString * const strInformationDeleteFavoriteInfo;
/** 取消收藏设计师 */
extern NSString * const strInformationDeleteFavoriteDesigner;
/** 查询资讯评论列表 */
extern NSString * const strInformationfindFeedbackList;
/** 添加资讯评论 */
extern NSString * const strInformationAddFeedBack;

FOUNDATION_EXPORT NSString * const strInfomationShareUrl;

FOUNDATION_EXPORT NSString * const strDiscoverShareUrl;

#pragma mark store

/** 获取所有的门店列表 */
extern NSString * const strUserStoreAllList;


/******************* 钱包 ***************************/

/** 获取余额 */
extern NSString * const findMyBalance;
/** 添加充值记录 */
extern NSString * const addRechargeRecord;
/** 获取用户交易记录 */
extern NSString * const findTransactionRecordList;
/** 收益转余额 */
extern NSString * const incomeToBalance;
/** 检测提现 */
extern NSString * const checkWithdrawDeposit;
/** 提现接口 */
extern NSString * const withdrawDeposit;
/** 提现获取短信验证码 */
extern NSString * const getVcode;
/** 注册获取短信验证码 */
extern NSString * const getRegisterVcode;



/******************* 排号 ***************************/


/** 查询我的排号记录列表 */
extern NSString * const findMyRankNumList;

/** 查询排号记录列表 */
extern NSString * const findRankNumList;

/** 出让排号 */
extern NSString * const updateRankNumForSale;

/** 取消出让排号 */
extern NSString * const updateRankNumStatus;

/** 支付接口 */
extern NSString * const updateRankNumRecord;

/** 查询买入/卖出排号交易记录列表 */
extern NSString * const findRecordList;

/** 跳转到支付界面前调用，检查购买状态,添加购买记录 */
extern NSString * const addRankNumRecord;

/** 排号订单支付 */
extern NSString * const payRank;



#pragma mark home

/** 显示Homebanner图集 */
extern NSString * const strHomeFindBannerList;
/** 查询精品推荐（也就是资讯图片） 默认6个*/
extern NSString * const strHomeFindInformationImgList;
/** 显示明星设计师 */
extern NSString * const strHomeFindStarDesignerList;
/** 获取精选图详情 */
extern NSString * const strHomeGetCulling;
/** 收藏精选图 */
extern NSString * const strHomeAddCulling;
/** 批量取消收藏 */
extern NSString * const strHomeDeleteFavoriteCulling;
/** 查找所有门店*/
extern NSString * const strHomeFindStoreList;
/** 查询门店详细信息*/
extern NSString * const strHomeGetStoreDetail;
/** 查询门店详情中的设计师列表*/
extern NSString * const strHomeGetStoreDesignerList;
/** 获取当前用户所有预约信息*/
extern NSString * const strHomeFindAppointmentList;
/** 获取消息列表*/
extern NSString * const strHomeFindMsgList;
/**取消预约订单*/
extern NSString * const strHomeCancelAppointment;
/** 修改消息状态*/
extern NSString * const strHomeUpdateStatus;
/** 删除、已读所有通知(一键阅读)*/
extern NSString * const strHomeUpdateAllStatus;
/**通过设计师ID查询设计师详情*/
extern NSString * const strHomeGetDesigner;
/** 根据设计师ID查询评论*/
extern NSString * const strHomeGetDesignerCommentList;
/** 根据设计师id查询所制作的作品*/
extern NSString * const strHomeGetDesignerProductionList;
/** 查询设计师可预约的时间*/
extern NSString * const strHomeFindDesignerAppointmentTime;
/** 收藏/取消 【设计师】*/
extern NSString * const strHomeLikeOrabolishDesigner;
/** 查询定制分类*/
extern NSString * const strHomeGetCustomClassify;
/** 提交预约*/
extern NSString * const strHomeCommitAppointment;
/** 支付预约*/
extern NSString * const strHomePayAppointment;
/** 查询用户在所有门店的身体数据*/
extern NSString * const strUserCenterFindMyAllBodyDataList;
/** 查询用户某个门店的身体数据*/
extern NSString * const strUserCenterFindMyBodyDataList;
/** 推荐设计师列表*/
extern NSString * const strHomeFindRecommendDesignerList;
/** 查询定金*/
extern NSString * const strHomeGetEarnest;
/** 删除预约订单 */
extern NSString * const strHomeDeleteAppointment;
/** 查询参考图片 */
extern NSString * const strHomeFindBodyPic;
/** 添加参考图片 */
extern NSString * const strHomeAddBodyPicture;
/** 删除参考图片 */
extern NSString * const strHomeDeleteBodyPicture;
/** 查看定制进度 */
extern NSString * const strHomeFindProcessNodeDetail;
/** 查看设计师预约状态*/
extern NSString * const strHomeCheckDesignerAppointStatus;
/** 获取设计师列表*/
extern NSString * const strHomeFindDesignerList;

/******************* 推送设置 ***************************/
/** 获取用户的推送设置 */
extern NSString * const findSettings;
/** 更新用户推送设置 */
extern NSString * const updateSettings;
/** 检查app版本更新 */
extern NSString * const checkAppUpdate;

/******************* TailorX2.0.5 新增接口 ***************************/

/** 查询有门店的列表城市 */
extern NSString * const findStoreCity;
/** 评论未通过详情 */
extern NSString * const findCommentNoPass;
/** 排号交易成功 */
extern NSString * const findRankNumData;
/** 预约设计师详情 */
extern NSString * const findAppointmentData;
/** 根据订单编号获取排号id */
extern NSString * const findRankNumId;
/** 修改密码 */
extern NSString * const updatePassword;


/******************* TailorX3.2.0 新增接口 ***************************/

/** 获取发现筛选分类 */
extern NSString * const strDiscoverFindAllTags;
/** 获取发现所有数据 */
extern NSString * const strDiscoverFindPictureList;
/** 获取首页资讯合集 */
extern NSString * const strHomeGetTagGroups;
/** 获取发现详情 */
extern NSString * const strDiscoverFindPictureDetail;
/** 获取时尚外套 */
extern NSString * const strInformationGroupInfo;
/** 分享图片 */
extern NSString * const strDiscoverSharePicture;
/** 推荐图片 */
extern NSString * const strDiscoverGetRecommendPictureList;
/** 分享资讯图片 */
extern NSString * const strShareInformation;

/******************* TailorX3.2.1 新增接口 ***************************/
/** 获取设计师信息 */
extern NSString * const strGetOrderDesignerInfo;

/******************* TailorX3.3.0 新增接口 ***************************/

/** 发现作品  pictureId */
extern NSString * const strFindRecommendDesignerWorkList;
/** 作品详情 workId */
extern NSString * const strGetDesignerWorkDetail;

/******************* TailorX3.3.5 新增接口 ***************************/
/** 搜索结果 */
extern NSString * const strSearchResult;

@end

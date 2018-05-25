//
//  TXInterfaceURLs.m
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInterfaceURLs.h"

@implementation TXInterfaceURLs

/**
 
 TX_Environment
 
 0:生产环境
 
 1:开发环境
 
 2:测试环境
 
 */

#if TX_Environment == 0

NSString * const strUtouuAPI = @"http://api.utouu.com";
NSString * const strTailorxAPI = @"https://app.tailorx.cn";
NSString * const strPassport = @"https://passport.utouu.com/";
NSString * const strRegister = @"http://msg.utouu.com/";//获取验证码
NSString * const strUtouu = @"http://api.utouu.com/";
NSString * const strBKAPI = @"http://api.bestkeep.cn/";
NSString * const TX_utouuAppId = @"51j8qWwRSmiCkl4yKyjCfQ";
NSString * const TX_utouuAppKey = @"yPaE_OMHTruCN7TL0ohf7g";
NSString * const strInfomationShareUrl = @"http://www.tailorx.cn/share_index.html?infoId=";
NSString * const strDiscoverShareUrl = @"http://www.tailorx.cn/share-find.html?id=";

NSString * const KF_ApnsCertName = @"pushlive";
NSString * const KF_AppKey = @"1162170502178227#tailorx";
NSString * const KF_TenantId = @"40770";
NSString * const KF_IMId = @"tailorx";
NSString * const HX_PassWord = @"password";
NSString * const KF_QueueInfo = @"TailorX";

#elif TX_Environment == 1

NSString * const strTailorxAPI = @"http://app.dev.tailorx.cn";
NSString * const strUtouuAPI = @"http://api.dev.utouu.com";
NSString * const strPassport = @"https://passport.dev.utouu.com/";
NSString * const strRegister = @"http://msg.dev.utouu.com/";//获取验证码
NSString * const strUtouu = @"http://api.dev.utouu.com/";
NSString * const strBKAPI = @"http://api.dev.bestkeep.cn/";
NSString * const TX_utouuAppId = @"66Ljta9gQHK-2lHITjtbag";
NSString * const TX_utouuAppKey = @"qFOKXZCbRpyNybF3cfKN1Q";
NSString * const strInfomationShareUrl = @"http://www.dev.tailorx.cn/share_index.html?infoId=";
NSString * const strDiscoverShareUrl = @"http://www.dev.tailorx.cn/share-find.html?id=";
NSString * const KF_ApnsCertName = @"pushdev";
NSString * const KF_AppKey = @"1465170906068782#kefuchannelapp47162";
NSString * const KF_TenantId = @"47162";
NSString * const KF_IMId = @"kefuchannelimid_239477";
NSString * const HX_PassWord = @"password";
NSString * const KF_QueueInfo = @"TailorX";

#elif TX_Environment == 2

NSString * const strTailorxAPI = @"http://app.test.tailorx.cn";
//曹坤祥
//NSString * const strTailorxAPI = @"http://192.168.11.215:30705";
//鲁亚强
//NSString * const strTailorxAPI = @"http://192.168.51.67:30705";
//邓志伟
//NSString * const strTailorxAPI = @"http://192.168.50.197:30705";
//蒲镜帆tailorx
//NSString * const strTailorxAPI = @"http://192.168.11.233:30705";

NSString * const strUtouuAPI = @"http://api.test.utouu.com";
NSString * const strPassport = @"https://passport.test.utouu.com/";
NSString * const strRegister = @"http://msg.test.utouu.com/";//获取图形验证码
NSString * const strUtouu = @"http://api.test.utouu.com/";
NSString * const strBKAPI = @"http://api.test.bestkeep.cn/";
NSString * const TX_utouuAppId = @"Ax04dRWIQTm7r27pkM0GEQ";
NSString * const TX_utouuAppKey = @"inwd9uubTeqsRKAWaRC6vg";
NSString * const strInfomationShareUrl = @"http://www.test.tailorx.cn/share_index.html?infoId=";
NSString * const strDiscoverShareUrl = @"http://www.test.tailorx.cn/share-find.html?id=";
NSString * const KF_ApnsCertName = @"pushdev";
NSString * const KF_AppKey = @"1465170906068782#kefuchannelapp47162";
NSString * const KF_TenantId = @"47162";
NSString * const KF_IMId = @"kefuchannelimid_239477";
NSString * const HX_PassWord = @"password";
NSString * const KF_QueueInfo = @"TailorX";

#else

#warning"未匹配环境"

#endif

NSString * const pushKey = @"23758468";
NSString * const pushSecret = @"4c83bda99e43db6d04c9e9a138ebd3fc";

/** 获取ST*/
NSString * const strst = @"m1/tickets";
/** 注册短信请求*/
NSString * const strRequestMessageResult = @"api/v3/account/send-sms";
/** 注册接口*/
NSString * const strRegisterResult = @"api/v3/account/register";
/** 获取图形验证码*/
NSString * const strSMSPic = @"v1/img/vcode";
/** 重新获取验证码找回时使用）*/
NSString * const str_forget_resendSms = @"api/user/forget/reSendSms";
/**获取验证码（找回时使用）*/
NSString * const str_forget_sendSms = @"api/user/forget/sendSms";
/** 找回密码*/
NSString *const findBack_password = @"api/user/forget-mod-pwd";
/** 创建客户*/
NSString *const strAddCustomer = @"/v2/app/customer/addCustomer";

/******************* 排号 ***************************/

/** 查询我的排号记录列表 */
NSString * const findMyRankNumList = @"/v2/app/rankNum/findMyRankNumList";
/** 查询排号记录列表 */
NSString * const findRankNumList = @"/v2/app/rankNum/findRankNumList";
/** 取消/出让排号 */
NSString * const updateRankNumStatus = @"/v2/app/rankNum/updateRankNumStatus";
/** 支付接口 */
NSString * const updateRankNumRecord = @"/v2/app/rankNum/updateRankNumRecord";
/** 查询买入/卖出排号交易记录列表 */
NSString * const findRecordList = @"/v2/app/rankNum/findRecordList";
/** 跳转到支付界面前调用，检查购买状态,添加购买记录 */
NSString * const addRankNumRecord = @"/v2/app/rankNum/addRankNumRecord";
/** 排号订单支付 */
NSString * const payRank = @"/v2/app/rankNum/payRank";

/******************* 钱包 ***************************/
#pragma mark - 钱包
/** 获取余额 */
NSString * const findMyBalance = @"/v2/app/customer/findMyBalance";
/** 添加充值记录 */
NSString * const addRechargeRecord = @"/v2/app/customer/accountRecharge";
/** 获取用户交易记录 */
NSString * const findTransactionRecordList = @"/v2/app/customer/findTransactionRecordList";
/** 收益转余额 */
NSString * const incomeToBalance = @"/v2/app/customer/incomeToBalance";
/** 提现检查 */
NSString * const checkWithdrawDeposit = @"/v2/app/customer/checkWithdrawDeposit";
/** 提现接口 */
NSString * const withdrawDeposit = @"/v2/app/customer/withdrawDeposit";
/** 提现获取短信验证码 */
NSString * const getVcode = @"/v2/app/customer/getVcode";
/** 注册获取短信验证码 */
NSString * const getRegisterVcode = @"/v2/app/customer/getRegisterVcode";

#pragma mark - Order Interface

/** 订单列表 */
NSString * const strOrderList = @"/v3/app/order/myOrderList";
/** 订单详情 */
NSString * const strOrderDetail = @"/v3/app/order/detail";
/** 订单支付 */
NSString * const strOrderPay = @"/v3/app/order/pay";
/** 订单确认收货 */
NSString * const strOrderConfirmReceive = @"/v3/app/order/confirmReceive";
/** 订单物流详情 */
NSString * const strOrderLogisticDetail = @"/v3/app/order/express";
/** 订单评论 */
NSString * const strOrderComment = @"/v3/app/order/addFeedback";
/** 保存配送方式 */
NSString * const strOrderSavaDeliveryType = @"/v3/app/order/saveOrderDeliveryAndAddress";
/** 获取订单配送方式和送货信息 */
NSString * const strOrderGetDeliveryAndAddress = @"/v2/app/order/getOrderDeliveryAndAddress";
/** 订单评价详情 */
NSString * const strOrderCommentDetail = @"/v3/app/order/evaluatedOrderDetail";
/** 订单失效 */
NSString * const strOrderInvalid = @"/v3/app/order/invalidOrder";

#pragma mark - User Center

/** 获取用户信息 */
NSString * const strUserCenterGetCustomerPersonalInfo = @"/v2/app/customer/getCustomer";
/** 修改客户头像 */
NSString * const strUserCenterModifyCustomerAvatar = @"/v2/app/customer/updateCustomerPhoto";
/** 检查修改头像时间 */
NSString * const strUserCenterGetChangeAvatarTime = @"/v2/app/customer/checkCustomerPhoto";
/** 检查昵称时间 */
NSString * const strUserCenterGetChangeNicknameTime = @"/v2/app/customer/checkCustomerNickname";
/** 修改客户昵称 */
NSString * const strUserCenterModifyNickname = @"/v2/app/customer/updateCustomerNickname";
/** 更新客户性别 */
NSString * const strUserCenterModifyCustomSex = @"/v2/app/customer/updateCustomerGender";
/** 设置用户身高体重 */
NSString * const strUserCenterModifyBodydata = @"/v2/app/customer/updateCustomerBody";
/** 查询客户收货地址列表 */
NSString * const strUserCenterGetCustomerLogisticAddress = @"/v2/app/customer/findCustomerAddressList";
/** 添加新收货地址 */
NSString * const strUserCenterAddNewLogisticAddress = @"/v2/app/customer/addAddress";
/** 更新收货地址 */
NSString * const strUserCenterUpdateLogisticAddress = @"/v2/app/customer/updateAddress";
/** 设置客户的默认收货地址 */
NSString * const strUserCenterSetDefaultLogisticAddress = @"/v2/app/customer/updateDefaultAddress";
/** 删除收货地址 */
NSString * const strUserCenterDeleteLogisticAddress = @"/v2/app/customer/deleteAddress";
/** 创建客户 */
NSString * const strUserCenterCreateCustomer = @"/v2/app/customer/addCustomer";
/** 记录充值记录 */
NSString * const strUserCenterRecordChargeHistory = @"/v2/app/customer/addRechargeRecord";
/** 获取余额 */
NSString * const strUserCenterGetFundBalance = @"/v2/app/customer/findMyBalance";
/** 获取用户交易记录 */
NSString * const strUserCenterGetCustomerTransactionHistory = @"/v2/app/customer/findTransactionRecordList";
/** 查询支付宝绑定信息 */
NSString * const strUserCenterCheckAliPayBindStatus = @"/v2/app/customer/getUserPayInfo";
/** 绑定修改支付宝信息 */
NSString * const strUserCenterUpdateAliPay = @"/v2/app/customer/updateAliPay";
/** 获取认证证件类型 */
NSString * const strUserCenterGetCertificateType = @"/v2/app/customer/getCredentialsType";
/** 获取实名认证状态 */
NSString * const strUserCenterGetRealNameAuthStatus = @"/v2/app/customer/checkRealNameAuth";
/** 实名认证 */
NSString * const strUserCenterRealNameAuth = @"/v2/app/customer/readNameAuth";
/** 视频认证码 */
NSString * const strUserCenterGetVedioCode = @"/v2/app/customer/getSmscpin";
/** 上传视频 */
NSString * const strUserCenterUploadVedio = @"/v2/app/customer/completionVideoSmsc";

/** 获取用户默认地址 */
NSString * const strUserCenterGetUserDefaultAddress = @"/v2/app/customer/findDefaultAddress";
/** 获取未读通知条数 */
NSString * const strUserCenterFindUnreadMsgCount = @"/v2/app/message/findUnreadMsgCount";
/** 获取个人收藏资讯 */
NSString * const strUserCenterfindFavoriteInfo = @"/v2/app/showHomePage/findFavoriteInfo";
/** 获取个人收藏设计师 */
NSString * const strUserCenterGetFavoriteDesignerList = @"/v2/app/designer/findFavoriteDesignerList";
/** 个人收藏取消收藏设计师 */
NSString * const strUserCenterGetFavoriteListDelete = @"/v2/app/designer/deleteFavoriteDesigner";


/******************************3.2.0******************************/

/** 获取个人收藏精选图片 */
NSString * const strUserCenterfindFavoritePicture = @"/v3/app/picture/findFavoritePicture";
/** 收藏/取消收藏 精选图片 */
NSString * const strUserCenterAddOrCancelFavoritePicture = @"/v3/app/picture/favoritePicture";

/******************************3.2.0******************************/

#pragma mark information

/** 通过条件模糊查询资讯列表 */
NSString * const strInformationFindInformationList = @"/v2/app/showHomePage/findAPPInformationList";
/** 获取资讯banner图 */
NSString * const strInformationGetInformationBanenr = @"/v2/app/showHomePage/getInformationBanenr";
/** 获取筛选三级参数数组 */
NSString * const strInformationFindCategoryList = @"/v2/app/category/findCategoryList";
/** 获取所有的门店名字 */
NSString * const findStoreNameList = @"/v2/app/store/findStoreNameList";
/** 获取资讯详情 */
NSString * const strInformationGetInformationDetail = @"/v3/app/information/getInformationDetail";
/** 收藏资讯 */
NSString * const strInformationAddFavoriteInfo = @"/v2/app/culling/addFavoriteInfo";
/** 取消收藏资讯 */
NSString * const strInformationDeleteFavoriteInfo = @"/v2/app/showHomePage/deleteFavoriteInfo";
/** 取消收藏设计师 */
NSString * const strInformationDeleteFavoriteDesigner = @"/v2/app/designer/deleteFavoriteDesigner";
/** 查询资讯评论列表 */
NSString * const strInformationfindFeedbackList = @"/v2/app/culling/findFeedbackList";
/** 添加资讯评论 */
NSString * const strInformationAddFeedBack = @"/v2/app/culling/addFeedback";

#pragma mark store
/** 获取所有的门店列表 */
NSString * const strUserStoreAllList = @"/v2/app/store/findStoreList";

#pragma mark home

/** 显示Homebanner图集 */
NSString * const strHomeFindBannerList = @"/v2/app/store/findBannerList";
/** 查询精品推荐（也就是资讯图片） 默认6个*/
NSString * const strHomeFindInformationImgList = @"/v2/app/showHomePage/findInformationImgList";
/** 显示明星设计师 */
NSString * const strHomeFindStarDesignerList = @"/v2/app/store/findStarDesignerList";
/** 获取精选图详情 */
NSString * const strHomeGetCulling = @"/v2/app/culling/getCulling";
/** 收藏精选图 */
NSString * const strHomeAddCulling = @"/v2/app/culling/addCulling";
/** 批量取消收藏 */
NSString * const strHomeDeleteFavoriteCulling = @"/v2/app/showHomePage/deleteFavoriteCulling";
/** 查找所有门店*/
NSString * const strHomeFindStoreList = @"/v2/app/store/findStoreList";
/** 查询门店详细信息*/
NSString * const strHomeGetStoreDetail = @"/v2/app/store/getStoreDetail";
/** 查询门店详情中的设计师列表*/
NSString * const strHomeGetStoreDesignerList = @"/v2/app/store/getStoreDesignerList";
/** 获取当前用户所有预约信息*/
NSString * const strHomeFindAppointmentList = @"/v2/app/appointment/findAppointmentList";
/** 获取消息列表*/
NSString * const strHomeFindMsgList = @"/v2/app/message/findMsgList";
/** 取消预约订单*/
NSString * const strHomeCancelAppointment = @"/v3/app/order/cancelAppointment";
/** 修改消息状态*/
NSString * const strHomeUpdateStatus = @"/v2/app/message//updateStatus";
/** 删除、已读所有通知(一键阅读)*/
NSString * const strHomeUpdateAllStatus = @"/v2/app/message/updateAllStatus";
/** 通过设计师ID查询设计师详情*/
NSString * const strHomeGetDesigner = @"/v2/app/designer/getDesigner";
/** 根据设计师ID查询评论*/
NSString * const strHomeGetDesignerCommentList = @"/v2/app/designer/getDesignerCommentList";
/** 根据设计师id查询所制作的作品*/
NSString * const strHomeGetDesignerProductionList = @"/v2/app/designer/getDesignerProductionList";
/** 查询设计师可预约的时间*/
NSString * const strHomeFindDesignerAppointmentTime = @"/v2/app/appointment/findDesignerAppointmentTime";
/** 收藏/取消 【设计师】*/
NSString * const strHomeLikeOrabolishDesigner = @"/v2/app/designer/likeOrabolishDesigner";
/** 查询定制分类*/
NSString * const strHomeGetCustomClassify = @"/v2/app/culling/getCustomClassify";
/** 提交预约*/
NSString * const strHomeCommitAppointment = @"/v3/app/order/commitAppointment";
/** 支付预约*/
NSString * const strHomePayAppointment = @"/v3/app/order/payAppointment";
/** 查询用户在所有门店的身体数据*/
NSString * const strUserCenterFindMyAllBodyDataList = @"/v2/app/customer/findMyAllBodyDataList";
/** 查询用户某个门店的身体数据*/
NSString * const strUserCenterFindMyBodyDataList = @"/v2/app/customer/findMyBodyDataList";
/** 推荐设计师列表*/
NSString * const strHomeFindRecommendDesignerList = @"/v2/app/designer/findRecommendDesignerList";
/** 查询定金*/
NSString * const strHomeGetEarnest = @"/v2/app/earnest/getEarnest";
/** 删除预约订单 */
NSString * const strHomeDeleteAppointment = @"/v3/app/order/deleteOrder";
/** 查询参考图片 */
NSString * const strHomeFindBodyPic = @"/v2/app/customer/findBodyPic";
/** 添加参考图片 */
NSString * const strHomeAddBodyPicture = @"/v2/app/customer/addBodyPicture";
/** 删除参考图片 */
NSString * const strHomeDeleteBodyPicture = @"/v2/app/customer/deleteBodyPicture";
/** 查看定制进度 */
NSString * const strHomeFindProcessNodeDetail = @"/v3/app/order/findProcessNodeDetail";
/** 查看设计师预约状态*/
NSString * const strHomeCheckDesignerAppointStatus = @"/v2/app/designer/checkDesignerAppointStatus";
/** 获取设计师列表*/
NSString * const strHomeFindDesignerList =@"/v3/app/designer/findDesignerList";

/******************* 设置 ***************************/

/** 获取用户的推送设置 */
NSString * const findSettings = @"/v2/app/userSettings/findSettings";
/** 更新用户推送设置 */
NSString * const updateSettings = @"/v2/app/userSettings/updateSettings";
/** 检查app版本更新 */
NSString * const checkAppUpdate = @"/v2/app/version/checkUpdate";
/** 检查app版本更新 */
NSString * const updatePassword = @"/v2/app/customer/updatePassword";

/******************* TailorX2.0.5 新增接口 ***************************/

/** 查询有门店的列表城市 */
NSString * const findStoreCity = @"/v2/app/store/findStoreCity";
/** 评论未通过详情 */
NSString * const findCommentNoPass = @"/v2/app/message/findCommentNoPass";
/** 排号交易成功 */
NSString * const findRankNumData = @"/v2/app/message/findRankNumData";
/** 预约设计师详情 */
NSString * const findAppointmentData = @"/v2/app/appointment/findAppointmentData";
/** 根据订单编号获取排号id */
NSString * const findRankNumId = @"/v2/app/rankNum/findRankNumId";

/******************* TailorX3.2.0 新增接口 ***************************/

/** 获取发现筛选分类 */
NSString * const strDiscoverFindAllTags = @"/v3/app/tag/findAllTags";
/** 获取发现所有数据 */
NSString * const strDiscoverFindPictureList = @"/v3/app/picture/findPictureList";
/** 获取首页资讯合集 */
NSString * const strHomeGetTagGroups = @"/v3/app/order/getTagGroups";
/** 获取发现详情 */
NSString * const strDiscoverFindPictureDetail = @"/v3/app/picture/findPictureDetail";
/** 获取时尚外套 */
NSString * const strInformationGroupInfo = @"/v3/app/information/informationGroupInfo";
/** 分享发现图片 */
NSString * const strDiscoverSharePicture = @"/v3/app/picture/sharePicture";
/** 推荐图片 */
NSString * const strDiscoverGetRecommendPictureList = @"/v3/app/picture/getRecommendPictureList";
/** 分享资讯图片 */
NSString * const strShareInformation = @"/v3/app/information/shareInformation";

/******************* TailorX3.2.1 新增接口 ***************************/

/** 获取设计师信息 */
NSString * const strGetOrderDesignerInfo = @"/v3/app/designer/getOrderDesignerInfo";

/******************* TailorX3.3.0 新增接口 ***************************/

/** 发现作品  pictureId */
NSString * const strFindRecommendDesignerWorkList = @"/v3/app/designerWork/findRecommendDesignerWorkList";

/** 作品详情 workId */
NSString * const strGetDesignerWorkDetail = @"/v3/app/designerWork/getDesignerWorkDetail";

/******************* TailorX3.3.5 新增接口 ***************************/
/** 搜索结果 */
NSString * const strSearchResult = @"/v3/app/picture/search";


@end

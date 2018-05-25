//
//  TXAppointmentDetailModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXAppointmentDetailModel : NSObject
/** 预约到店时间 */
@property (nonatomic, strong) NSString *appointmentTime;
/** 取消原因（0：系统取消，1：客户取消，2：设计师取消）*/
@property (nonatomic, assign) NSInteger cancelType;
/** 订单创建时间*/
@property (nonatomic, assign) NSInteger createDate;
/** 创建时间（字符串）*/
@property (nonatomic, strong) NSString *createDateStr;
/** 客户ID*/
@property (nonatomic, assign) NSInteger customerId;
/** 客户电话*/
@property (nonatomic, strong) NSString *customerPhone;
/** 是否删除*/
@property (nonatomic, assign) NSInteger delFlag;
/** 配送方式（1上门自提 2物流配送）*/
@property (nonatomic, strong) NSString *delivery;
/** 物流方式名称*/
@property (nonatomic, strong) NSString *deliveryName;
/** 支付留言*/
@property (nonatomic, strong) NSString *deliveryRemark;
/** 预约订金*/
@property (nonatomic, assign) CGFloat deposit;
/** 定金支付方式：1支付宝 2有糖账户余额*/
@property (nonatomic, strong) NSString *depositePayMethod;
/** 用户描述*/
@property (nonatomic, strong) NSString *desc;
/** 设计师ID*/
@property (nonatomic, assign) NSInteger designerId;
/** 设计师头像*/
@property (nonatomic, strong) NSString *designerPhoto;
/** 一级分类名称*/
@property (nonatomic, strong) NSString *firstCategoryName;
/** 订单ID*/
@property (nonatomic, strong) NSString *ID;
/** 资讯编号*/
@property (nonatomic, strong) NSString *informationNo;
/** 是否胚样试衣（0：否，1：是）*/
@property (nonatomic, strong) NSString *isFitting;
/** 是否隐藏*/
@property (nonatomic, strong) NSString *isHide;
/** 是否退款*/
@property (nonatomic, strong) NSString *isRefund;
/** 面料*/
@property (nonatomic, strong) NSString *lining;
/** 面料图片地址*/
@property (nonatomic, strong) NSString *liningPic;
/** 订单名称*/
@property (nonatomic, strong) NSString *orderName;
/** 订单编号*/
@property (nonatomic, strong) NSString *orderNo;
/** 订单数量*/
@property (nonatomic, strong) NSString *orderNum;
/** 订单发货地址*/
@property (nonatomic, strong) NSString *orderShipAddress;
/** 订单支付方式：1支付宝 2有糖账户余额*/
@property (nonatomic, strong) NSString *payMethod;
/** 支付时间*/
@property (nonatomic, strong) NSString *payTime;
/** 用户上传图片*/
@property (nonatomic, strong) NSString *pictures;
/** 二级分类名称*/
@property (nonatomic, strong) NSString *secondCategoryName;
/** 订单状态*/
@property (nonatomic, assign) NSInteger status;
/** 门店地址*/
@property (nonatomic, strong) NSString *storeAddress;
/** 所属门店ID*/
@property (nonatomic, assign) NSInteger storeId;
/** 门店名称*/
@property (nonatomic, strong) NSString *storeName;
/** 门店电话*/
@property (nonatomic, strong) NSString *storePhone;
/** 当前环节*/
@property (nonatomic, assign) NSInteger tacheId;
/** 工单编号*/
@property (nonatomic, strong) NSString *taskOrderNo;
/** 三级类别名称*/
@property (nonatomic, strong) NSString *thirdCategoryName;
/** 订单金额*/
@property (nonatomic, strong) NSString *totalAmount;
/** 更新时间*/
@property (nonatomic, assign) NSInteger updateDate;
/** 设计师名字*/
@property (nonatomic, strong) NSString *designerName;
/** 取消原因*/
@property (nonatomic, strong) NSString *designerCancelReason;
/** 标签数组 */
@property (nonatomic, strong) NSArray *tagStrs;

/**
 * 合并用户标签
 */
- (NSString *)combineUsertags;

@end

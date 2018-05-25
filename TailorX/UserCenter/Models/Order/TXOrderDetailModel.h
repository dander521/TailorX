//
//  TXOrderDetail.h
//  TailorX
//
//  Created by RogerChen on 2017/4/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXOrderModel.h"
#import "TXAddressModel.h"

@interface TXOrderDetailModel : NSObject

/** 收货地址 */
@property (nonatomic, strong) NSString *storeAddress;
/** 品类 */
@property (nonatomic, strong) NSString *categoryName;
/** 下单时间 */
@property (nonatomic, assign) NSInteger createDate;
/** 剩余时间 */
@property (nonatomic, assign) NSInteger remainTime;
/** 下单时间  */
@property (nonatomic, strong) NSString *createDateStr;
/** 客户名字 */
@property (nonatomic, strong) NSString *customerName;
/** 配送方式(1:到店自取 2:快递运送) */
@property (nonatomic, assign) NSInteger delivery;
/** 物流详情 */
@property (nonatomic, strong) NSString *expressInfo;
/** 物流编号 */
@property (nonatomic, strong) NSString *expressNo;
/** 物流公司名字 */
@property (nonatomic, strong) NSString *expressName;
/** 订单名称 */
@property (nonatomic, strong) NSString *orderName;
/** 订单编号 */
@property (nonatomic, strong) NSString *orderNo;
/** 支付方式(1:支付宝 2:余额)  */
@property (nonatomic, assign) NSInteger payMethod;
/** 订单图片 */
@property (nonatomic, strong) NSString *styleUrl;
/** 门店名  */
@property (nonatomic, strong) NSString *storeName;
/** 门店id */
@property (nonatomic, strong) NSString *storeId;
/** 门店电话 */
@property (nonatomic, strong) NSString *storePhone;
/** 客户电话-数据库字段修改 后期确定无 删除 */
@property (nonatomic, strong) NSString *telephone;
/** 客户电话 */
@property (nonatomic, strong) NSString *customerPhone;
/** 总金额 */
@property (nonatomic, strong) NSString * totalAmount;
/** 订单总价 */
@property (nonatomic, strong) NSString *totalListPrice; //(原总价)
/** 订单总价 */
@property (nonatomic, strong) NSString *discount;//（折扣）
/** 总金额 */
@property (nonatomic, strong) NSString * discountPrice;
/** 定金 */
@property (nonatomic, strong) NSString *deposit;
/** 排位编号 */
@property (nonatomic, strong) NSString *sortNo;
/** 设计师Id */
@property (nonatomic, strong) NSString *designerId;
/** 设计师Id */
@property (nonatomic, strong) NSString *designerName;
/** 设计师头像 */
@property (nonatomic, strong) NSString *designerPhoto;
/** 一级分类 */
@property (nonatomic, strong) NSString *firstCategoryName;
/** 二级分类 */
@property (nonatomic, strong) NSString *secondCategoryName;
/** 三级分类 */
@property (nonatomic, strong) NSString *thirdCategoryName;
/** 生产状态 */
@property (nonatomic, strong) NSString *factoryTacheName;
/** 地址对象 */
@property (nonatomic, strong) TXAddressModel *deliveryAddress;
/** 标签数组 */
@property (nonatomic, strong) NSArray *tagStrs;
/**
 * 将详情模型转化为订单模型
 */
- (TXOrderModel *)convertOrderDetailModelToOrderModel;
/**
 * 合并用户订单分类
 */
- (NSString *)combineOrderCategory;
/**
 * 合并用户地址
 */
- (NSString *)combineUserAddress;
/**
 * 合并用户标签
 */
- (NSString *)combineUsertags;

@end

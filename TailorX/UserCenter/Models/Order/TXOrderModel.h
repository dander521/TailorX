//
//  TXOrder.h
//  TailorX
//
//  Created by RogerChen on 24/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXOrderModel : NSObject

/** 门店id  */
@property (nonatomic, assign) NSString *orderId;
/** 描述 */
@property (nonatomic, strong) NSString *orderName;
/** 分类 */
@property (nonatomic, strong) NSString *categoryName;
/** 订单编号 */
@property (nonatomic, strong) NSString *orderNo;
/** 排位编号 */
@property (nonatomic, strong) NSString *orderRankNo;
/** 图片url */
@property (nonatomic, strong) NSString *styleUrl;
/** 订单分类 */
@property (nonatomic, strong) NSString *status; // status:订单状态： 01待付款 02排队中 03生产中 04待收货 05待评价 06已评价 07已退款 08已失效 09预约成功 10取消预约
/** 订单总价 */
@property (nonatomic, strong) NSString *totalAmount; // （订单实际支付金额）
/** 订单总价 */
@property (nonatomic, strong) NSString *totalListPrice; //(原总价)
/** 订单总价 */
@property (nonatomic, strong) NSString *discount;//（折扣）
/** 订单总价 */
@property (nonatomic, strong) NSString *discountPrice;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 配送类型：1到店自取 2货到付款  */
@property (nonatomic, assign) NSInteger delivery;
/** 门店id  */
@property (nonatomic, assign) NSInteger storeId;
/** 定金  */
@property (nonatomic, strong) NSString *deposit;
/** 门店名称 */
@property (nonatomic, strong) NSString *storeName;
/** 设计师 */
@property (nonatomic, strong) NSString *designerName;
/** 门店电话 */
@property (nonatomic, strong) NSString *storePhone;
/** 一级分类 */
@property (nonatomic, strong) NSString *firstCategoryName;
/** 二级分类 */
@property (nonatomic, strong) NSString *secondCategoryName;
/** 三级分类 */
@property (nonatomic, strong) NSString *thirdCategoryName;
/** <#description#> */
@property (nonatomic, strong) NSArray *tagStrs;
@end


@interface TXOrderHeaderModel : NSObject

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 门店id  */
@property (nonatomic, assign) NSInteger storeId;
/** 门店名称 */
@property (nonatomic, strong) NSString *storeName;
/** order 数组 */
@property (nonatomic, strong) NSMutableArray *order;

@end

@interface TXAllOrderModel : NSObject

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 全选数据源 */
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface TXAllServerOrdersModel : NSObject

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 全选数据源 */
@property (nonatomic, strong) NSMutableArray *data;

/**
 处理数据源
 */
- (void)addMoreDataWithServerOrder:(TXAllServerOrdersModel *)serverOrder allOrderModel:(TXAllOrderModel *)allOrdersModel;

@end

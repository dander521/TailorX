//
//  TXOrderTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXOrderModel.h"

/**
 订单类别枚举  01待付款 02排队中 03生产中 04待收货 05待评价 06已评价 07已退款 08已失效 09预约成功 10取消预约
 */
typedef NS_ENUM(NSUInteger, TXOrderStatus) {
    TXOrderStatusForPay = 1, /**< 待付款 */
    TXOrderStatusInQueue, /**< 排队中 */
    TXOrderStatusInProduct, /**< 生产中 */
    TXOrderStatusForReceiveWaitDeliver, /**< 待收货 等待发货 */
    TXOrderStatusForComment, /**< 待评价 */
    TXOrderStatusCommented, /**< 已评价 */
    TXOrderStatusInvalidHasDeposit, /**< 订单失效退还定金 */
    TXOrderStatusInvalidNoDeposit, /**< 订单失效无定金 */
    TXOrderStatusAppointmentSuccess, /**< 订单预约成功 */
    TXOrderStatusAppointmentCancel, /**< 订单取消预约 */
    TXOrderStatusForReceiveGetBySelf, /**< 待收货 到店自取 */
    TXOrderStatusForReceiveDelivered, /**< 待收货 已发货 */
    TXOrderStatusContactStore /**< 联系门店 */
};

/**
 服务器参数类别枚举
 */
typedef NS_ENUM(NSUInteger, TXOrderParamsType) {
    TXOrderParamsTypeAll, /**< 全部 */
    TXOrderParamsTypeForPay, /**< 待付款 */
    TXOrderParamsTypeInQueue, /**< 排队中 */
    TXOrderParamsTypeForReceive, /**< 待收货 */
    TXOrderParamsTypeForComment /**< 待评论 */
};

/**
 订单支付方式
 */
typedef NS_ENUM(NSUInteger, TXOrderPayMethodType) {
    TXOrderPayMethodTypeAliPay = 1, /**< 支付宝 */
    TXOrderPayMethodTypeCash = 2 /**< 余额 */
};

/**
 订单运送方式
 */
typedef NS_ENUM(NSUInteger, TXOrderDeliveryType) {
    TXOrderDeliveryTypeGetSelf = 1, /**< 到店自取 */
    TXOrderDeliveryTypeDelivery = 2 /**< 快递运送 */
};

/**
 支付订单数
 */
typedef NS_ENUM(NSUInteger, TXOrderPayAmount) {
    TXOrderPayAmountSingle = 1, /**< 单个订单 */
    TXOrderPayAmountQuantity = 2 /**< 合并支付 */
};

@protocol TXOrderTableViewCellDelegate <NSObject>
@optional

/**
 *  待收货状态点击 查看物流 按钮
 */
- (void)touchLogisticButtonWithOrder:(TXOrderModel *)order;

/**
 *  点击cell 按钮
 */
- (void)touchProcessButtonWithOrder:(TXOrderModel *)order;

/**
 *  点击cell 按钮
 */
- (void)touchActionButtonWithOrder:(TXOrderModel *)order;

/**
 *  点击选择按钮
 */
- (void)touchOrderTableViewCellButtonWithSelected:(BOOL)isSelected orderModel:(TXOrderModel *)orderModel;

@end

@interface TXOrderTableViewCell : TXSeperateLineCell
/** 选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
/** 设计衣服图片 */
@property (weak, nonatomic) IBOutlet UIImageView *dressImageView;
/** 衣服描述 */
@property (weak, nonatomic) IBOutlet UILabel *dressDescriptionLabel;
/** 衣服分类 */
@property (weak, nonatomic) IBOutlet UILabel *dressCategoryLabel;
/** 衣服价格 */
@property (weak, nonatomic) IBOutlet UILabel *dressPriceLabel;
/** 衣服排队号 */
@property (weak, nonatomic) IBOutlet UILabel *dressQueueNoLabel;
/** 动作按钮 */
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
/** cell 空间布局样式 */
@property (nonatomic, assign) TXOrderStatus cellType;
/** 代理 */
@property (nonatomic, assign) id <TXOrderTableViewCellDelegate> delegate;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 物流按钮 */
@property (weak, nonatomic) IBOutlet UIButton *logisticButton;
/** 进度按钮 */
@property (weak, nonatomic) IBOutlet UIButton *processButton;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  配置cell
 */
- (void)configOrderCellWithOrderModel:(TXOrderModel *)orderModel isAllOrderCell:(BOOL)isAllOrderCell;

@end

//
//  TXPayBottomView.h
//  TailorX
//
//  Created by RogerChen on 21/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TXPayViewType) {
    TXPayViewTypeAll = 0,
    TXPayViewTypeSingle
};

typedef NS_ENUM(NSUInteger, TXPayViewAppointmentType) {
    TXPayViewAppointmentTypeHide = 0, /*< 隐藏定金描述按钮 */
    TXPayViewAppointmentTypeShow /*< 显示定金描述按钮 */
};

@protocol TXPayBottomViewDelegate <NSObject>
@optional

/**
 *  点击支付订单按钮
 */
- (void)touchPayAccountButton;

/**
 *  点击全选按钮
 */
- (void)touchButtonWithStatusAllSelected:(BOOL)isSelected;

/**
 *  点击预约描述
 */
- (void)touchAppointmentDescriptionButton;

@end

@interface TXPayBottomView : UIView

/** 全选button */
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
/** 全选label */
@property (weak, nonatomic) IBOutlet UILabel *allSelectLabel;
/** 支付描述 */
@property (weak, nonatomic) IBOutlet UILabel *payDescriptionLabel;
/** 代理 */
@property (nonatomic, assign) id <TXPayBottomViewDelegate> delegate;
/** view 支付方式 */
@property (nonatomic, assign) TXPayViewType payType;
/** view 支付定金方式 */
@property (nonatomic, assign) TXPayViewAppointmentType appointmentType;
/** 是否全选 */
@property (nonatomic, assign) BOOL isAllSelected;
/** 支付金额 */
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
/** 支付按钮 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

/**
 *  实例方法
 */
- (void)configBottomViewWithSelected:(BOOL)isSelected;

@end

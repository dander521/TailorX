//
//  TXMultiPayView.h
//  TailorX
//
//  Created by RogerChen on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 订单支付方式
 */
typedef NS_ENUM(NSUInteger, TXMultiPayViewType) {
    TXMultiPayViewTypeAli = 1, /**< 支付宝 */
    TXMultiPayViewTypeCash, /**< 余额 */
    TXMultiPayViewTypeWeChat /**< 微信 */
};

@protocol TXMultiPayViewDelegate <NSObject>


@optional
/**
 确认付款
 */
- (void)touchPayAccountCommitButtonWithPayType:(TXMultiPayViewType)payType;

/**
 * 取消付款
 */
- (void)touchPayAccountCancelButton;

@end

@interface TXMultiPayView : UIView

/** 余额 */
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
/** 支付宝 */
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatPayBtn;

/** 金额label */
@property (weak, nonatomic) IBOutlet UILabel *totalAccountLabel;
/** 支付金额 */
@property (nonatomic, strong) NSString *totalAccount;
/** 可用余额*/
@property (nonatomic, assign) CGFloat availableBalance;
/** 可用余额*/
@property (nonatomic, assign) TXMultiPayViewType payType;
/** 顶部背景view */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 是否选中余额 */
@property (weak, nonatomic) IBOutlet ThemeButton *submitButton;

/** 代理 */
@property (nonatomic, assign) id <TXMultiPayViewDelegate> delegate;

+ (instancetype)shareInstanceManager;

- (void)show;

- (void)hide;

@end

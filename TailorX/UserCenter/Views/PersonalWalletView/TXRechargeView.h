//
//  TXRechargeView.h
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXRechargeView;
@protocol TXRechargeViewDelegate <NSObject>
@optional
- (void)rechargeViewSureBtnClick:(UIButton *)button;

@end


@interface TXRechargeView : UIView

+ (instancetype)instanse;

@property (nonatomic, weak) id<TXRechargeViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *rechargeMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

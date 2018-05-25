//
//  TXWalletView.h
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXWalletView;
@protocol TXWalletViewDelegate <NSObject>

@optional
- (void)rechargeBtnClick:(UIButton *)button;
- (void)withdrawBtnClick:(UIButton *)button;
- (void)erningBtnClick:(UIButton *)button;

@end

@interface TXWalletView : UIView

+ (instancetype)instanse;

@property (nonatomic, weak) id<TXWalletViewDelegate> delegate;

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *erning;

@end

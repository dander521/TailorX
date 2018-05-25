//
//  TXMultiPayView.m
//  TailorX
//
//  Created by RogerChen on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXMultiPayView.h"

@interface TXMultiPayView ()<UIGestureRecognizerDelegate>

// (可用余额： ￥980)
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;

@end

@implementation TXMultiPayView

+ (instancetype)shareInstanceManager {
    TXMultiPayView *instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    instance.totalAccountLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    instance.submitButton.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    instance.payType = TXMultiPayViewTypeAli;
    [instance.aliPayButton setImage:[[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
    [instance.cashButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    [instance.weChatPayBtn setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    return instance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //代码
        self.frame = CGRectMake(0, 322, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        self.payType = TXMultiPayViewTypeAli;
        [self.aliPayButton setImage:[[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
        [self.cashButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
        [self.weChatPayBtn setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    }
    
    return self;
}

// 点击背景
- (void)tapGestrueMethod:(UITapGestureRecognizer *)gesture {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchPayAccountCancelButton)]) {
        [self.delegate touchPayAccountCancelButton];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag == 100) {
        return false;
    }
    return true;
}


- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    // 浮现
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        CGPoint point = self.center;
        point.y -= 322;
        self.center = point;
    } completion:^(BOOL finished) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
    }];
    [view addSubview:self];
}

- (void)hide {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint point = self.center;
        self.alpha = 0;
        point.y += 322;
        self.center = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setTotalAccount:(NSString *)totalAccount {
    _totalAccount = totalAccount;
    self.totalAccountLabel.text = [NSString stringWithFormat:@"¥ %.2f", [totalAccount floatValue]];
}

- (void)setAvailableBalance:(CGFloat)availableBalance {
    _availableBalance = availableBalance;
    self.availableBalanceLabel.text = [NSString stringWithFormat:@"(可用余额：￥%.2f)",_availableBalance];
}

- (IBAction)touchCancelButton:(id)sender {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchPayAccountCancelButton)]) {
        [self.delegate touchPayAccountCancelButton];
    }
}

- (IBAction)selectCashButton:(id)sender {
    self.payType = TXMultiPayViewTypeCash;
    [self.aliPayButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    [self.cashButton setImage:[UIImage imageNamed:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
    [self.weChatPayBtn setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
}

- (IBAction)selectAliPayButton:(id)sender {
    self.payType = TXMultiPayViewTypeAli;
    [self.cashButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    [self.aliPayButton setImage:[UIImage imageNamed:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
    [self.weChatPayBtn setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
}

- (IBAction)selectWXPayBtn:(id)sender {
    self.payType = TXMultiPayViewTypeWeChat;
    [self.aliPayButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    [self.cashButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    [self.weChatPayBtn setImage:[UIImage imageNamed:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
}


- (IBAction)touchCommitPayButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchPayAccountCommitButtonWithPayType:)]) {
        [self.delegate touchPayAccountCommitButtonWithPayType:self.payType];
    }
    [self hide];
}

@end

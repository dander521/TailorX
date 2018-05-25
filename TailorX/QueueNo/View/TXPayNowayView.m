//
//  TXPayNowayView.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPayNowayView.h"

@interface TXPayNowayView ()

@end

@implementation TXPayNowayView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *img = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"];
    
    [_capitalImgBtn setImage:img forState:UIControlStateSelected];
    [_alipayImgBtn setImage:img forState:UIControlStateSelected];
    
    _agreeImgBtn.selected = YES;
    [_agreeImgBtn setImage:img forState:UIControlStateSelected];

}

+ (instancetype)instanse {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

/**
 * 支付方式选择
 */
- (IBAction)payWay:(UIButton *)sender {
    if (sender == self.capitalBtn) {
        self.capitalBtn.selected = YES;
        self.alipayBtn.selected = !self.capitalBtn;
        sender.tag = 0;
    }else if (sender == self.alipayBtn)  {
        self.alipayBtn.selected = YES;
        self.capitalBtn.selected = !self.alipayBtn.selected;
        sender.tag = 1;
    }
    self.capitalImgBtn.selected = self.capitalBtn.selected;
    self.alipayImgBtn.selected = self.alipayBtn.selected;
    self.payType = sender.tag;
}

/**
 * 同意
 */
- (IBAction)agreeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _agreeImgBtn.selected = sender.selected;
}

/**
 * 用户协议
 */
- (IBAction)protocolBtnClick:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationProtocol object:nil];

}

@end

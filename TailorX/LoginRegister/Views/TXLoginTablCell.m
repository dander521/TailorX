//
//  TXLoginTablCell.m
//  TailorX
//
//  Created by Qian Shen on 31/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXLoginTablCell.h"

@interface TXLoginTablCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end

@implementation TXLoginTablCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.loginBtn.backgroundColor = [self loadThemeColorWithName:@"theme_Btn_bg_color"];
    
    self.passwordBgView.backgroundColor = [UIColor whiteColor];
    self.phoneNumBgView.backgroundColor = [UIColor whiteColor];
    
    [self.phoneNumBgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumBgView.mas_left);
        make.right.mas_equalTo(self.phoneNumBgView.mas_right).offset(-30);
        make.top.mas_equalTo(self.phoneNumBgView.mas_top);
        make.bottom.mas_equalTo(self.phoneNumBgView.mas_bottom);
    }];
    
    [self.passwordBgView addSubview:self.passTextField];
    [self.passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordBgView.mas_left);
        make.right.mas_equalTo(self.passwordBgView.mas_right).offset(-30);
        make.top.mas_equalTo(self.passwordBgView.mas_top);
        make.bottom.mas_equalTo(self.passwordBgView.mas_bottom);
    }];
    
    CGFloat height = 0;
    // plus
    if(SCREEN_HEIGHT > 700) {
        height = 281;
    }
    // s
    else if (SCREEN_HEIGHT > 650) {
        height = 268;
    }
    // 5
    else if (SCREEN_HEIGHT > 500){
        height = 255;
        self.topLayout.constant = 10;
    }
    // 4
    else {
        height = 100;
    }
    self.bottomLayout.constant = height;
    [self.contentView layoutIfNeeded];
    
}

#pragma mark - getters

- (TXTextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[TXTextField alloc]init];
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneTextField;
}

- (TXTextField *)passTextField {
    if (!_passTextField) {
        _passTextField = [[TXTextField alloc]init];
        _passTextField.placeholder = @"请输入密码";
        _passTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passTextField.textField.secureTextEntry = YES;
    }
    return _passTextField;
}

@end

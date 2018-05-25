//
//  TXRegisterTabCell.m
//  TailorX
//
//  Created by Qian Shen on 28/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXRegisterTabCell.h"

@interface TXRegisterTabCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

@end

@implementation TXRegisterTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.phoneNumBgView.backgroundColor = [UIColor whiteColor];
    self.yzmBgView.backgroundColor = [UIColor whiteColor];
    self.inputPassBgView.backgroundColor = [UIColor whiteColor];
    self.surePassBgView.backgroundColor = [UIColor whiteColor];
    
    [self.phoneNumBgView addSubview:self.phoneTextFiled];
    [self.phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumBgView.mas_left);
        make.right.mas_equalTo(self.phoneNumBgView.mas_right).offset(-30);
        make.top.mas_equalTo(self.phoneNumBgView.mas_top);
        make.bottom.mas_equalTo(self.phoneNumBgView.mas_bottom);
    }];
    
    [self.yzmBgView addSubview:self.yzmTextField];
    [self.yzmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yzmBgView.mas_left);
        make.right.mas_equalTo(self.yzmBgView.mas_right).offset(-80);
        make.top.mas_equalTo(self.yzmBgView.mas_top);
        make.bottom.mas_equalTo(self.yzmBgView.mas_bottom);
    }];
    
    [self.inputPassBgView addSubview:self.inputPassTextField];
    [self.inputPassTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputPassBgView.mas_left);
        make.right.mas_equalTo(self.inputPassBgView.mas_right).offset(-30);
        make.top.mas_equalTo(self.inputPassBgView.mas_top);
        make.bottom.mas_equalTo(self.inputPassBgView.mas_bottom);
    }];
   
    [self.surePassBgView addSubview:self.surePassTextField];
    [self.surePassTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.surePassBgView.mas_left);
        make.right.mas_equalTo(self.surePassBgView.mas_right).offset(-30);
        make.top.mas_equalTo(self.surePassBgView.mas_top);
        make.bottom.mas_equalTo(self.surePassBgView.mas_bottom);
    }];
    
    CGFloat height = 0;
    // plus
    if(SCREEN_HEIGHT > 700) {
        self.topLayout.constant = 7;
        height = 281;
    }
    // s
    else if (SCREEN_HEIGHT > 650) {
        height = 100;
    }
    // 5
    else if (SCREEN_HEIGHT > 500){
        height = 25;
    }else {
        height = 10;
    }
    self.bottomLayout.constant = height;
    [self.contentView layoutIfNeeded];
}


#pragma mark - getters

- (TXTextField *)phoneTextFiled {
    if (!_phoneTextFiled) {
        _phoneTextFiled = [[TXTextField alloc]init];
        _phoneTextFiled.placeholder = @"请输入手机号";
        _phoneTextFiled.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneTextFiled;
}

- (TXTextField *)yzmTextField {
    if (!_yzmTextField) {
        _yzmTextField = [[TXTextField alloc]init];
        _yzmTextField.placeholder = @"请输入验证码";
        _yzmTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _yzmTextField;
}

- (TXTextField *)inputPassTextField {
    if (!_inputPassTextField) {
        _inputPassTextField = [[TXTextField alloc]init];
        _inputPassTextField.placeholder = @"请输入6-18位密码";
        _inputPassTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _inputPassTextField.textField.secureTextEntry = YES;
    }
    return _inputPassTextField;
}

- (TXTextField *)surePassTextField {
    if (!_surePassTextField) {
        _surePassTextField = [[TXTextField alloc]init];
        _surePassTextField.placeholder = @"确认密码";
        _surePassTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _surePassTextField.textField.secureTextEntry = YES;
    }
    return _surePassTextField;
}


@end

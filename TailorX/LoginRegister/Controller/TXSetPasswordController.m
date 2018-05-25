//
//  TXSetPasswordController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSetPasswordController.h"
#import "TXLoginController.h"
#import "TXShowWebViewController.h"
#import "TXTextField.h"

@interface TXSetPasswordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopLayout;
/** 输入密码框*/
@property (strong, nonatomic) TXTextField *inputPassTextField;
/** 确认密码框*/
@property (strong, nonatomic) TXTextField *surePassTextField;
/** 确定按钮*/
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/** 输入密码*/
@property (nonatomic, strong) NSString *inputPass;
/** 确认密码*/
@property (nonatomic, strong) NSString *surePass;
/** 输入密码的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *inputPassBgView;
/** 判断输入密码是否符合要求的标记*/
@property (weak, nonatomic) IBOutlet UIImageView *inputPassMarkImgView;
/** 输入密码框的下划线*/
@property (nonatomic, strong) UIView *inputPassLineView;
/** 确认密码的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *surePassBgView;
/** 判断输入密码是否与确认密码一致*/
@property (weak, nonatomic) IBOutlet UIImageView *surePassMarkImgView;
/** 确认密码框的下划线*/
@property (nonatomic, strong) UIView *surePassLineView;
/** 下一步按钮的底部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

@end

@implementation TXSetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeInterface];
    
    if ([[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5C"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5S"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone SE"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 6s Plus"]) {
        self.navTopLayout.constant = 0;
    } else {
        self.navTopLayout.constant = -20;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputPassTextField.textField becomeFirstResponder];
    });
    
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
        height = 263;
    }else {
        height = 100;
    }
    self.bottomLayout.constant = height;
    [self.view layoutIfNeeded];
    
    self.inputPassBgView.backgroundColor = [UIColor whiteColor];
    self.surePassBgView.backgroundColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - init 

/**
 * 初始化用户界面
 */
- (void)initializeInterface {
    
    self.sureBtn.userInteractionEnabled = NO;
    self.sureBtn.alpha = 0.7;
    self.sureBtn.backgroundColor = [self.view loadThemeColorWithName:@"theme_Btn_bg_color"];
    
    [self.inputPassBgView addSubview:self.inputPassTextField];
    [self.inputPassTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputPassBgView.mas_left);
        make.right.mas_equalTo(self.inputPassBgView.mas_right).offset(-30);
        make.bottom.mas_equalTo(self.inputPassBgView.mas_bottom);
        make.top.mas_equalTo(self.inputPassBgView.mas_top);
    }];
    
    [self.inputPassBgView addSubview:self.inputPassLineView];
    [self.inputPassLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputPassBgView.mas_left);
        make.right.mas_equalTo(self.inputPassBgView.mas_right);
        make.bottom.mas_equalTo(self.inputPassBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.surePassBgView addSubview:self.surePassTextField];
    [self.surePassTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.surePassBgView.mas_left);
        make.right.mas_equalTo(self.surePassBgView.mas_right).offset(-30);
        make.bottom.mas_equalTo(self.surePassBgView.mas_bottom);
        make.top.mas_equalTo(self.surePassBgView.mas_top);
    }];
    
    [self.surePassBgView addSubview:self.surePassLineView];
    [self.surePassLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.surePassBgView.mas_left);
        make.right.mas_equalTo(self.surePassBgView.mas_right);
        make.bottom.mas_equalTo(self.surePassBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
}

#pragma mark - events

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 确定
 */
- (IBAction)respondsToSureBtn:(UIButton*)sender {
    [self.view endEditing:YES];
    if (![self.inputPass isEqualToString:self.surePass]) {
        [ShowMessage showMessage:@"确认密码不正确" withCenter:self.view.center];
        return;
    }
    [self findPassword];
}

#pragma mark - methods

- (void)findPassword {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [UtouuOauth updatePasswordWithNewPassword:self.surePass forgetID:self.forgetId callBack:^(id obj, NSError *error) {
        if (error) {
            [ShowMessage showMessage:error.localizedDescription withCenter:kShowMessageViewFrame];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        if ([obj[@"success"]boolValue]) {
            [ShowMessage showMessage:@"密码找回成功" withCenter:self.view.center];
            SaveUserInfo(accountA, self.phoneNum);
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[TXLoginController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }else {
            [ShowMessage showMessage:obj[@"msg"] withCenter:kShowMessageViewFrame];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.inputPassTextField.textField) {
        [self.inputPassLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.inputPassLineView.backgroundColor = RGB(122, 223, 172);
    }else if (textField == self.surePassTextField.textField) {
        [self.surePassLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.surePassLineView.backgroundColor = RGB(122, 223, 172);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.inputPassTextField.textField) {
        [self.inputPassLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.inputPassLineView.backgroundColor = RGB(193, 193, 194);
    }else if (textField == self.surePassTextField.textField) {
        [self.surePassLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.surePassLineView.backgroundColor =  RGB(193, 193, 194);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    // 输入密码
    if (textField == self.inputPassTextField.textField) {
        if ([new_text_str length] > 18) {
            textField.text = [new_text_str substringToIndex:18];
            self.inputPass = textField.text;
            return NO;
        }
        if (new_text_str.length < 6) {
            self.sureBtn.userInteractionEnabled = NO;
            self.sureBtn.alpha = 0.7;
            self.inputPassMarkImgView.hidden = YES;
            
        }else{
            if (self.surePass.length >= 6) {
                self.sureBtn.userInteractionEnabled = YES;
                self.sureBtn.alpha = 1;
            }else {
                self.sureBtn.userInteractionEnabled = NO;
                self.sureBtn.alpha = 0.7;
            }
            self.inputPassMarkImgView.hidden = true;
        }
        self.inputPass = new_text_str;
    }
    // 确认密码
    else if (textField == self.surePassTextField.textField) {
        if ([new_text_str length] > 18) {
            textField.text = [new_text_str substringToIndex:18];
            self.surePass = textField.text;
            return NO;
        }
        if (new_text_str.length < 6) {
            self.sureBtn.userInteractionEnabled = NO;
            self.sureBtn.alpha = 0.7;
            self.surePassMarkImgView.hidden = YES;
        }else{
            if (self.inputPass.length >= 6) {
                self.sureBtn.userInteractionEnabled = YES;
                self.sureBtn.alpha = 1;
            }else {
                self.sureBtn.userInteractionEnabled = NO;
                self.sureBtn.alpha = 0.7;
            }
            self.surePassMarkImgView.hidden = NO;
        }
        self.surePass = new_text_str;
    }
    return YES;
}

#pragma mark - getters

- (TXTextField *)inputPassTextField {
    if (!_inputPassTextField) {
        _inputPassTextField = [[TXTextField alloc]init];
        _inputPassTextField.placeholder = @"请输入6-18位密码";
        _inputPassTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _inputPassTextField.textField.delegate = self;
        _inputPassTextField.textField.secureTextEntry = YES;
    }
    return _inputPassTextField;
}

- (TXTextField *)surePassTextField {
    if (!_surePassTextField) {
        _surePassTextField = [[TXTextField alloc]init];
        _surePassTextField.placeholder = @"确认密码";
        _surePassTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _surePassTextField.textField.delegate = self;
        _surePassTextField.textField.secureTextEntry = YES;
    }
    return _surePassTextField;
}

- (UIView *)inputPassLineView {
    if (!_inputPassLineView) {
        _inputPassLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _inputPassLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _inputPassLineView;
}

- (UIView *)surePassLineView {
    if (!_surePassLineView) {
        _surePassLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _surePassLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _surePassLineView;
}



@end

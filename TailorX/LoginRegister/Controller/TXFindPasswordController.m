//
//  TXFindPasswordController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFindPasswordController.h"
#import "TXSetPasswordController.h"
#import "TXKVPO.h"
#import "TXCountDownTime.h"
#import "TXTextField.h"

@interface TXFindPasswordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopLayout;
/** 手机号输入*/
@property (strong, nonatomic) TXTextField *phoneTextField;
/** 短信验证码输入*/
@property (strong, nonatomic) TXTextField *yzmTextField;
/** 下一步按钮*/
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
/** 获取验证码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *getYzmBtn;
/** 手机号*/
@property (nonatomic, strong) NSString *phoneNum;
/** 短信验证码*/
@property (nonatomic, strong) NSString *messageAuthenticationCode;
/** 手机号输入框的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *phoneNumBgView;
/** 手机号输入框的下划线*/
@property (nonatomic, strong) UIView *phoneUnderlineView;
/** 判断手机号是否正确的标记*/
@property (weak, nonatomic) IBOutlet UIImageView *phoneNumMarkImgView;
/** 校验手机号是否正确*/
@property (nonatomic, assign) BOOL isPhoneNum;
/** 验证码输入框的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *yzmBgView;
/** 验证码输入框的下划线*/
@property (nonatomic, strong) UIView *yzmUnderlineView;
/** 下一步按钮的底部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;



@end

@implementation TXFindPasswordController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5C"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5S"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone SE"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 6s Plus"]) {
        self.navTopLayout.constant = 0;
    } else {
        self.navTopLayout.constant = -20;
    }
    
    self.nextBtn.alpha = 0.7;
    self.nextBtn.backgroundColor = [self.view loadThemeColorWithName:@"theme_Btn_bg_color"];
    self.phoneTextField.textField.text = GetUserInfo.accountA;
    self.phoneNum = GetUserInfo.accountA;
    
    self.phoneNumBgView.backgroundColor = [UIColor whiteColor];
    self.yzmBgView.backgroundColor = [UIColor whiteColor];
    
    self.isPhoneNum = ![NSString isTextEmpty:self.phoneNum];
    
    [self initializeInterface];
    
    if (self.isPhoneNum) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.phoneTextField changeFrameOfPlaceholder];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.yzmTextField.textField becomeFirstResponder];
        });
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.phoneTextField.textField becomeFirstResponder];
        });
    }
    
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

- (void)initializeInterface {
    
    [self.phoneNumBgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumBgView.mas_left);
        make.right.mas_equalTo(self.phoneNumBgView.mas_right).offset(-30);
        make.bottom.mas_equalTo(self.phoneNumBgView.mas_bottom);
        make.top.mas_equalTo(self.phoneNumBgView.mas_top);
    }];
    
    [self.phoneNumBgView addSubview:self.phoneUnderlineView];
    [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumBgView.mas_left);
        make.right.mas_equalTo(self.phoneNumBgView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.phoneNumBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.yzmBgView addSubview:self.yzmTextField];
    [self.yzmTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yzmBgView.mas_left);
        make.right.mas_equalTo(self.yzmBgView.mas_right).offset(-80);
        make.bottom.mas_equalTo(self.yzmBgView.mas_bottom);
        make.top.mas_equalTo(self.yzmBgView.mas_top);
    }];
    
    [self.yzmBgView addSubview:self.yzmUnderlineView];
    [self.yzmUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yzmBgView.mas_left);
        make.right.mas_equalTo(self.yzmBgView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.yzmBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
}

#pragma mark - events

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 下一步
 */
- (IBAction)respondsToNextBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneNum]) {
        [ShowMessage showMessage:@"请输入正确的手机号码" withCenter:self.view.center];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [UtouuOauth findPasswordWithMessage:self.messageAuthenticationCode account:self.phoneNum callBack:^(id obj, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [ShowMessage showMessage:error.localizedDescription withCenter:kShowMessageViewFrame];
            return;
        }
        if ([obj[@"success"] boolValue]) {
            TXSetPasswordController *vc = [[TXSetPasswordController alloc]init];
            vc.phoneNum = self.phoneNum;
            vc.code = self.messageAuthenticationCode;
            vc.type = SettingFind;
            vc.idenKey = [obj objectForKey:@"code"];
            vc.forgetId = obj[kData][@"forget_id"];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [ShowMessage showMessage:obj[@"msg"]withCenter:kShowMessageViewFrame];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 * 获取短信验证码
 */
- (IBAction)respondsToGetYzmBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([NSString isTextEmpty:self.phoneTextField.textField.text]) {
        [ShowMessage showMessage:@"请输入手机号码" withCenter:self.view.center];
        return;
    }
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTextField.textField.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号码" withCenter:self.view.center];
        return;
    }
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:[UIColor clearColor] countColor:[UIColor clearColor] atBtn:self.getYzmBtn];
    
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.phoneNum forKey:@"username"];
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:getRegisterVcode completion:^(id responseObject, NSError *error) {
        if (error) {
            [[TXCountDownTime sharedTXCountDownTime] stopCountDownTimeAtBtn:self.getYzmBtn];
            [ShowMessage showMessage:error.description withCenter:self.view.center];
            return ;
        }
        [ShowMessage showMessage:responseObject[@"msg"] withCenter:kShowMessageViewFrame];
    } isLogin:^{
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 手机号输入
    if (textField == self.phoneTextField.textField) {
        
        [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.phoneUnderlineView.backgroundColor = RGB(122, 223, 172);
    }
    // 密码输入
    else if (textField == self.yzmTextField.textField) {
        [self.yzmUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.yzmUnderlineView.backgroundColor = RGB(122, 223, 172);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 手机号输入
    if (textField == self.phoneTextField.textField) {
        [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.phoneUnderlineView.backgroundColor = RGB(193, 193, 194);
    }
    // 密码输入
    else if (textField == self.yzmTextField.textField) {
        [self.yzmUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.yzmUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    // 手机号输入
    if (textField == self.phoneTextField.textField) {
        if ([new_text_str length] > 10) {
            textField.text = [new_text_str substringToIndex:11];
            self.phoneNum = textField.text;
            self.isPhoneNum = [NSString isPhoneNumCorrectPhoneNum:self.phoneNum];
            [self.phoneTextField.textField resignFirstResponder];
            [self.yzmTextField.textField becomeFirstResponder];
            return NO;
        }
        if (new_text_str.length == 0) {
            self.nextBtn.userInteractionEnabled = NO;
            self.nextBtn.alpha = 0.7;
        }else{
            if (![NSString isTextEmpty:self.messageAuthenticationCode]) {
                self.nextBtn.userInteractionEnabled = YES;
                self.nextBtn.alpha = 1;
            }else {
                self.nextBtn.userInteractionEnabled = NO;
                self.nextBtn.alpha = 0.7;
            }
        }
        self.isPhoneNum = NO;
        self.phoneNum = new_text_str;
    }
    // 短信验证码输入
    else if (textField == self.yzmTextField.textField) {
        if ([new_text_str length] > 6) {
            textField.text = [new_text_str substringToIndex:6];
            self.messageAuthenticationCode = textField.text;
            return NO;
        }
        if (new_text_str.length == 0) {
            self.nextBtn.userInteractionEnabled = NO;
            self.nextBtn.alpha = 0.7;
        }else{
            if (![NSString isTextEmpty:self.phoneNum]) {
                self.nextBtn.userInteractionEnabled = YES;
                self.nextBtn.alpha = 1;
            }else {
                self.nextBtn.userInteractionEnabled = NO;
                self.nextBtn.alpha = 0.7;
            }
        }
        self.messageAuthenticationCode = new_text_str;
    }
    
    return YES;
}


#pragma mark - setters

- (void)setIsPhoneNum:(BOOL)isPhoneNum {
    _isPhoneNum = isPhoneNum;
//    self.phoneNumMarkImgView.hidden = !_isPhoneNum;
}

#pragma mark - getters

- (TXTextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[TXTextField alloc]init];
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.textField.delegate = self;
    }
    return _phoneTextField;
}

- (TXTextField *)yzmTextField {
    if (!_yzmTextField) {
        _yzmTextField = [[TXTextField alloc]init];
        _yzmTextField.placeholder = @"请输入验证码";
        _yzmTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _yzmTextField.textField.delegate = self;
    }
    return _yzmTextField;
}

- (UIView *)phoneUnderlineView {
    if (!_phoneUnderlineView) {
        _phoneUnderlineView = [[UIView alloc]initWithFrame:CGRectZero];
        _phoneUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
    return _phoneUnderlineView;
}

- (UIView *)yzmUnderlineView {
    if (!_yzmUnderlineView) {
        _yzmUnderlineView = [[UIView alloc]initWithFrame:CGRectZero];
        _yzmUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
    return _yzmUnderlineView;
}

@end

//
//  TXRegisterController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXRegisterController.h"
#import "TXAnimationTool.h"
#import "TXKVPO.h"
#import "TXSetPasswordController.h"
#import "TXCountDownTime.h"
#import "TXRegisterTabCell.h"
#import "CustomIOSAlertView.h"
#import "TXRegisteredView.h"
#import "TXLoginController.h"
#import "TXTabBarController.h"
#import "AppDelegate.h"
#import "TXShowWebViewController.h"

static NSString *cellID = @"TXRegisterTabCell";

@interface TXRegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopLayout;
/** 手机号输入*/
@property (weak, nonatomic)  UITextField *phoneTextFiled;
/** 手机号输入框的下划线*/
@property (nonatomic, strong) UIView *phoneUnderlineView;
/** 短信验证码输入*/
@property (weak, nonatomic)  UITextField *yzmTextField;
/** 短信验证码输入框的下划线*/
@property (nonatomic, strong) UIView *yzmUnderlineView;
/** 下一步按钮*/
@property (weak, nonatomic)  UIButton *registerBtn;
/** 获取验证码按钮*/
@property (weak, nonatomic)  UIButton *getYzmBtn;
/** 手机号*/
@property (nonatomic, strong) NSString *phoneNum;
/** 短信验证码*/
@property (nonatomic, strong) NSString *messageAuthenticationCode;
/** 输入密码框*/
@property (weak, nonatomic)  UITextField *inputPassTextField;
/** 输入密码框的下划线*/
@property (nonatomic, strong) UIView *inputPassUnderlineView;
/** 确认密码框*/
@property (weak, nonatomic)  UITextField *surePassTextField;
/** 确认密码框的下划线*/
@property (nonatomic, strong) UIView *surePassUnderlineView;
/** 输入密码*/
@property (nonatomic, strong) NSString *inputPass;
/** 确认密码*/
@property (nonatomic, strong) NSString *surePass;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 自定义弹窗*/
@property (nonatomic, strong) CustomIOSAlertView *alertView;
/** 已注册的提示页面*/
@property (nonatomic, strong) TXRegisteredView *rView;
/** 定时器*/
@property (nonatomic, strong) NSTimer *timer;
/** 倒计时时间*/
@property (nonatomic, assign) NSInteger time;
/** 校验手机号是否正确*/
@property (nonatomic, assign) BOOL isPhoneNum;
/** 判断手机号是否正确的标记*/
@property (nonatomic, strong) UIImageView *phoneNumMarkImgView;


@end

@implementation TXRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - init

/**
 * 初始化数据源
 */

- (void)initializeDataSource {
    
    self.time = 3;
}

/**
 * 初始化用户界面
*/
- (void)initializeInterface {
    
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.rowHeight = SCREEN_HEIGHT-kTopHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(SCREEN_HEIGHT > 700) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.phoneTextFiled becomeFirstResponder];
        });
        self.tableView.scrollEnabled = NO;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextField:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXRegisterTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    self.phoneNumMarkImgView = cell.phoneNumMarkImgView;
    cell.phoneNumMarkImgView.hidden = true;
    // 请输入手机号
    self.phoneTextFiled = cell.phoneTextFiled.textField;
    self.phoneTextFiled.delegate = self;
    [cell.phoneNumBgView addSubview:self.phoneUnderlineView];
    [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.phoneNumBgView.mas_left);
        make.right.mas_equalTo(cell.phoneNumBgView.mas_right);
        make.bottom.mas_equalTo(cell.phoneNumBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    // 请输入验证码
    self.yzmTextField = cell.yzmTextField.textField;
    self.yzmTextField.delegate = self;
    [cell.yzmBgView addSubview:self.yzmUnderlineView];
    [self.yzmUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.yzmBgView.mas_left);
        make.right.mas_equalTo(cell.yzmBgView.mas_right);
        make.bottom.mas_equalTo(cell.yzmBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    // 获取验证码
    self.getYzmBtn = cell.getYzmBtn;
    [self.getYzmBtn addTarget:self action:@selector(respondsToGetYzmBtn:) forControlEvents:UIControlEventTouchUpInside];
    // 请输入密码
    self.inputPassTextField = cell.inputPassTextField.textField;
    self.inputPassTextField.delegate = self;
    [cell.inputPassBgView addSubview:self.inputPassUnderlineView];
    [self.inputPassUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.inputPassBgView.mas_left);
        make.right.mas_equalTo(cell.inputPassBgView.mas_right);
        make.bottom.mas_equalTo(cell.inputPassBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    // 确认密码
    self.surePassTextField = cell.surePassTextField.textField;
    self.surePassTextField.delegate = self;
    [cell.surePassBgView addSubview:self.surePassUnderlineView];
    [self.surePassUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.surePassBgView.mas_left);
        make.right.mas_equalTo(cell.surePassBgView.mas_right);
        make.bottom.mas_equalTo(cell.surePassBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    // 下一步按钮(确定按钮)
    self.registerBtn = cell.sureBtn;
    [self.registerBtn addTarget:self action:@selector(respondsToRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn.userInteractionEnabled = NO;
    self.registerBtn.backgroundColor = [self.view loadThemeColorWithName:@"theme_Btn_bg_color"];
    self.registerBtn.alpha = 0.7;
    [cell.agreeBtn addTarget:self action:@selector(respondsToAgreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - methods

- (void)startimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTheCountdown) userInfo:nil repeats:YES];
    }
}

-(void)stoptimer{
    [_timer invalidate];
    self.timer = nil;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 手机号输入
    if (textField == self.phoneTextFiled) {
        [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.phoneUnderlineView.backgroundColor = RGB(122, 223, 172);
    }
    // 验证码输入
    else if (textField == self.yzmTextField) {
        [self.yzmUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.yzmUnderlineView.backgroundColor = RGB(122, 223, 172);
    }
    // 输入密码
    else if (textField == self.inputPassTextField) {
        [self.inputPassUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.inputPassUnderlineView.backgroundColor = RGB(122, 223, 172);
    }
    // 确认密码输入
    else if (textField == self.surePassTextField) {
        [self.surePassUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.surePassUnderlineView.backgroundColor = RGB(122, 223, 172);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 手机号输入
    if (textField == self.phoneTextFiled) {
        [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.phoneUnderlineView.backgroundColor = RGB(193, 193, 194);
    }
    // 验证码输入
    else if (textField == self.yzmTextField) {
        [self.yzmUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.yzmUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
    // 输入密码
    else if (textField == self.inputPassTextField) {
        [self.inputPassUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.inputPassUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
    // 确认密码输入
    else if (textField == self.surePassTextField) {
        [self.surePassUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.surePassUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
}

- (void)changeTextField:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    NSString *new_text_str = textField.text;//变化后的字符串
    // 手机号输入
    if (textField == self.phoneTextFiled) {
        if ([new_text_str length] > 10) {
            textField.text = [new_text_str substringToIndex:11];
            self.phoneNum = textField.text;
        }
        if (new_text_str.length == 0) {
            self.registerBtn.userInteractionEnabled = NO;
            self.registerBtn.alpha = 0.7;
        }else{
            if (![NSString isTextEmpty:self.messageAuthenticationCode] && ![NSString isTextEmpty:self.inputPass] && ![NSString isTextEmpty:self.surePass]) {
                self.registerBtn.userInteractionEnabled = YES;
                self.registerBtn.alpha = 1;
            }else {
                self.registerBtn.userInteractionEnabled = NO;
                self.registerBtn.alpha = 0.7;
            }
        }
        self.phoneNum = new_text_str;
    }
    // 短信验证码输入
    else if (textField == self.yzmTextField) {
        if ([new_text_str length] > 6) {
            textField.text = [new_text_str substringToIndex:6];
            self.messageAuthenticationCode = textField.text;
        }
        if (new_text_str.length == 0) {
            self.registerBtn.userInteractionEnabled = NO;
            self.registerBtn.alpha = 0.7;
        }else{
            if (![NSString isTextEmpty:self.phoneNum] && ![NSString isTextEmpty:self.inputPass] && ![NSString isTextEmpty:self.surePass]) {
                self.registerBtn.userInteractionEnabled = YES;
                self.registerBtn.alpha = 1;
            }else {
                self.registerBtn.userInteractionEnabled = NO;
                self.registerBtn.alpha = 0.7;
            }
        }
        self.messageAuthenticationCode = new_text_str;
    }else if (textField == self.inputPassTextField) {
        if (new_text_str.length == 0) {
            self.registerBtn.userInteractionEnabled = NO;
            self.registerBtn.alpha = 0.7;
        }else{
            if (![NSString isTextEmpty:self.phoneNum] && ![NSString isTextEmpty:self.messageAuthenticationCode] && ![NSString isTextEmpty:self.surePass]) {
                self.registerBtn.userInteractionEnabled = YES;
                self.registerBtn.alpha = 1;
            }else {
                self.registerBtn.userInteractionEnabled = NO;
                self.registerBtn.alpha = 0.7;
            }
        }
        self.inputPass = new_text_str;
    }else if (textField == self.surePassTextField){
        if (new_text_str.length == 0) {
            self.registerBtn.userInteractionEnabled = NO;
            self.registerBtn.alpha = 0.7;
        }else{
            if (![NSString isTextEmpty:self.phoneNum] && ![NSString isTextEmpty:self.messageAuthenticationCode] && ![NSString isTextEmpty:self.inputPass]) {
                self.registerBtn.userInteractionEnabled = YES;
                self.registerBtn.alpha = 1;
            }else {
                self.registerBtn.userInteractionEnabled = NO;
                self.registerBtn.alpha = 0.7;
            }
        }
        self.surePass = new_text_str;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    // 手机号输入
    if (textField == self.phoneTextFiled) {
        if ([new_text_str length] > 10) {
            textField.text = [new_text_str substringToIndex:11];
            self.phoneNum = textField.text;
            self.isPhoneNum = [NSString isPhoneNumCorrectPhoneNum:self.phoneNum];
            [self.phoneTextFiled resignFirstResponder];
            [self.yzmTextField becomeFirstResponder];
            return NO;
        }else {
            self.isPhoneNum = NO;
        }
    }
    // 短信验证码输入
    else if (textField == self.yzmTextField) {
        if ([new_text_str length] > 6) {
            textField.text = [new_text_str substringToIndex:6];
            self.messageAuthenticationCode = textField.text;
            return NO;
        }
    }
    // 密码最大为18位
    else if (textField == self.inputPassTextField) {
        if ([new_text_str length] > 18) {
            textField.text = [new_text_str substringToIndex:18];
            self.inputPass = textField.text;
            return NO;
        }
    }
    // 确认密码最大为18位
    else if (textField == self.surePassTextField) {
        if ([new_text_str length] > 18) {
            textField.text = [new_text_str substringToIndex:18];
            self.surePass = textField.text;
            return NO;
        }
    }
    return YES;
}


#pragma mark - events


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 同意协议
 */
- (void)respondsToAgreeBtn:(UIButton*)sender {
    TXShowWebViewController *vc = [TXShowWebViewController new];
    vc.naviTitle = @"TailorX用户注册协议";
    vc.webViewUrl = @"http://cdn.tailorx.cn/ui/pc/tailorx/H5/agreement/agreement.html";
    [self.navigationController pushViewController:vc animated:true];
}

/** 
 * 下一步
 */
- (void)respondsToRegisterBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneNum]) {
        [ShowMessage showMessage:@"请输入正确的手机号码" withCenter:self.view.center];
        return;
    }
    
    if (![self.yzmTextField hasText]) {
        [ShowMessage showMessage:@"请输入验证码" withCenter:self.view.center];
        return;
    }

    if (![self.inputPassTextField hasText]) {
        [ShowMessage showMessage:@"请输入密码" withCenter:self.view.center];
        return;
    }
    
    if (self.inputPass.length < 6 || self.inputPass.length > 18) {
        [ShowMessage showMessage:@"请输入6-18位密码" withCenter:self.view.center];
        return;
    }
    
    if (![self.surePassTextField hasText]) {
        [ShowMessage showMessage:@"请输入确认密码" withCenter:self.view.center];
        return;
    }
    
    if (![self.inputPass isEqualToString:self.surePass]) {
        [ShowMessage showMessage:@"确认密码不正确" withCenter:self.view.center];
        return;
    }
    
    [[TXCountDownTime sharedTXCountDownTime] stopCountDownTimeAtBtn:self.getYzmBtn];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [UtouuOauth registWithAccount:self.phoneNum password:self.surePass message:self.messageAuthenticationCode callBack:^(id obj, NSError *error) {
        if (error) {
            [ShowMessage showMessage:error.localizedDescription withCenter:kShowMessageViewFrame];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([obj[@"success"]boolValue]) {
            SaveUserInfo(accountA, self.phoneNum);
            [ShowMessage showMessage:@"注册成功" withCenter:self.view.center];
            TXTabBarController *tab = (TXTabBarController*)[AppDelegate sharedAppDelegate].tabBarVc;
            tab.selectedIndex = 0;
        }else {
            [ShowMessage showMessage:obj[@"msg"] withCenter:kShowMessageViewFrame];
        }
    }];
}

/**
 * 获取短信验证码
 */
- (void)respondsToGetYzmBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([NSString isTextEmpty:self.phoneTextFiled.text]) {
        [ShowMessage showMessage:@"请输入手机号码" withCenter:self.view.center];
        return;
    }
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTextFiled.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号码" withCenter:self.view.center];
        return;
    }
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:[UIColor clearColor] countColor:[UIColor clearColor] atBtn:self.getYzmBtn];
    /*
    [UtouuOauth checkAccount:self.phoneNum callBack:^(id obj, NSError *error) {
        if (error) {
            [[TXCountDownTime sharedTXCountDownTime] stopCountDownTimeAtBtn:self.getYzmBtn];
            [ShowMessage showMessage:error.localizedDescription withCenter:kShowMessageViewFrame];
            return ;
        }
        if ([obj[@"success"]boolValue]) {
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
        }else {
            [self.alertView showInView:[UIApplication sharedApplication].keyWindow];
            [self startimer];
        }
    }];
     */
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

- (void)clickReturnBtn {
    [self.alertView close];
    [self stoptimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startTheCountdown {
    self.time -= 1;
    if (self.time <= 0) {
        [self clickReturnBtn];
    }else {
        self.rView.timeLabel.text = [NSString stringWithFormat:@"%zd秒",self.time];
    }
}

#pragma mark - setters

- (void)setIsPhoneNum:(BOOL)isPhoneNum {
//    _isPhoneNum = isPhoneNum;
//    self.phoneNumMarkImgView.hidden = !_isPhoneNum;
}

#pragma mark - getters

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

- (UIView *)inputPassUnderlineView {
    if (!_inputPassUnderlineView) {
        _inputPassUnderlineView = [[UIView alloc]initWithFrame:CGRectZero];
        _inputPassUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
    return _inputPassUnderlineView;
}

- (UIView *)surePassUnderlineView {
    if (!_surePassUnderlineView) {
        _surePassUnderlineView = [[UIView alloc]initWithFrame:CGRectZero];
        _surePassUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
    return _surePassUnderlineView;
}

- (CustomIOSAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[CustomIOSAlertView alloc]initWithFrame:CGRectMake(0, 0, 272, 140)];
        _alertView.center = self.view.center;
        _alertView.containerView = self.rView;
    }
    return _alertView;
}

- (TXRegisteredView *)rView {
    if (!_rView) {
        _rView = [TXRegisteredView creationRegisteredView];
        _rView.frame = CGRectMake(0, 0, 272, 140);
        [_rView.returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rView;
}

@end

//
//  TXLoginController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXLoginController.h"
#import "TXRegisterController.h"
#import "TXFindPasswordController.h"
#import "TXPersonalInfoViewController.h"
#import "UINavigationBar+Awesome.h"
#import "TXGuideLoginController.h"

#import "TXLoginTablCell.h"
#import "TXAnimationTool.h"

static NSString *cellID = @"TXLoginTablCell";

@interface TXLoginController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopLayout;
@property (nonatomic, strong) UITableView *tableView;

/** 登录登按钮*/
@property (nonatomic, strong) UIButton *loginBtn;
/** 手机号*/
@property (nonatomic, strong) NSString *phoneNum;
/** 密码*/
@property (nonatomic, strong) NSString *password;
/** 手机号输入框的下划线*/
@property (nonatomic, strong) UIView *phoneUnderlineView;
/** 密码输入框的下划线*/
@property (nonatomic, strong) UIView *passwordUnderlineView;
/** 判断手机号是否正确的标记*/
@property (weak, nonatomic) UIImageView *phoneNumMarkImgView;
/** 校验手机号是否正确*/
@property (nonatomic, assign) BOOL isPhoneNum;
@property (weak, nonatomic) IBOutlet UIView *naviView;

@end

@implementation TXLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.phoneNum = GetUserInfo.accountA;
    
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
 * 初始化用户界面
 */
- (void)initializeInterface {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - methods

- (void)customPopViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    // FIXME: 3.0.2版本修改-登录后返回一级页面
    /*
    NSInteger currenVcIndex = 0;
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i ++) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:[TXGuideLoginController class]]) {
            currenVcIndex = i;
        }
    }
    if (self.navigationController.viewControllers.count >= 1) {
        UIViewController *vc = self.navigationController.viewControllers[currenVcIndex-1];
        [self.navigationController popToViewController:vc animated:NO];
    }else {
        
    }
    */
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)addCustomer {
    // appType  手机类型 1:iOS 2:Android
    // deviceId 设备的device_id,推送消息需要
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:@"1" forKey:@"appType"];
    [dict setValue:GetUserInfo.deviceID forKey:@"deviceId"];
    // openSDK 添加的参数
    [dict setValue:GetUserInfo.accessToken forKey:@"accessToken"];
    [dict setValue:GetUserInfo.unionId forKey:@"unionId"];
    [dict setValue:GetUserInfo.openId forKey:@"openId"];
    [dict setValue:self.phoneNum forKey:@"userName"];
    
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strAddCustomer completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]){
                SaveUserInfo(st, [responseObject objectForKey:@"data"]);
                // 网络请求获取订单列表
                [self getAllDataFromServer];
            }else {
                [TXServiceUtil logout];
                [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }else{
            [TXServiceUtil logout];
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }isLogin:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - events

/**
 * 返回上级页面
 */
- (IBAction)back:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 忘记密码
 */
- (void)respondsToForgetBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.navigationController pushViewController:[TXFindPasswordController new] animated:YES];
}

- (void)respondsToRegisterBtn:(UIButton*)sender {
    [self.navigationController pushViewController:[TXRegisterController new] animated:YES];
}

/**
 * 登录
 */
- (void)respondsToLoginBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneNum]) {
        [ShowMessage showMessage:@"请输入正确的手机号码" withCenter:kShowMessageViewFrame];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [UtouuOauth loginWithAccount:self.phoneNum password:self.password callBack:^(id obj, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [ShowMessage showMessage:error.localizedDescription withCenter:kShowMessageViewFrame];
            return;
        }
        
        if ([obj[@"success"] boolValue]) {
            SaveUserInfo(accessToken, [obj objectForKey:@"access_token"]);
            SaveUserInfo(unionId, [obj objectForKey:@"union_id"]);
            SaveUserInfo(openId, [obj objectForKey:@"openid"]);
            [self addCustomer];
        }else {
            if ([obj[@"code"] integerValue] == 1000011) {
                // TODO:更换SDK后修改
                [self respondsToLoginBtn:sender];
//                [UtouuOauth refreshDeviceTokenWithCallBack:^(id obj) {
//                    if (obj) {
//                        SaveUserInfo(accessToken, [obj objectForKey:@"access_token"]);
//                        SaveUserInfo(openId, [UtouuOauth getOpenID]);
//                        [self addCustomer];
//                    }else {
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                        [ShowMessage showMessage:@"登录失败，请稍后再试！" withCenter:kShowMessageViewFrame];
//                    }
//                }];
            }else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [ShowMessage showMessage:obj[@"msg"] withCenter:kShowMessageViewFrame];
            }
        }
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXLoginTablCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    self.loginBtn = cell.loginBtn;
    self.loginBtn.userInteractionEnabled = NO;
    self.loginBtn.alpha = 0.7;
    
    cell.phoneTextField.textField.delegate = self;
    cell.phoneTextField.textField.tag = 100;
    
    cell.passTextField.textField.delegate = self;
    cell.passTextField.textField.tag = 101;
    
    [cell.phoneNumBgView addSubview:self.phoneUnderlineView];
    [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.phoneNumBgView.mas_left);
        make.right.mas_equalTo(cell.phoneNumBgView.mas_right);
        make.bottom.mas_equalTo(cell.phoneNumBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    
    [cell.passwordBgView addSubview:self.passwordUnderlineView];
    [self.passwordUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.passwordBgView.mas_left);
        make.right.mas_equalTo(cell.passwordBgView.mas_right);
        make.bottom.mas_equalTo(cell.passwordBgView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    
    self.phoneNumMarkImgView = cell.phoneNumMarkImgView;
    
    cell.phoneTextField.textField.text = GetUserInfo.accountA;
    self.phoneNum = GetUserInfo.accountA;
    
    self.isPhoneNum = ![NSString isTextEmpty:self.phoneNum];
    if (self.isPhoneNum) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.phoneTextField changeFrameOfPlaceholder];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.passTextField.textField becomeFirstResponder];
            [cell.phoneTextField changeFrameOfPlaceholder];
        });
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.phoneTextField.textField becomeFirstResponder];
            [cell.passTextField changeFrameOfPlaceholder];
        });
    }
    [cell.forgetBtn addTarget:self action:@selector(respondsToForgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.loginBtn addTarget:self action:@selector(respondsToLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.registerBtn addTarget:self action:@selector(respondsToRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 手机号输入
    if (textField.tag == 100) {
        if (textField.hasText) {
            if (![textField.text isEqualToString:GetUserInfo.accountA]) {
                SaveUserInfo(tgt, nil);
                SaveUserInfo(st, nil);
            }
        }
        
        [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.phoneUnderlineView.backgroundColor = RGB(122, 223, 172);
    }
    // 密码输入
    else if (textField.tag == 101) {
        [self.passwordUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
        }];
        self.passwordUnderlineView.backgroundColor = RGB(122, 223, 172);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 手机号输入
    if (textField.tag == 100) {
        [self.phoneUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.phoneUnderlineView.backgroundColor = RGB(193, 193, 194);
    }
    // 密码输入
    else if (textField.tag == 101) {
        [self.passwordUnderlineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0.5);
        }];
        self.passwordUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    // 手机号输入
    if (textField.tag == 100) {
        if ([new_text_str length] > 10) {
            textField.text = [new_text_str substringToIndex:11];
            self.phoneNum = textField.text;
            self.isPhoneNum = [NSString isPhoneNumCorrectPhoneNum:self.phoneNum];
            [textField resignFirstResponder];
            [(UITextField*)[self.view viewWithTag:101] becomeFirstResponder];
            return NO;
        }
        if (new_text_str.length == 0) {
            self.loginBtn.userInteractionEnabled = NO;
            self.loginBtn.alpha = 0.7;
        }else{
            if (![NSString isTextEmpty:self.password]) {
                self.loginBtn.userInteractionEnabled = YES;
                self.loginBtn.alpha = 1;
            }else {
                self.loginBtn.userInteractionEnabled = NO;
                self.loginBtn.alpha = 0.7;
            }
        }
        self.isPhoneNum = NO;
        self.phoneNum = new_text_str;
    }
    // 密码输入
    else if (textField.tag == 101) {
        if ([new_text_str length] > 18) {
            textField.text = [new_text_str substringToIndex:18];
            self.password = textField.text;
            return NO;
        }
        if (new_text_str.length == 0) {
            self.loginBtn.userInteractionEnabled = NO;
            self.loginBtn.alpha = 0.7;
        }else{
            if (![NSString isTextEmpty:self.phoneNum]) {
                self.loginBtn.userInteractionEnabled = YES;
    
                self.loginBtn.alpha = 1;
            }else {
                self.loginBtn.userInteractionEnabled = NO;
                self.loginBtn.alpha = 0.7;
            }
        }
        self.password = new_text_str;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.loginBtn.userInteractionEnabled = NO;
    self.loginBtn.alpha = 0.7;
    if (textField.tag == 100) {
        self.phoneNum = @"";
    }
    // 密码输入
    else if (textField.tag == 101) {
        self.password = @"";
    }
    return YES;
}

#pragma mark - Net Request

/**
 * 网络请求获取订单列表
 */
- (void)getAllDataFromServer {
    [TXNetRequest userCenterRequestMethodWithParams:nil relativeUrl:strUserCenterGetCustomerPersonalInfo success:^(id responseObject) {
    if ([responseObject[ServerResponse_success] boolValue]) {
         SaveUserInfo(isLogin, @"1");
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
             TXUserModel *model = [TXUserModel defaultUser];
             model = [model initWithDictionary:responseObject[@"data"]];
             [TXModelAchivar achiveUserModel];
             SaveUserInfo(password, self.password);
             SaveUserInfo(accountA, self.phoneNum);
         });
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [ShowMessage showMessage:@"登录成功" withCenter:self.view.center];
         [self customPopViewController];
         [TXNetRequest findUserUnreadMsgCount];
         [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserAvatar object:nil];
         // 单独发送用户头像字段 和 昵称 处理model存入时间差显示问题
        NSMutableDictionary *dicUserInfo = [NSMutableDictionary new];
        [dicUserInfo setValue:responseObject[@"data"][@"photo"] forKey:@"photo"];
        [dicUserInfo setValue:responseObject[@"data"][@"nickName"] forKey:@"name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationLoginSuccess object:nil userInfo:dicUserInfo];
        
         // 注册及登录环信用户
         [TXKfLoginManager loginKefuSDKcomplete:^(bool success) {
             SaveUserInfo(hxLoginStatus, success);
         }];
        
     }else {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
     } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [ShowMessage showMessage:error.description];
     } isLogin:^{
         [ShowMessage showMessage:@"登录失败，请重新登录" withCenter:self.view.center];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

#pragma mark - setters

- (void)setIsPhoneNum:(BOOL)isPhoneNum {
    _isPhoneNum = isPhoneNum;
//    self.phoneNumMarkImgView.hidden = !_isPhoneNum;
}

#pragma mark - getters

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        self.tableView.rowHeight = SCREEN_HEIGHT-kTopHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)phoneUnderlineView {
    if (!_phoneUnderlineView) {
        _phoneUnderlineView = [[UIView alloc]initWithFrame:CGRectZero];
        _phoneUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
    return _phoneUnderlineView;
}

- (UIView *)passwordUnderlineView {
    if (!_passwordUnderlineView) {
        _passwordUnderlineView = [[UIView alloc]initWithFrame:CGRectZero];
        _passwordUnderlineView.backgroundColor =  RGB(193, 193, 194);
    }
    return _passwordUnderlineView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

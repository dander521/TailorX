//
//  TXAlipayBindViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXAlipayBindViewController.h"
#import "TXAliPayModel.h"

typedef NS_ENUM(NSInteger, TXOperateAliPayType) {
    TXOperateAliPayTypeUpdate = 0, /** <修改 */
    TXOperateAliPayTypeBind /** <绑定 */
};

@interface TXAlipayBindViewController ()<UITextFieldDelegate>

/** 支付宝模型 */
@property (nonatomic, strong) TXAliPayModel *aliPayModel;
/** accountField */
@property (nonatomic, strong) UITextField *accountField;

@end

@implementation TXAlipayBindViewController
{
    BOOL _wasKeyboardManagerEnabled;
}

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置控制器
    [self configViewController];
    // 配置ui
    [self setupUI];
    // 设置底部视图
    [self setupBottomButton];
    // 获取支付宝绑定信息
    [self getAliPayBindStatus];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

#pragma mark - Initial

/**
 配置控制器
 */
- (void)configViewController {
    self.navigationItem.title = LocalSTR(@"Str_AlipayBind");
//    if ([TXModelAchivar getUserModel].payBind) {
//        self.navigationItem.title = @"修改支付宝账号";
//    }
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 配置ui
 */
- (void)setupUI {
    UILabel *alipayLabel = [[UILabel alloc] init];
    alipayLabel.text = LocalSTR(@"Str_AliAccount");
    alipayLabel.font = FONT(15);
    alipayLabel.textColor = RGB(46, 46, 46);
    [self.view addSubview:alipayLabel];
    
    self.accountField = [[UITextField alloc] init];
    self.accountField.placeholder = LocalSTR(@"Prompt_InputAliAccount");
    self.accountField.font = FONT(15);
    self.accountField.delegate = self;
    self.accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountField.text = [TXModelAchivar getUserModel].payBind ? self.aliPayModel.alipay : @"";
    self.accountField.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.accountField];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.text = LocalSTR(@"Prompt_InputReminder");
    promptLabel.textColor = RGB(153, 153, 153);
    [self.view addSubview:promptLabel];
    
    [alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(94);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alipayLabel.mas_right);
        make.top.mas_equalTo(84);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.accountField.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(line.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];
    
    [self.accountField becomeFirstResponder];
}

/**
 设置底部视图
 */
- (void)setupBottomButton {
    NSString *titleStr = [TXModelAchivar getUserModel].payBind ? @"修改" : @"立即绑定";
    ThemeButton *bottomButton = [TailorxFactory setBlackThemeBtnWithTitle:titleStr];
    bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    bottomButton.titleLabel.font = FONT(17);
    [bottomButton addTarget:self action:@selector(bindAlipay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:true];
    return true;
}

#pragma mark - Custom Method

- (void)bindAlipay:(id)sender {
    [self.view endEditing:YES];
    
    if (![NSString validateEmail:self.accountField.text] && ![NSString isPhoneNumCorrectPhoneNum:self.accountField.text]) {
        [ShowMessage showMessage:@"您输入的支付账户格式有误，请核对后重新输入！" withCenter:self.view.center];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    // 0修改，1初次绑定
    if ([TXModelAchivar getUserModel].payBind) {
        [params setValue:[NSString stringWithFormat:@"%zd", TXOperateAliPayTypeUpdate] forKey:@"type"];
    } else {
        [params setValue:[NSString stringWithFormat:@"%zd", TXOperateAliPayTypeBind] forKey:@"type"];
    }
    [params setValue:self.accountField.text forKey:@"account"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:params
                                        relativeUrl:strUserCenterUpdateAliPay
                                         success:^(id responseObject) {
                                             if ([responseObject[ServerResponse_success] boolValue]) {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                                 [TXModelAchivar updateUserModelWithKey:@"payBind" value:@"1"];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationVerifyBindAliPaySuccess object:nil];
                                                 [self.navigationController popViewControllerAnimated:true];
                                             } else {
                                                 if ([responseObject[ServerResponse_code] integerValue] == 700023) {
                                                     [ShowMessage showMessage:@"绑定支付宝需要先进行实名认证" withCenter:self.view.center];
                                                 } else {
                                                     [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                                 }
                                             }
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

#pragma mark - Net Request 

/**
 获取支付宝绑定信息
 */
- (void)getAliPayBindStatus {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterCheckAliPayBindStatus
                                         success:^(id responseObject) {
                                             if ([responseObject[ServerResponse_success] boolValue]) {
                                                 self.aliPayModel = [TXAliPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                                                 
                                                 if (self.aliPayModel.payBindStatus == 1) {
                                                     self.accountField.text = self.aliPayModel.alipay;
                                                 }
                                             } else {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             }
                                             
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

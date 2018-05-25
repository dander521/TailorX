//
//  TXSetupNicknameViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXSetupNicknameViewController.h"

@interface TXSetupNicknameViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTextField;

@end

@implementation TXSetupNicknameViewController
{
    BOOL _wasKeyboardManagerEnabled;
}

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器
    [self configViewController];
    // 设置界面
    [self setUI];
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
 设置控制器
 */
- (void)configViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = LocalSTR(@"Str_SetNickname");
}

/**
 *  设置界面显示
 */
- (void)setUI {
    ThemeButton *bottomButton = [TailorxFactory setBlackThemeBtnWithTitle:@"提交"];
    bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT - kTabBarHeight, SCREEN_WIDTH, 49);
    [bottomButton setTitle:LocalSTR(@"Str_Save") forState:UIControlStateNormal];
    bottomButton.titleLabel.font = FONT(17);
    [bottomButton addTarget:self action:@selector(saveNickName:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.tintColor = RGB(51, 51, 51);
    self.nameTextField.delegate = self;
    self.nameTextField.text = [TXModelAchivar getUserModel].nickName;

    self.nameTextField.borderStyle = UITextBorderStyleNone;
    [self.nameTextField becomeFirstResponder];
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextField.font = FONT(15);
    [self.view addSubview:self.nameTextField];
    
    UILabel * desLab = [[UILabel alloc] init];
    desLab.numberOfLines = 0;
    desLab.font = FONT(13);
    desLab.textColor = RGB(153, 153, 153);
    desLab.text = LocalSTR(@"Prompt_SetNickname");
    [self.view addSubview:desLab];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kTopHeight + 20);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(H(23));
    }];
    
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = RGB(0, 0, 0);
    bottomLine.alpha = 0.1;
    [self.view addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(10);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(@(1));
    }];
    
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomLine.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [_nameTextField becomeFirstResponder];
}

#pragma mark - Custom Method

- (void)saveNickName:(id)sender {
    [self.nameTextField resignFirstResponder];
    if (self.nameTextField.text.length == 0) {
        
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [TXNetRequest userCenterRequestMethodWithParams:@{@"nickName" : self.nameTextField .text}
                                            relativeUrl:strUserCenterModifyNickname
                                             success:^(id responseObject) {
                                                 if ([responseObject[kSuccess] boolValue]) {
                                                     [TXModelAchivar updateUserModelWithKey:@"nickName" value:self.nameTextField .text];
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserNickName object:nil];
                                                     [self.navigationController popViewControllerAnimated:true];
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
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([aString length] > 15) {
        textField.text = [aString substringToIndex:15];
        return NO;
    }
    return YES;
}

#pragma mark - UIResponse

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

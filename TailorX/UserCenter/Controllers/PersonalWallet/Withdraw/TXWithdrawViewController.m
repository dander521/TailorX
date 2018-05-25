//
//  TXWithdrawViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXWithdrawViewController.h"
#import "TXAliPayModel.h"
#import "TXBaseTextFieldWithNoMenu.h"
#import "TXAlipayBindViewController.h"
#import "TXCountDownTime.h"
#import "TXWithdrawSuccessViewController.h"

@interface TXWithdrawViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    NSString  *_balanceValue;
    NSInteger _withdrawCount; //当前可提现次数
    NSInteger _counts; // 文字描述中 提现的次数
    float     _useableness; //可用余额
    float _minValue; //最低提现金额
    float _maxValue; //单次最高提现金额
    NSString *_ratioDec; //费率
    NSString *_time;
    
}
@property (weak, nonatomic) IBOutlet UILabel *alipayAccount;
@property (weak, nonatomic) IBOutlet TXBaseTextFieldWithNoMenu *balance;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *min;
@property (weak, nonatomic) IBOutlet UILabel *max;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *balanceDisplay;
@property (weak, nonatomic) IBOutlet UILabel *ratio;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UILabel *serviceCharge;
@property (weak, nonatomic) IBOutlet TXBaseTextFieldWithNoMenu *vcodeTF;
@property (weak, nonatomic) IBOutlet UIButton *vcodeBtn;

/** 支付宝模型 */
@property (nonatomic, strong) TXAliPayModel *aliPayModel;

@end

@implementation TXWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现";

    [self changeButtonStatus:NO];
    
    [self getAliPayBindStatus];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self getBalanceAccountInfo];
}

-(void)viewWillDisappear:(BOOL)animated {
    self.balance.text = @"";
    _balanceValue = @"";
    self.vcodeTF.text = @"";
    [self changeTheDisplayWithValue:@"0.00"];
    [self changeButtonStatus:NO];
}

- (void)createUI {
    [self.vcodeBtn.titleLabel setTextColor:[[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 数据请求

/**
 * 获取提余额户信息
 */
- (void)getBalanceAccountInfo {
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [strTailorxAPI stringByAppendingString:findMyBalance];
    //请求余额账户
    [TXBaseNetworkRequset requestWithURL:url params:@{@"accountType":@"022"} success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            NSDictionary *dataDic = (NSDictionary *)(responseObject[ServerResponse_data]);

            _useableness = [dataDic[@"balance"] floatValue];
            _minValue = [dataDic[@"moneyMin"] floatValue];
            _maxValue = [dataDic[@"moneyMax"] floatValue];
            _withdrawCount = [dataDic[@"withdrawCount"] integerValue];
            _ratioDec = [NSDecimalNumber decimalNumberWithDecimal:[dataDic[@"ratio"] decimalValue]].stringValue;
            
            _counts = [dataDic[@"count"] integerValue];
            [self refreshUI];
            [self performSelector:@selector(checkTheCount) withObject:nil afterDelay:0.6];
        }else {
            [ShowMessage showMessage:(responseObject[ServerResponse_msg]) withCenter:self.view.center];
        }
        
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}


/**
 获取支付宝绑定信息
 */
- (void)getAliPayBindStatus {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterCheckAliPayBindStatus
                                            success:^(id responseObject) {
                                                if ([responseObject[ServerResponse_success] boolValue]) {
                                                    self.aliPayModel = [TXAliPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                                                    if (self.aliPayModel.payBindStatus == 1) {
                                                        self.alipayAccount.text = self.aliPayModel.alipay;
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

//获取短信验证码
- (void)getVerifyCodeForWithdraw {
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:[UIColor clearColor] countColor:[UIColor clearColor] atBtn:self.vcodeBtn];
    
    weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:getVcode];
    [TXBaseNetworkRequset requestWithURL:url params:nil success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            [ShowMessage showMessage:(responseObject[ServerResponse_msg]) withCenter:self.view.center];
        }
    } failure:^(NSError *error) {
        [ShowMessage showMessage:error.description withCenter:self.view.center];
    } isLogin:^{
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}

- (void)requestForWithdraw {
    // 提现接口
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [strTailorxAPI stringByAppendingString:withdrawDeposit];
    [TXBaseNetworkRequset requestWithURL:url params:@{@"amount":[NSDecimalNumber decimalNumberWithString:_balanceValue],@"vcode":_vcodeTF.text} success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
           //提现成功
            NSDictionary *dict = responseObject[ServerResponse_data];
            _time = dict[@"finishTime"];
            [self enterWithdrawSuccess];
            
        }else {
            [ShowMessage showMessage:(responseObject[ServerResponse_msg]) withCenter:self.view.center];
        }
        
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];

}

#pragma mark - 响应事件
- (IBAction)balanceButtonAction:(id)sender {
    if ([_vcodeTF.text length] == 0 || _vcodeTF.text == nil) {
        [ShowMessage showMessage:@"请输入验证码" withCenter:self.view.center];
        return;
    }
    //提现
    [self requestForWithdraw];
}

- (void)showAlertWithNoAlipayBind {
    self.balance.enabled = NO;
    [self changeButtonStatus:NO];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"没有绑定支付宝"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"去绑定", nil];
    alertView.tag = 100;
    [alertView show];
}

- (void)showAlertWithAlipayIsInVerify {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"账户正在进行实名认证"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)vcodeButtonAction:(id)sender {
    [self getVerifyCodeForWithdraw];
}


#pragma UIAlertViewDelegate 
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        //进入支付宝绑定
        [self.navigationController pushViewController:[TXAlipayBindViewController new] animated:true];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.balance) {
        _balanceValue = self.balance.text;
        if (self.balance.text != nil && [self.balance.text length] != 0) {
            if ([self.balance.text floatValue] >= _minValue) {
                if ([self.balance.text floatValue] > _maxValue) {
                    NSString *tip = [NSString stringWithFormat:@"单次提现金额最高为%@元",@(_maxValue)];
                    [ShowMessage showMessage:tip withCenter:self.view.center];
                    [self changeTheDisplayWithValue:@"0.00"];
                    [self changeButtonStatus:NO];
                }else {
                    if ([_balanceValue floatValue] > _useableness) {
                        NSString *currentValue = [NSString stringWithFormat:@"可提取余额为:￥%@",@(_useableness)];
                        [ShowMessage showMessage:currentValue withCenter:self.view.center];
                        return;
                    }
                    [self changeTheDisplayWithValue:self.balance.text];
                    [self changeButtonStatus:YES];
                }
            }else {
                NSString *tip = [NSString stringWithFormat:@"最低提现金额为%@元",@(_minValue)];
                [ShowMessage showMessage:tip withCenter:self.view.center];
                [self changeTheDisplayWithValue:@"0.00"];
                [self changeButtonStatus:NO];
            }
            
        }else {
            [self changeTheDisplayWithValue:@"0.00"];
            [self changeButtonStatus:NO];
        }
        
    }
}


#pragma mark - 数据校验
- (void)checkTheCount {
    if (_withdrawCount == 0) {
        [ShowMessage showMessage:@"今日提现次数已用完" withCenter:self.view.center];
        _balance.enabled = NO;
        [self changeButtonStatus:NO];
    }else {
        [self refreshUI];
    }
}

#pragma mark - 改变UI
- (void)refreshUI {
    self.min.text = [NSString stringWithFormat:@"1、最低提现金额为%@元",[@(_minValue) stringValue]];
    self.ratio.text = [NSString stringWithFormat:@"2、提现要支付%@%%的手续费",_ratioDec];
    self.max.text = [NSString stringWithFormat:@"3、单次提现金额最高为%@元",[@(_maxValue) stringValue]];
    self.count.text = [NSString stringWithFormat:@"4、每日最多可提现%@次",[@(_counts) stringValue]];
    self.amount.text = [NSString stringWithFormat:@"可用提取余额:￥%@",[@(_useableness) stringValue]];
}

- (void)changeTheDisplayWithValue:(NSString *)value {
    _balanceValue = value;
    self.balanceDisplay.text = [NSString stringWithFormat:@"￥%@",_balanceValue];
    NSDecimalNumber *deciRatioPercent = [NSDecimalNumber decimalNumberWithString:_ratioDec];
    deciRatioPercent = [deciRatioPercent decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithDecimal:(@(100).decimalValue)]];
    NSDecimalNumber *deciService = [deciRatioPercent decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:_balanceValue]];
    self.serviceCharge.text = [NSString stringWithFormat:@"服务费:￥%@",deciService.stringValue];
}

- (UIColor *)buttonColorWithEnabledStatus:(BOOL)status {
    if (status) {
        return [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    }else {
        NSDictionary *rgbDic = [[ThemeManager shareManager] loadRGBValueFromThemeColorWithName:@"navigation_color"];
        if (rgbDic.count < 3) {
            return nil;
        }
        CGFloat red = [rgbDic[@"R"] floatValue];
        CGFloat green = [rgbDic[@"G"] floatValue];
        CGFloat blue = [rgbDic[@"B"] floatValue];
        NSNumber *alpheNum = rgbDic[@"A"];
        CGFloat alpha = alpheNum ? [alpheNum floatValue] : 1;
        
        UIColor *color = RGBA(red, green, blue, alpha*0.6);
        return color;
    }
}

- (void)changeButtonStatus:(BOOL)status {
    [self.balanceBtn setBackgroundColor:[self buttonColorWithEnabledStatus:status]];
    
}

- (void)enterWithdrawSuccess {
    TXWithdrawSuccessViewController *succesVC = [[TXWithdrawSuccessViewController alloc] initWithNibName:@"TXWithdrawSuccessViewController" bundle:nil];
    succesVC.alipayValue = _aliPayModel.alipay;
    succesVC.withdrawValue = _balanceValue;
    succesVC.timeValue = _time;
    [self.navigationController pushViewController:succesVC animated:YES];
}

@end

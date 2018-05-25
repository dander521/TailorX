//
//  TXTransformEarningViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/31.
//  Copyright © 2017年 ;. All rights reserved.
//

#import "TXTransformEarningViewController.h"
#import "TXBaseTextFieldWithNoMenu.h"
#import "TXTransformSuccessViewController.h"
#import "TXTransformEarnModel.h"

@interface TXTransformEarningViewController () <UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString *_turnOutValue;
    NSString *_payType;
    NSString *_balance;
    NSString *_time;
    
    /** 次数为-1时，表示无限制 */
    NSInteger _transferCount;
    
    float _ratioF;
    float _minF;
    float _maxF;
    
}
@property (weak, nonatomic) IBOutlet TXBaseTextFieldWithNoMenu *turnOut;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *serviceCharge;
@property (weak, nonatomic) IBOutlet UILabel *minTurnOut;
@property (weak, nonatomic) IBOutlet UILabel *serviceChargePercent;
@property (weak, nonatomic) IBOutlet UILabel *maxTurnOut;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *incomeDisplay;
@property (weak, nonatomic) IBOutlet UIButton *turnOutBtn;

@property (weak, nonatomic) NSString *incomeValue;
@property (copy, nonatomic) NSString *ratio;
@property (copy, nonatomic) NSString *min;
@property (copy, nonatomic) NSString *max;
@property (copy, nonatomic) NSString *dayCount;

@property (strong, nonatomic) TXTransformEarnModel *model;


@end

@implementation TXTransformEarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"转出收益";
    _payType = @"1";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ratioAlipayCallBack:) name:kNSNotificationAliPaySuccess object:nil];
    
    [self changeButtonStatus:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [self requestForIncomeInfo];
}

-(void)viewWillDisappear:(BOOL)animated {
    self.turnOut.text = @"";
    [self setTurnOutValue:@"0.00"];
    [self changeButtonStatus:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 改变状态
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
    [self.turnOutBtn setBackgroundColor:[self buttonColorWithEnabledStatus:status]];
    self.turnOutBtn.enabled = status;
}

- (void)refreshUI {
    self.income.text = [NSString stringWithFormat:@"可提取收益余额:￥%.2f",[self.incomeValue floatValue]];
    self.minTurnOut.text = [NSString stringWithFormat:@"1、最低转出收益金额为%@元",self.min];
    self.serviceChargePercent.text = [NSString stringWithFormat:@"2、转出收益余额，需要支付%@%%交易服务费",self.ratio];
    self.maxTurnOut.text = [NSString stringWithFormat:@"3、单次转出金额最高为%@元",self.max];
    self.count.text = [NSString stringWithFormat:@"4、每日最多可转出%@次",self.dayCount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)turnOutAction:(id)sender {
    //判断当前输入的值是不是小于 100 的
    [self checkInputValue];
}

- (void)checkInputValue {
    if (self.income.text == nil || [self.income.text length] == 0) {
        [ShowMessage showMessage:@"请输入转出金额" withCenter:self.view.center];
    }else {
        [self payTypeJudge];
    }
}

- (void)payTypeJudge {
    NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:_balance];
    NSDecimalNumber *ratio = [NSDecimalNumber decimalNumberWithString:self.serviceCharge.text];
    if ([balance compare:ratio] == NSOrderedDescending || [balance compare:ratio] == NSOrderedSame) {
        _payType = @"1"; //余额够服务费手续费
    }else {
        _payType = @"2"; //余额不够，直接进行支付宝支付
    }
    [self postRequest];
}

- (void)ratioAlipayCallBack:(NSNotification *)notify {
    if (self.navigationController.visibleViewController != self) {
        return;
    }
    NSDictionary *resultDic = notify.userInfo;
    
    NSLog(@"%@",resultDic);
    
    NSString *message;
    
    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController showAlertWithTitle:@"" message:@"服务费付款成功" actionsMsg:@[@"确定"] buttonActions:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self showSuccess];
                }
            } target:self];
        });
        
        
    } else {
        if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
            message = @"正在处理中";
        }
        else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
            message = @"支付失败";
        }
        else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
            message = @"用户中途取消";
        }
        else {
            message = @"支付失败";
        }
        [ShowMessage showMessage:message];
    }
}

#pragma mark - 请求数据
- (void)requestForIncomeInfo {
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [strTailorxAPI stringByAppendingString:findMyBalance];
    //请求收益账户 023
    [TXBaseNetworkRequset requestWithURL:url params:@{@"accountType":@"023"} success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            self.model = [TXTransformEarnModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
            
            self.incomeValue = self.model.income;
            _transferCount = self.model.transferCount;
            self.ratio = [NSString stringWithFormat:@"%.2f", self.model.ratio];
            _ratioF = self.model.ratio;
            self.min = [NSString stringWithFormat:@"%.2f", self.model.moneyMin];
            _minF = self.model.moneyMin;
            self.max = [NSString stringWithFormat:@"%.2f", self.model.moneyMax];
            _maxF = self.model.moneyMax;
            self.dayCount = [NSString stringWithFormat:@"%zd", self.model.day];
            _balance = self.model.balance;
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

- (void)postRequest {
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [strTailorxAPI stringByAppendingString:incomeToBalance];
    
    [TXBaseNetworkRequset requestWithURL:url params:@{@"amount":_turnOutValue,
                                                      @"taxPayType":_payType} success:^(id responseObject) {
        
        if ([responseObject[ServerResponse_success] boolValue]) {
            _time = (responseObject[ServerResponse_data])[@"finishTime"];
            if ([_payType isEqualToString:@"1"]) {
                [self showSuccess]; //余额支付费用
            }else {
                [[AlipaySDK defaultService] payOrder:responseObject[ServerResponse_msg] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"%@",resultDic);
                }];
            }
        }else {
            [ShowMessage showMessage:responseObject[ServerResponse_msg]];
        }
        [MBProgressHUD hideHUDForView:self.view];
                                                          
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error);
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.turnOut) {
        _turnOutValue = textField.text;
        if (self.turnOut.text != nil && [self.turnOut.text length] != 0) {
            if ([self.turnOut.text floatValue] >= _minF) {
                if ([self.turnOut.text floatValue] > _maxF) {
                    NSString *tip = [NSString stringWithFormat:@"单次转出金额最高为%@元",self.max];
                    [ShowMessage showMessage:tip withCenter:self.view.center];
                    [self setTurnOutValue:@"0.00"];
                    [self changeButtonStatus:NO];
                }else {
                    if ([_turnOutValue floatValue] > [_incomeValue floatValue]) {
                        NSString *currentValue = [NSString stringWithFormat:@"当前收益额为:￥%@",_incomeValue];
                        [ShowMessage showMessage:currentValue withCenter:self.view.center];
                        return;
                    }
                    [self setTurnOutValue:self.turnOut.text];
                    [self changeButtonStatus:YES];
                }
            }else {
                NSString *tip = [NSString stringWithFormat:@"最低转出收益金额为%@元",self.min];
                [ShowMessage showMessage:tip withCenter:self.view.center];
                [self setTurnOutValue:@"0.00"];
                [self changeButtonStatus:NO];
            }
            
        }else {
            [self setTurnOutValue:@"0.00"];
            [self changeButtonStatus:NO];
        }
        
    }
}

#pragma mark - 编辑完成更新数据
- (void)setTurnOutValue:(NSString *)turnOutValue {
    _turnOutValue = turnOutValue;
    self.incomeDisplay.text = [NSString stringWithFormat:@"￥%@",_turnOutValue];
    NSNumber *ratio = [NSNumber numberWithFloat:_ratioF];
    NSDecimalNumber *deciRatioPercent = [NSDecimalNumber decimalNumberWithDecimal:ratio.decimalValue];
    deciRatioPercent = [deciRatioPercent decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithDecimal:(@(100).decimalValue)]];
    NSDecimalNumber *deciService = [deciRatioPercent decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:_turnOutValue]];
    self.serviceCharge.text = [NSString stringWithFormat:@"服务费:￥%@",deciService.stringValue];
}

- (void)checkTheCount {
    if (_transferCount == 0) {
        [ShowMessage showMessage:@"今日收益转出次数已用完" withCenter:self.view.center];
        _turnOut.enabled = NO;
        [self changeButtonStatus:NO];
    }else {
        [self refreshUI];
    }
}

- (void)showSuccess {
    TXTransformSuccessViewController *success = [[TXTransformSuccessViewController alloc] initWithNibName:@"TXTransformSuccessViewController" bundle:nil];
    success.turnOutValue = _turnOutValue;
    success.timeValue = _time;
    success.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:success animated:YES];
}

- (void)showFailure {
    //余额不足是 5002
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"转出失败" message:@"账户余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去充值", nil];
    [alert show];
}






@end

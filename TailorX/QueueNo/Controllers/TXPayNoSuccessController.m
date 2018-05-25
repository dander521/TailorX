//
//  TXPayNoSuccessController.m
//  TailorX
//
//  Created by liuyanming on 2017/4/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPayNoSuccessController.h"

@interface TXPayNoSuccessController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgv;
@property (weak, nonatomic) IBOutlet UILabel *originalNum;
@property (weak, nonatomic) IBOutlet UILabel *presentNum;
@property (weak, nonatomic) IBOutlet ThemeLabel *payMoney;
@property (weak, nonatomic) IBOutlet ThemeButton *sureBtn;

@end

@implementation TXPayNoSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setupNavigationBar];
    // 给界面UI赋值
    [self setupUI];
}

- (void)setupUI {
    _iconImgv.image = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_main_success"];
    
    _originalNum.text = [NSString stringWithFormat:@"%@号", self.originalNumStr ?: @""];
    _presentNum.text = [NSString stringWithFormat:@"%@号", self.presentNumStr ?: @""];
    
    NSString *money = [NSString stringWithFormat:@"￥%@", self.payMoneyStr ?:@"0.00"];
    NSString *money1 = [NSString stringWithFormat:@"实付款：%@", money];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:money1];
    [str2 addAttribute:NSForegroundColorAttributeName value:RedColor range:[money1 rangeOfString:money]];
    _payMoney.attributedText = str2;
    
    _sureBtn.titleLabel.font = FONT(16);
    _sureBtn.cloNameN = @"theme_Btn_bg_color";
    _sureBtn.cloNameH = @"theme_Btn_bg_color";
}

- (void)setupNavigationBar {
    self.title = @"支付";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn addTarget:self action:@selector(respondsToSureBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

- (void)respondsToSureBtn {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationQueueNoBuySucceed object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

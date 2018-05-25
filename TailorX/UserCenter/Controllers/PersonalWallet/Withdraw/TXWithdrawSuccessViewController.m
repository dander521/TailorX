//
//  TXWithdrawSuccessViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXWithdrawSuccessViewController.h"
#import "AppDelegate.h"

@interface TXWithdrawSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *withdrawLable;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *alipayAccount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *successBtn;

@end

@implementation TXWithdrawSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现";
    self.withdrawLable.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    self.successBtn.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    self.withdrawLable.text = [NSString stringWithFormat:@"￥%@",self.withdrawValue];
    self.alipayAccount.text = self.alipayValue;
    self.time.text = self.timeValue;
    [self requestIncomeValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:nil
                                                               action:nil];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark -
- (void)requestIncomeValue {
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [strTailorxAPI stringByAppendingString:findMyBalance];
    //请求提现账号
    [TXBaseNetworkRequset requestWithURL:url params:@{@"accountType":@"022"} success:^(id responseObject) {
        
        if ([responseObject[ServerResponse_success] boolValue]) {
            NSString *income = [(responseObject[ServerResponse_data][@"balance"]) stringValue];
            self.balance.text = [NSString stringWithFormat:@"¥%@",income];
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
- (IBAction)successButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

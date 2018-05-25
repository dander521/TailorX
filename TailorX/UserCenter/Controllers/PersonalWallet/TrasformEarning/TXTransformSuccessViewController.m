//
//  TXTransformFailureViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTransformSuccessViewController.h"
#import "AppDelegate.h"

@interface TXTransformSuccessViewController ()
{
    NSTimeInterval time;
}
@property (weak, nonatomic) IBOutlet UILabel *turnOut;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *successBtn;

@end

@implementation TXTransformSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.turnOut.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    self.successBtn.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    self.turnOut.text = [NSString stringWithFormat:@"￥%@",_turnOutValue];
    self.timeL.text = self.timeValue;
    self.title = @"转出收益";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)requestIncomeValue {
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [strTailorxAPI stringByAppendingString:findMyBalance];
    //请求收益账户
    [TXBaseNetworkRequset requestWithURL:url params:@{@"accountType":@"023"} success:^(id responseObject) {
        
        if ([responseObject[ServerResponse_success] boolValue]) {
            NSString *income = [(responseObject[ServerResponse_data][@"income"]) stringValue];
            self.amount.text = [NSString stringWithFormat:@"¥%@",income];
        }else {
            
        }
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}
- (IBAction)popSuccessAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  TXPersonalWalletViewController.m
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPersonalWalletViewController.h"
#import "TXWalletView.h"
#import "TXTransDetailController.h"
#import "TXWalletDetailViewController.h"
#import "TXRechargeController.h"
#import "TXWithdrawViewController.h"
#import "TXTransformEarningViewController.h"
#import "TXNameVerifyViewController.h"
#import "TXAlipayBindViewController.h"

typedef NS_ENUM(NSUInteger, TXUserAuthResponseCode) {
    TXUserAuthResponseCode_UNBINDING_AUTHENTICATION = 100032,
    TXUserAuthResponseCode_UNBINDING_ALIPAY = 100033,
};

@interface TXPersonalWalletViewController () <TXWalletViewDelegate, NetErrorViewDelegate,UIAlertViewDelegate>
{
    TXUserAuthResponseCode _code;
    CGFloat _balance;
}
@property (strong, nonatomic) NetErrorView *netView;
@property (nonatomic, weak) TXWalletView *walletView;

@end

@implementation TXPersonalWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器属性
    [self configViewController];
    
    [self addChildViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

#pragma mark - Config ViewController

/**
 设置控制器属性
 */
- (void)configViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的钱包";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_main_wallet_list"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAuction)];
    
}

- (void)addChildViews {
    TXWalletView *walletView = [TXWalletView instanse];
    walletView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight);
    walletView.delegate = self;
    [self.view addSubview:walletView];
    _walletView = walletView;
}

- (void)loadData {
    
    [self.netView showAddedTo:self.view isClearBgc:NO];
    weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:findMyBalance];
    
    [TXBaseNetworkRequset requestWithURL:url params:@{@"accountType":@"all"} success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            
            [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
            
            NSString *balance = responseObject[ServerResponse_data][@"balance"];
            _balance = [(responseObject[ServerResponse_data][@"balance"]) floatValue];
            NSString *income = responseObject[ServerResponse_data][@"income"];
            weakSelf.walletView.balance = [NSString stringWithFormat:@"%0.2f",[balance floatValue]];
            weakSelf.walletView.erning = [NSString stringWithFormat:@"%0.2f",[income floatValue]];
        }else {
            [weakSelf.netView stopNetViewLoadingFail:NO error:YES];
        }
    } failure:^(NSError *error) {
        [weakSelf.netView stopNetViewLoadingFail:YES error:NO];
    } isLogin:^{
        [weakSelf.netView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
    
}

//检测提现
- (void)checkTheWithdrawDeposit {
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [strTailorxAPI stringByAppendingString:checkWithdrawDeposit];
    
    [TXBaseNetworkRequset requestWithURL:url params:nil success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]){
            //进入提现
            [self enterWithdraw];
        }
        else{
            _code = [responseObject[ServerResponse_code] integerValue];
            if(_code == TXUserAuthResponseCode_UNBINDING_AUTHENTICATION ||
               _code == TXUserAuthResponseCode_UNBINDING_ALIPAY) {
                [self showAlertWithResponseCode:_code];
                [MBProgressHUD hideHUDForView:self.view];
                return ;
            }else {
                [ShowMessage showMessage:(responseObject[ServerResponse_msg]) withCenter:self.view.center];
            }
        }
        
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}

#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self loadData];
}

#pragma mark - 充值代理方法
- (void)rechargeBtnClick:(UIButton *)button {
    TXRechargeController *vc = [[TXRechargeController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)withdrawBtnClick:(UIButton *)button {
    if (_balance > 0) {
        //检测提现
        [self checkTheWithdrawDeposit];
    }else {
        [ShowMessage showMessage:@"账户可提现资金不足!" withCenter:self.view.center];
    }
    
}

- (void)erningBtnClick:(UIButton *)button {
    TXTransformEarningViewController *income = [[TXTransformEarningViewController alloc] initWithNibName:@"TXTransformEarningViewController" bundle:nil];
    [self.navigationController pushViewController:income animated:YES];
}

- (void)enterWithdraw {
    TXWithdrawViewController *balance = [[TXWithdrawViewController alloc] initWithNibName:@"TXWithdrawViewController" bundle:nil];
    
    [self.navigationController pushViewController:balance animated:YES];
}

#pragma mark - 导航栏右边按钮方法
- (void)rightBarButtonItemAuction {
    TXWalletDetailViewController *vc = [[TXWalletDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    TXTransDetailController *vc = [[TXTransDetailController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _netView.delegate = self;
    }
    return _netView;
}

#pragma mark - ShowAlert
- (void)showAlertWithResponseCode:(TXUserAuthResponseCode)code {
    NSString *msg = @"";
    NSString *title = @"";
    switch (code) {
        case TXUserAuthResponseCode_UNBINDING_AUTHENTICATION:{
            msg = @"未进行实名认证,不可提现";
            title = @"立即认证";
            break;
        }
        case TXUserAuthResponseCode_UNBINDING_ALIPAY:
        {
            msg = @"未绑定支付宝,不可进行提现提现";
            title = @"立即绑定";
            break;
        }
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:title, nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        switch (_code) {
            case TXUserAuthResponseCode_UNBINDING_AUTHENTICATION: {
                TXNameVerifyViewController *verifyVC = [TXNameVerifyViewController new];
                [self.navigationController pushViewController:verifyVC animated:YES];
                break;
            }
            case TXUserAuthResponseCode_UNBINDING_ALIPAY: {
                //进入支付宝绑定
                [self.navigationController pushViewController:[TXAlipayBindViewController new] animated:true];
            }
            default:
                break;
        }
    }
}



@end

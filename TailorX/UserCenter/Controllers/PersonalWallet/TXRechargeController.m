//
//  TXRechargeController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXRechargeController.h"
#import "TXRechargeView.h"
#import "TXWalletParams.h"

@interface TXRechargeController ()<TXRechargeViewDelegate>

@property (nonatomic, weak) TXRechargeView *rechargeView;

@property (strong, nonatomic) NetErrorView *netView;

@end

@implementation TXRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    
    TXRechargeView *rechargeView = [TXRechargeView instanse];
    rechargeView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight);
    rechargeView.delegate = self;
    [self.view addSubview:rechargeView];
    
    self.rechargeView = rechargeView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeAlipayCallBack:) name:kNSNotificationAliPaySuccess object:nil];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationAliPaySuccess object:nil];
}


#pragma mark -  充值成功后回调
- (void)rechargeAlipayCallBack:(NSNotification *)notification {

    NSDictionary *resultDic = notification.userInfo;
    
    NSLog(@"%@",resultDic);
    
    NSString *message;
    
    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController showAlertWithTitle:@"" message:@"充值成功" actionsMsg:@[@"确定",@"继续充值"] buttonActions:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } target:self];
        });
        
        
    } else {
        if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
            message = @"正在处理中";
        }
        else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
            message = @"订单支付失败";
        }
        else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
            message = @"用户中途取消";
        }
        else {
            message = @"订单支付失败";
        }
        [ShowMessage showMessage:message];
    }
}

#pragma mark - TXRechargeViewDelegate--充值
- (void)rechargeViewSureBtnClick:(UIButton *)button {
    
    // 3. 调用支付宝
    weakSelf(self);
    void(^addRechargeRecordBlock)() = ^() {
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        
        TXWalletParams *param = [TXWalletParams param];
        param.amount = weakSelf.rechargeView.textField.text;
        
        NSString *url = [strTailorxAPI stringByAppendingString:addRechargeRecord];
        
        [TXBaseNetworkRequset requestWithURL:url params:param.mj_keyValues success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[ServerResponse_success] boolValue]) {
                [[AlipaySDK defaultService] payOrder:responseObject[ServerResponse_msg] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"%@",resultDic);
                }];
                
            }else {
                [ShowMessage showMessage:responseObject[ServerResponse_msg]];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [ShowMessage showMessage:error.description];
        } isLogin:^{
            
        }];
    };
    
    addRechargeRecordBlock();
    // 1.实名认证
    
    // 2.支付宝绑定
//    [TXWalletHttpTool getUserPayInfo:nil success:^(id responseObject) {
//        //  0为未绑定, 1为已绑定 实名认证状态: ("未提交", 0),("通过", 1),("审核中", 2),("不通过", 3),("已过期",4)
//        NSInteger code = [responseObject[ServerResponse_code] integerValue];
//        
//        switch (code) {
//            case 0:
//            {
//                [ShowMessage showMessage:@"未绑定支付宝"];
//                
//                NSString *message = NSLocalizedString(@"未绑定支付宝，不可进行充值", nil);
//                NSString *otherButtonTitle = NSLocalizedString(@"立即去绑定", nil);
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    
//                }];
//                [alertController addAction:otherAction];
//                [self presentViewController:alertController animated:YES completion:nil];
//                break;
//            }
//            case 1:
//            {
//                addRechargeRecordBlock();
//                break;
//            }
//            case 2:
//            {
//                [ShowMessage showMessage:@"支付宝绑定审核中"];
//                break;
//            }
//            case 3:
//            {
//                [ShowMessage showMessage:@"绑定支付宝未通过"];
//                break;
//            }
//            case 4:
//            {
//                [ShowMessage showMessage:@"支付宝绑定已过期"];
//                break;
//            }
//            default:
//                break;
//        }
//        
//    } failure:^(NSError *error) {
//        [ShowMessage showMessage:@"网络连接失败！"];
//    }];
    
}


#pragma lazy

- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
    }
    return _netView;
}



@end

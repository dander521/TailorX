//
//  TXPayNoController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPayNoController.h"
#import "TXPayNoCell.h"
#import "TXPayNoView.h"
#import "TXPayNoSuccessController.h"
#import "TXShowWebViewController.h"
#import "TXQueueNoRequestParams.h"
#import "TXMultiPayView.h"
#import "WXApi.h"

@interface TXPayNoController () <TXPayNoViewDelegate, TXMultiPayViewDelegate>

@property (strong, nonatomic) NetErrorView *netView;
@property (nonatomic, weak) TXPayNoView *payView;

@property (nonatomic, assign) NSInteger sortNo;

@property (strong, nonatomic) TXQueueNoModel *selectData;
/** 可用余额*/
@property (nonatomic, strong) NSString *availableBalance;

@end

@implementation TXPayNoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"购买排号";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage *image = [[[ThemeManager shareManager] loadThemeImageWithName:@"ic_nav_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchLeftBarItem)];
    
    TXPayNoView *payView = [TXPayNoView instanse];
    payView.delegate = self;
    payView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight);
    [self.view addSubview:payView];
    self.payView = payView;
    
    payView.data = self.data;
    
    [self getTheUserAccountBalance];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeAlipayCallBack:) name:kNSNotificationAliPaySuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userServeProtocol) name:kNSNotificationProtocol object:nil];
    
    // 微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPaySuccess) name:kNSNotificationWXPaySuccess object:nil];
    
}

#pragma mark - events 

- (void)touchLeftBarItem {
    self.popBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Net Request

/**
 * 获取账户余额
 */
- (void)getTheUserAccountBalance {
    [TXNetRequest homeRequestMethodWithParams:@{@"accountType":@"all"} relativeUrl:findMyBalance completion:^(id responseObject, NSError *error) {
        if (error) {
            return;
        }
        
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                // balance： 余额账户金额 income：收益账户金额
                NSString *balance = responseObject[ServerResponse_data][@"balance"];
                self.availableBalance = balance;
            }else {
                [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
            }
        }
    } isLogin:^{
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - TXPayNoViewDelegate

- (void)payForButtonAction:(TXQueueNoModel *)selectData {
    self.selectData = selectData;
    TXMultiPayView *payView = [TXMultiPayView shareInstanceManager];
    payView.delegate = self;
    payView.totalAccount = [NSString stringWithFormat:@"%f", self.data.amount];
    payView.availableBalance = [self.availableBalance floatValue];
    if (self.data.amount > [self.availableBalance floatValue]) {
        payView.cashButton.hidden = YES;
    }
    [payView show];
}
#pragma mark - TXMultiPayViewDelegate

- (void)touchPayAccountCommitButtonWithPayType:(TXMultiPayViewType)payType {
    TXQueueNoRequestParams *params = [TXQueueNoRequestParams param];
    params.sellUserId = self.data.userId;
    params.amount = self.data.amount;
    params.rankTradeId = self.recordId;
    // 支付类型（0：余额支付，3：支付宝支付 4 :微信）
    if (payType == 1) {
        params.accountType = 3;
    } else if (payType == 2) {
        params.accountType = 0;
    } else {
        params.accountType = 4;
    }
    params.buyRankId = self.selectData.rankId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [strTailorxAPI stringByAppendingString:payRank];
    
    [TXBaseNetworkRequset requestWithURL:url params:params.mj_keyValues success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            if (params.accountType == 0) { //余额
                [MBProgressHUD hideHUDForView:self.view];
                TXPayNoSuccessController *vc = [[TXPayNoSuccessController alloc] init];
                vc.originalNumStr = [NSString stringWithFormat:@"%ld",(long)self.selectData.sortNo];
                vc.presentNumStr = [NSString stringWithFormat:@"%ld",(long)self.data.sortNo];
                vc.payMoneyStr = [NSString stringWithFormat:@"%.2f",self.data.amount];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (params.accountType == 4) {
                NSData *jsonData = [responseObject[kMsg] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                //需要创建这个支付对象
                PayReq *req   = [[PayReq alloc] init];
                //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                req.openID = dic[@"appid"];
                // 商家id，在注册的时候给的
                req.partnerId = dic[@"partnerid"];
                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                req.prepayId  = dic[@"prepayid"];
                // 根据财付通文档填写的数据和签名
                //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
                req.package   = dic[@"package"];
                // 随机编码，为了防止重复的，在后台生成
                req.nonceStr  = dic[@"noncestr"];
                // 这个是时间戳，也是在后台生成的，为了验证支付的
                NSString * stamp = dic[@"timestamp"];
                req.timeStamp = stamp.intValue;
                // 这个签名也是后台做的
                req.sign = dic[@"sign"];
                //发送请求到微信，等待微信返回onResp
                [WXApi sendReq:req];
            } else { // 支付宝
                _sortNo = self.selectData.sortNo;
                [[AlipaySDK defaultService] payOrder:responseObject[ServerResponse_msg] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"%@",resultDic);
                }];
            }
        }else {
            [ShowMessage showMessage:responseObject[kMsg]];
        }
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:error.description];
    } isLogin:^{
        
    }];
}

#pragma mark -  支付成功后回调

- (void)weChatPaySuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 发出购买成功的通知 我的交易 交易列表刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationQueueNoBuySucceed object:nil];
        TXPayNoSuccessController *vc = [[TXPayNoSuccessController alloc] init];
        vc.originalNumStr = [NSString stringWithFormat:@"%ld",_sortNo];
        vc.presentNumStr = [NSString stringWithFormat:@"%ld",(long)self.data.sortNo];
        vc.payMoneyStr = [NSString stringWithFormat:@"%.2f",self.data.amount];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)rechargeAlipayCallBack:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *resultDic = notification.userInfo;
    NSString *message;
    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        // 发出购买成功的通知 我的交易 交易列表刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationQueueNoBuySucceed object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            TXPayNoSuccessController *vc = [[TXPayNoSuccessController alloc] init];
            vc.originalNumStr = [NSString stringWithFormat:@"%ld",_sortNo];
            vc.presentNumStr = [NSString stringWithFormat:@"%ld",(long)self.data.sortNo];
            vc.payMoneyStr = [NSString stringWithFormat:@"%.2f",self.data.amount];
            [self.navigationController pushViewController:vc animated:YES];
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

- (void)userServeProtocol {
    TXShowWebViewController *vwcShow = [TXShowWebViewController new];
    vwcShow.naviTitle = @"TailorX用户服务协议";
    vwcShow.webViewUrl = @"http://cdn.tailorx.cn/ui/pc/tailorx/H5/agreement/agreement.html";
    [self.navigationController pushViewController:vwcShow animated:true];
}

#pragma - lazy

- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
    }
    return _netView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

//
//  TXForPayViewController.m
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXForPayDetailViewController.h"
#import "TXAddressManagerViewController.h"
#import "TXStoreDetailController.h"
#import "TXDesignerDetailController.h"
#import "TXOrderCategoryTableViewCell.h"
#import "TXInQueueOrderDetailViewController.h"
#import "TXOrderReceiveDefaultTableViewCell.h"
#import "TXPersonalMinusMarginTableViewCell.h"
#import "TXAvatarTableViewCell.h"
#import "TXPayCountTableViewCell.h"
#import "TXAddressTableViewCell.h"
#import "TXOrderTableViewCell.h"
#import "TXAccountDetailTableViewCell.h"
#import "TXOrderHeaderView.h"
#import "TXPayBottomView.h"
#import "TXMultiPayView.h"
#import "TXOrderDetailModel.h"
#import "TXPayOrderModel.h"
#import "TXBlankView.h"
#import "WXApi.h"

@interface TXForPayDetailViewController () <UITableViewDelegate, UITableViewDataSource, TXPayBottomViewDelegate, TXOrderTableViewCellDelegate, NetErrorViewDelegate, TXMultiPayViewDelegate, TXOrderHeaderViewDelegate>

/** TableView */
@property (nonatomic, strong) UITableView *payTableView;
/** 详情对象 */
@property (nonatomic, strong) TXOrderDetailModel *orderDetail;
/** 支付对象 */
@property (nonatomic, strong) TXPayOrderModel *payOrder;
/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 选择地址 */
@property (nonatomic, strong) TXAddressModel *selectedAdress;
/** 支付参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 可用余额*/
@property (nonatomic, strong) NSString *availableBalance;
/** 底部视图*/
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation TXForPayDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加通知
    [self addAddressNotification];
    // 设置控制器属性
    [self configViewController];
    // 初始化tableView
    [self setUpContentTableView];
    // 添加底部view
    [self.view addSubview:self.bottomView];
    // 获取用户余额
    [self getTheUserAccountBalance];
    // 网络请求获取订单列表
    [self getOrderDetailDataFromServer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

/**
 添加通知
 */
- (void)addAddressNotification {
    // 阿里支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeAlipayCallBack:) name:kNSNotificationAliPaySuccess object:nil];
    // 微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPaySuccess) name:kNSNotificationWXPaySuccess object:nil];
    // 选择收货地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectReceiverAddress:) name:kNSNotificationSelectUserAddress object:nil];
    // 删除收货地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReceiveAddress:) name:kNSNotificationChangeUserAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderInvalid:) name:kNSNotificationOrderInvalid object:nil];
}

#pragma mark - Net Request

/**
 *  获取账户余额
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
                NSLog(@"balance = %@",balance);
                self.availableBalance = balance;
            }else {
                [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
            }
        }
    } isLogin:^{
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}



/**
 设置订单配送方式
 */
- (void)saveOrderDeliveryTypeWithParams:(NSMutableDictionary *)params {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:params
                                        relativeUrl:strOrderSavaDeliveryType success:^(id responseObject) {
                                            if ([responseObject[ServerResponse_success] boolValue]) {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeDeliverySuccess object:nil userInfo:params];
                                                [self.payTableView reloadData];
                                            } else if ([responseObject[ServerResponse_code] integerValue] == ServerResponse_notSetAddress) {
                                                [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                                [self.payTableView reloadData];
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


/**
 判断订单是否失效
 */
- (void)judgeInvalidOrder {
    if (self.orderStatus == TXOrderStatusForPay && (int)self.orderDetail.remainTime/1000 < 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [TXNetRequest userCenterRequestMethodWithParams:@{@"orderNo" : self.orderDetail.orderNo}
                                            relativeUrl:strOrderInvalid success:^(id responseObject) {
                                                if ([responseObject[ServerResponse_success] boolValue]) {
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationOrderInvalid object:nil userInfo:nil];
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

/**
 * 网络请求获取订单列表
 */
- (void)getOrderDetailDataFromServer {
    [self.netView showAddedTo:self.view isClearBgc:false];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.orderId forKey:ServerParams_orderNo];
    [TXNetRequest userCenterRequestMethodWithParams:params
                                   relativeUrl:strOrderDetail
                                    success:^(id responseObject) {
                                        if ([responseObject[ServerResponse_success] boolValue]) {
                                            [self.netView stopNetViewLoadingFail:false error:false];
                                            
                                            if (responseObject) {
                                                if (responseObject[ServerResponse_data]) {
                                                    self.orderDetail = [TXOrderDetailModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
                                                    // 判断订单是否失效
                                                    [self judgeInvalidOrder];
                                                }
                                            }
                                            [self.payTableView reloadData];
                                        } else {
                                            [self.netView stopNetViewLoadingFail:false error:true];
                                        }
                                    } failure:^(NSError *error) {
                                        [self.netView stopNetViewLoadingFail:true error:false];
                                    } isLogin:^{
                                        [self.netView stopNetViewLoadingFail:false error:true];
                                        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                    }];
}


- (void)deleteOrder {
    weakSelf(self);
    [UIAlertController showAlertWithTitle:nil msg:@"您确定要取消本次订单吗？" actionsMsg:@[@"取消",@"确定"] buttonActions:^(NSInteger index) {
        if (index == 1) {
            NSMutableDictionary *dict = [@{} mutableCopy];
            [dict setValue:weakSelf.orderDetail.orderNo forKey:@"orderNo"];
            [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeCancelAppointment completion:^(id responseObject, NSError *error) {
                if (responseObject) {
                    if ([responseObject[kSuccess] boolValue]) {
                        [ShowMessage showMessage:@"取消成功"  withCenter:weakSelf.view.center];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationDeleteOrderSuccess object:nil userInfo:nil];
                        [self.navigationController popViewControllerAnimated:true];
                    } else {
                        [ShowMessage showMessage:responseObject[kMsg]  withCenter:weakSelf.view.center];
                    }
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                }else {
                    [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                }
            }isLogin:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
            }];
        }
    } target:self];
}

#pragma mark - Initial

/**
 * 设置控制器属性
 */
- (void)configViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = LocalSTR(@"Str_OrderDetail");
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.payTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.01, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - kTopHeight) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.estimatedRowHeight = TableViewOrderCellEstimatedRowHeight;
        tableView.rowHeight = UITableViewAutomaticDimension;
        // 适配iOS11group类型显示问题
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.payTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) return 3;
    if (section == 1 && [self isSetDelivery]) return 2;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [self configCountDownCell];
    } else if (indexPath.section == 1) {
        cell = [self configReceiveInfoCellWithIndexPath:indexPath];
    } else {
        if (indexPath.row == 0) {
            cell = [self configOrderCategory];
        } else if (indexPath.row == 1) {
            cell = [self configOrderInfoCell];
        } else {
            cell = [self configOrderAccountDetailCell];
        }
    }
    
    return cell;
}

- (TXSeperateLineCell *)configCountDownCell {
    TXPayCountTableViewCell *countCell = [TXPayCountTableViewCell cellWithTableView:self.payTableView];
    if (![self isOrderValiad]) {
        countCell.cellType = TXPayCountTableViewCellTypeInvalide;
    } else {
        countCell.orderCreatTime = (int)self.orderDetail.remainTime/1000;
        countCell.cellType = TXPayCountTableViewCellTypeValide;
    }
    return countCell;
}
- (TXSeperateLineCell *)configReceiveInfoCellWithIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cell = nil;
    
    if (indexPath.row == 0) {
        TXOrderReceiveDefaultTableViewCell *defaultCell = [TXOrderReceiveDefaultTableViewCell cellWithTableView:self.payTableView];
        defaultCell.accessoryView = [defaultCell setCustomAccessoryView];
        defaultCell.cellLineType = [self isSetDelivery] ?  TXCellSeperateLinePositionType_Single : TXCellSeperateLinePositionType_None;

        defaultCell.logisticCompanyLabel.font = FONT(13);
        defaultCell.logisticCompanyLabel.textColor = RGB(108, 108, 108);
        defaultCell.logisticNoLabel.font = FONT(14);
        defaultCell.logisticNoLabel.textColor = RGB(108, 108, 108);

        if (![self isSetDelivery]) {
            if ([self isOrderValiad]) {
                defaultCell.logisticNoLabel.text = @"未选择";
                defaultCell.logisticNoLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
            } else {
                defaultCell.logisticNoLabel.text = @"";
            }
        } else {
            defaultCell.logisticNoLabel.text = self.orderDetail.delivery == TXOrderDeliveryTypeGetSelf ? @"到店自取" : @"快递运送";
        }
        defaultCell.logisticCompanyLabel.text = @"配送方式";
        if (![self isOrderValiad]) {
            defaultCell.accessoryView = nil;
            defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell = defaultCell;
    } else if (indexPath.row == 1) {
        TXAddressTableViewCell *addressCell = [TXAddressTableViewCell cellWithTableView:self.payTableView];
        addressCell.cellType = self.orderDetail.delivery == TXOrderDeliveryTypeGetSelf ? TXAddressTypeOnlyStoreAddress :TXAddressTypeDefault;
        addressCell.accessoryView = [addressCell setCustomAccessoryView];
        addressCell.cellLineType = TXCellSeperateLinePositionType_None;
        
        if (self.orderDetail.delivery == TXOrderDeliveryTypeGetSelf) {
            [addressCell configAddressWithName:self.orderDetail.storeName
                                      phoneNum:self.orderDetail.storePhone
                                       address:self.orderDetail.storeAddress == nil ? @"暂时无法获取到地址" : self.orderDetail.storeAddress];
        } else {
            [addressCell configAddressWithName:self.selectedAdress.name != nil ? self.selectedAdress.name : (self.orderDetail.deliveryAddress.name == nil ? @"请选择收货地址" : self.orderDetail.deliveryAddress.name)
                                      phoneNum:self.selectedAdress.telephone != nil ? self.selectedAdress.telephone : self.orderDetail.deliveryAddress.telephone
                                       address:[self.selectedAdress combineUserAddress] != nil ? [self.selectedAdress combineUserAddress] : ([NSString isTextEmpty:[self.orderDetail combineUserAddress]] ? @"请选择收货地址" : [self.orderDetail combineUserAddress])];
        }
        
        if (![self isOrderValiad] || self.orderDetail.delivery == TXOrderDeliveryTypeGetSelf) {
            addressCell.accessoryView = nil;
            addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell = addressCell;
    }
    return cell;
}

- (TXSeperateLineCell *)configOrderCategory {
    TXOrderCategoryTableViewCell *categoryCell = [TXOrderCategoryTableViewCell cellWithTableView:self.payTableView];
    categoryCell.categoryLabel.text = self.orderDetail.orderNo;
    categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return categoryCell;
}

- (TXSeperateLineCell *)configOrderInfoCell {
    TXOrderTableViewCell *orderCell = [TXOrderTableViewCell cellWithTableView:self.payTableView];
    orderCell.cellType = TXOrderStatusContactStore;
    orderCell.cellLineType = TXCellSeperateLinePositionType_None;
    orderCell.delegate = self;
    [orderCell configOrderCellWithOrderModel:[self.orderDetail convertOrderDetailModelToOrderModel] isAllOrderCell:false];
    orderCell.dressQueueNoLabel.text = @"";
    return orderCell;
}

- (TXSeperateLineCell *)configOrderAccountDetailCell {
    TXAccountDetailTableViewCell *detailCell = [TXAccountDetailTableViewCell cellWithTableView:self.payTableView];
    if (![self isOrderValiad]) {
        detailCell.cellType = TXAccountDetailTableViewCellTypeInvalid;
        detailCell.depositAccountLabel.text = [NSString stringWithFormat:@"￥ %@", self.orderDetail.deposit];
    } else {
        detailCell.cellType = TXAccountDetailTableViewCellTypeValid;
        detailCell.depositAccountLabel.text = [NSString stringWithFormat:@"- ￥ %@", self.orderDetail.deposit];
        detailCell.actualLabel.text = [NSString stringWithFormat:@"￥ %.2f", [self.orderDetail.totalAmount floatValue] - [self.orderDetail.deposit floatValue]];
    }
    detailCell.totalLabel.text = [NSString stringWithFormat:@"￥ %.2f", [self.orderDetail.totalAmount floatValue]];
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    detailCell.originPriceLabel.hidden = true;
    detailCell.originLineLabel.hidden = true;
    if ([NSString isTextEmpty:self.orderDetail.totalListPrice] || [self.orderDetail.totalListPrice floatValue] == 0 || [self.orderDetail.totalListPrice floatValue] == [self.orderDetail.totalAmount floatValue]) {
        detailCell.payOriginPriceLabel.hidden = true;
        detailCell.payOriginLineLabel.hidden = true;
    } else {
        detailCell.payOriginPriceLabel.hidden = false;
        detailCell.payOriginLineLabel.hidden = false;
        detailCell.payOriginPriceLabel.text = [NSString stringWithFormat:@"￥ %.2f", [self.orderDetail.totalListPrice floatValue]];
    }
    
    detailCell.cellLineType = TXCellSeperateLinePositionType_None;
    return detailCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if ([self isOrderValiad]) {
        if (self.orderDetail.delivery == TXOrderDeliveryTypeDelivery && indexPath.section == 1 && indexPath.row == 1) {
            TXAddressManagerViewController *vwcManager = [TXAddressManagerViewController new];
            // 需求调整 进入选择地址页面 不可进行编辑操作
            vwcManager.isEditAddress = false;
            [self.navigationController pushViewController:vwcManager animated:true];
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            // 点击配送方式
            [self touchDeliveredTypeCell];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        TXOrderHeaderView *headerView = [TXOrderHeaderView instanceView];
        headerView.delegate = self;
        headerView.headerStoreType = TXOrderHeaderStoreTypeEnable;
        headerView.headerType = TXOrderHeaderTypeDismiss;
        headerView.storeLabel.text = self.orderDetail.storeName;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) return 50.0;
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) return 44.0;
    if (indexPath.section == 2 && indexPath.row == 1) return UITableViewAutomaticDimension;
    if (indexPath.section == 2 && indexPath.row == 2 && ![self isOrderValiad]) return 77;
    if (indexPath.section == 2 && indexPath.row == 2 && [self isOrderValiad]) return 126;
    if (indexPath.section == 0) return 213;
    return UITableViewAutomaticDimension;
}

#pragma mark - TXOrderHeaderViewDelegate

- (void)touchHeaderViewStoreButton {
    TXStoreDetailController *vwcStore = [TXStoreDetailController new];
    vwcStore.storeid = self.orderDetail.storeId;
    vwcStore.isHidden = true;
    [self.navigationController pushViewController:vwcStore animated:true];
}

#pragma mark - TXPayBottomViewDelegate

/**
 *  点击支付订单按钮
 */
- (void)touchPayAccountButton {
    // 添加失效订单状态为7的判断 7：已退款余额
    if ((int)self.orderDetail.remainTime/1000 <= 0 || ![self isOrderValiad]) {
        [self touchContactStore];
        return;
    }
    
    if (self.orderDetail.delivery == TXOrderDeliveryTypeDelivery && self.orderDetail.deliveryAddress.idField == 0 && self.selectedAdress.idField == 0) {
        [ShowMessage showMessage:@"请添加你的收货地址" withCenter:self.view.center];
        return;
    }
    
    if (self.orderDetail.delivery == 0) {
        [ShowMessage showMessage:@"请选择配送方式" withCenter:self.view.center];
        return;
    }
    
    TXMultiPayView *payView = [TXMultiPayView shareInstanceManager];
    payView.delegate = self;
    payView.totalAccount = [NSString stringWithFormat:@"%.2f", [self.orderDetail.totalAmount floatValue] - [self.orderDetail.deposit floatValue]];
    payView.availableBalance = [self.availableBalance floatValue];
    if ([self.orderDetail.deposit floatValue] > [self.availableBalance floatValue]) {
        payView.cashButton.hidden = YES;
    }
    [payView show];
}

#pragma mark - TXMultiPayViewDelegate

- (void)touchPayAccountCommitButtonWithPayType:(TXMultiPayViewType)payType {
    self.orderDetail.payMethod = payType;

    self.params = [NSMutableDictionary new];
    [self.params setValue:self.orderDetail.orderNo forKey:ServerParams_orderNo];
    [self.params setValue:[NSString stringWithFormat:@"%ld", (long)self.orderDetail.payMethod] forKey:ServerParams_payMethod];
    
    [self.params setValue:[NSString stringWithFormat:@"%.2f", [self.orderDetail.totalAmount floatValue] - [self.orderDetail.deposit floatValue]] forKey:ServerParams_amount];
    [self.params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)TXOrderPayAmountSingle] forKey:ServerParams_orderPayQuantity];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:self.params
                                   relativeUrl:strOrderPay
                                    success:^(id responseObject) {
                                        if ([responseObject[ServerResponse_success] boolValue]) {
                                            [MBProgressHUD hideHUDForView:self.view];
                                            // 支付宝
                                            if (self.orderDetail.payMethod == 1) {
                                                [[AlipaySDK defaultService] payOrder:responseObject[ServerResponse_msg] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                                                    
                                                    
                                                }];
                                            } else if (self.orderDetail.payMethod == 3) {
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
                                            } else {
                                                [MBProgressHUD hideHUDForView:self.view];
                                                [ShowMessage showMessage:@"支付成功" withCenter:self.view.center];
                                                
                                                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0];
                                            }
                                            
                                        } else {
                                            [MBProgressHUD hideHUDForView:self.view];
                                            if (![NSString isTextEmpty:responseObject[ServerResponse_code]]) {
                                                if ([responseObject[ServerResponse_code] integerValue] == ServerResponse_codeNotEnoughCash) {
                                                    [ShowMessage showMessage:@"余额不足" withCenter:self.view.center];
                                                } else {
                                                    [ShowMessage showMessage:@"支付未成功" withCenter:self.view.center];
                                                }
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

#pragma mark - Custom Method

- (void)weChatPaySuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShowMessage showMessage:@"支付成功" withCenter:self.view.center];
        
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0];
    });
}

/**
 *  点击cell 按钮
 */
- (void)touchContactStore {
    // 联系门店
    [TXCustomTools callStoreWithPhoneNo:self.orderDetail.storePhone target:self];
}

/**
 支付宝支付 回调

 @param notification
 */
- (void)rechargeAlipayCallBack:(NSNotification *)notification {
    
    NSDictionary *resultDic = notification.userInfo;
    NSString *message;
    
    if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeSuccess]) { // 充值成功后
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShowMessage showMessage:@"支付成功" withCenter:self.view.center];
            
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0];
        });
    } else {
        if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeDealing]) {
            message = @"正在处理中";
        }
        else if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeFail]) {
            message = @"订单支付失败";
        }
        else if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeCancel]) {
            message = @"用户中途取消";
        }
        else {
            message = @"订单支付失败";
        }
        [ShowMessage showMessage:@"支付未成功" withCenter:self.view.center];
    }
}

- (void)delayMethod {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:false];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationPayOrderSuccess object:nil userInfo:@{@"orderNo" : self.orderId}];
    });
}

/**
 选择收货地址
 
 @param notificaiton
 */
- (void)selectReceiverAddress:(NSNotification *)notificaiton {
    self.selectedAdress = (TXAddressModel *)notificaiton.object;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.orderDetail.orderNo forKey:@"orderNo"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.orderDetail.delivery] forKey:@"deliveryType"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.selectedAdress.idField] forKey:@"customerAddressId"];
    
    [self saveOrderDeliveryTypeWithParams:params];
}

- (void)deleteReceiveAddress:(NSNotification *)notificaiton {
    if ((TXAddressModel *)notificaiton.object == nil) {
        return;
    }
    
    if (((TXAddressModel *)notificaiton.object).idField == self.selectedAdress.idField) {
        self.selectedAdress = nil;
        [self.payTableView reloadData];
    }
}

- (void)orderInvalid:(NSNotification *)notificaiton {
    self.orderStatus = 7;
    [self.payTableView reloadData];
    
    UIButton *payBtn = (UIButton*)[self.view viewWithTag:100];
    payBtn.layer.borderColor = RGB(46, 46, 46).CGColor;
    [payBtn setTitle:@"联系门店" forState:UIControlStateNormal];
    [payBtn setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    
    UIButton *contactBtn = (UIButton*)[self.view viewWithTag:101];
    contactBtn.hidden = YES;
}

/**
 * 点击配送方式
 */
- (void)touchDeliveredTypeCell {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    // 货到付款
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"快递运送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.orderDetail.delivery = TXOrderDeliveryTypeDelivery;
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:weakSelf.orderDetail.orderNo forKey:@"orderNo"];
        [params setValue:[NSString stringWithFormat:@"%zd", weakSelf.orderDetail.delivery] forKey:@"deliveryType"];
        
        [self saveOrderDeliveryTypeWithParams:params];
    }];
    
    // 到店自取
    UIAlertAction *getAction = [UIAlertAction actionWithTitle:@"到店自取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.orderDetail.delivery = TXOrderDeliveryTypeGetSelf;
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:weakSelf.orderDetail.orderNo forKey:@"orderNo"];
        [params setValue:[NSString stringWithFormat:@"%zd", weakSelf.orderDetail.delivery] forKey:@"deliveryType"];
        [self saveOrderDeliveryTypeWithParams:params];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:payAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:getAction];
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    
    [avatarAlert addAction:payAction];
    [avatarAlert addAction:getAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

/**
 是否订单有效
 
 @return
 */
- (BOOL)isOrderValiad {
    return self.orderStatus != 8 && self.orderStatus != 7;
}

/**
 是否设置过配送方式

 @return
 */
- (BOOL)isSetDelivery {
    return self.orderDetail.delivery != 0;
}

#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
- (void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self getOrderDetailDataFromServer];
}


#pragma mark - Lazy 

/**
 错误页

 @return 
 */
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        _netView.delegate = self;
    }
    return _netView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-kTopHeight, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowOffset = CGSizeMake(1, 1);
        _bottomView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
        _bottomView.layer.shadowOpacity = 0.5;
        if ([self isOrderValiad]) {
            // 去支付
            UIButton *payBtn = [UIButton buttonWithTitle:@"去支付" textColor:RGB(255, 51, 102) font:13 superView:_bottomView];
            payBtn.layer.borderColor = RGB(255, 51, 102).CGColor;
            payBtn.layer.cornerRadius = 3;
            payBtn.layer.borderWidth = 0.6f;
            payBtn.frame = CGRectMake(SCREEN_WIDTH-72.5-15, 10, 72.5, 30);
            payBtn.tag = 100;
            [payBtn addTarget:self action:@selector(touchPayAccountButton) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:payBtn];
            
            // 联系门店
            UIButton *contactStore = [UIButton buttonWithTitle:@"联系门店" textColor:RGB(46, 46, 46) font:13 superView:_bottomView];
            contactStore.layer.borderColor = RGB(46, 46, 46).CGColor;
            contactStore.layer.cornerRadius = 3;
            contactStore.layer.borderWidth = 0.6f;
            contactStore.tag = 101;
            contactStore.frame = CGRectMake(SCREEN_WIDTH-72.5*2-15-20, 10, 72.5, 30);
            [contactStore addTarget:self action:@selector(touchContactStore) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:contactStore];
            
//            // 删除订单
//            UIButton *cancellationBtn = [UIButton buttonWithTitle:@"取消订单" textColor:RGB(153, 153, 153) font:13 superView:_bottomView];
//            cancellationBtn.layer.borderColor = RGB(153, 153, 153).CGColor;
//            cancellationBtn.layer.cornerRadius = 3;
//            cancellationBtn.layer.borderWidth = 0.6f;
//            cancellationBtn.frame = CGRectMake(SCREEN_WIDTH-72.5*3-15-40, 10, 72.5, 30);
//            [cancellationBtn addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
//            [_bottomView addSubview:cancellationBtn];
        } else {
            // 联系门店
            UIButton *contactStore = [UIButton buttonWithTitle:@"联系门店" textColor:RGB(46, 46, 46) font:13 superView:_bottomView];
            contactStore.layer.borderColor = RGB(46, 46, 46).CGColor;
            contactStore.layer.cornerRadius = 3;
            contactStore.layer.borderWidth = 0.6f;
            contactStore.tag = 101;
            contactStore.frame = CGRectMake(SCREEN_WIDTH-72.5-15, 10, 72.5, 30);
            [contactStore addTarget:self action:@selector(touchContactStore) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:contactStore];
        }
    }
    return _bottomView;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  TXOrdersDisplayViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/4.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXOrdersDisplayViewController.h"
#import "TXLogisticsDetailViewController.h"
#import "TXInputCommentViewController.h"
#import "TXQueueNoViewController.h"
#import "TXForPayDetailViewController.h"
#import "TXForPayDetailViewController.h"
#import "TXCommentDetailViewController.h"
#import "TXProcessNodeViewController.h"
#import "TXAppointmentDetailViewController.h"
#import "TXInProductDetailViewController.h"
#import "TXInQueueOrderDetailViewController.h"
#import "TXForReceiveDetailViewController.h"
#import "TXForCommentDetailViewController.h"
#import "TXAllDetailViewController.h"
#import "TXTradeQueueNoController.h"
#import "TXOrderTableViewCell.h"
#import "TXOrderHeaderView.h"
#import "AppDelegate.h"
#import "TXBlankView.h"
#import "TXOrderModel.h"

@interface TXOrdersDisplayViewController () <UITableViewDelegate, UITableViewDataSource, TXOrderTableViewCellDelegate, NetErrorViewDelegate>
/** TableView */
@property (nonatomic, strong) UITableView *orderTableView;
/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger pageLength;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 无数据提示页面 */
@property (nonatomic, strong) TXBlankView *blankView;
/** 第一次获取数据 */
@property (nonatomic, assign) BOOL isFirstPostData;
/** 订单数据模型 */
@property (nonatomic, strong) TXAllServerOrdersModel *ordersModel;

@end

@implementation TXOrdersDisplayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    adjustsScrollViewInsets_NO(self.orderTableView, self);
    // 初始化tableView
    [self setUpContentTableView];
    // 初始化变量
    [self initialVariables];
    [self.netView showAddedTo:self.view isClearBgc:false];
    // 网络请求获取订单列表
    [self getAllOrdersDataFromServer];
    // 2017-4-12 程荣刚：添加支付成功通知
    [self addNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 处理tabbar切换 遮盖问题
    self.navigationController.navigationBarHidden = false;
    // 处理pop回来 遮盖问题
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
}

#pragma mark - Net Request

/**
 * 下拉刷新
 */
- (void)loadNewData {
    _page = DefaultPageNumber;
    
    [self getAllOrdersDataFromServer];
    [_orderTableView.mj_footer endRefreshing];
    [_orderTableView.mj_footer setState:MJRefreshStateIdle];
}

/**
 * 上拉加载更多
 */
- (void)loadMoreData {
    _page += 1;
    
    if (_dataCount < _pageLength) {
        [_orderTableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self getAllOrdersDataFromServer];
    }
}

/**
 * 网络请求获取订单列表
 */
- (void)getAllOrdersDataFromServer {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[NSString stringWithFormat:@"%zd", TXOrderParamsTypeAll] forKey:ServerParams_type];
    [params setValue:[NSString stringWithFormat:@"%zd", _page] forKey:ServerParams_page];
    [params setValue:[NSString stringWithFormat:@"%zd", _pageLength] forKey:ServerParams_pageLength];
//    if (_isFirstPostData == false) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    }
    [TXNetRequest userCenterRequestMethodWithParams:params
                                        relativeUrl:strOrderList
                                            success:^(id responseObject) {
                                                if ([responseObject[ServerResponse_success] boolValue]) {
                                                    _isFirstPostData = false;
                                                    [self.netView stopNetViewLoadingFail:false error:false];
                                                    if (_page == 0) {
                                                        [self.ordersModel.data removeAllObjects];
                                                    }
                                                    if (responseObject) {
                                                        if (responseObject[ServerResponse_data]) {
                                                            TXAllServerOrdersModel *ordersServerModel = [TXAllServerOrdersModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
                                                            _dataCount = ordersServerModel.data.count;
                                                            if (_dataCount > 0) {
                                                                [self.ordersModel.data addObjectsFromArray:ordersServerModel.data];
                                                            }
                                                        }
                                                    }
                                                    
                                                    if (self.ordersModel.data.count == 0) {
                                                        [self showBlankView];
                                                    } else {
                                                        [self.blankView removeFromSuperview];
                                                        if (_dataCount < _pageLength) {
                                                            [_orderTableView.mj_footer setState:MJRefreshStateNoMoreData];
                                                        }
                                                    }
                                                    [self.orderTableView reloadData];
                                                } else {
                                                    if (_page > 0) {
                                                        _page -= 1;
                                                    }
                                                    if (!_isFirstPostData) {
                                                        [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                                    }
                                                    
                                                    [self.netView stopNetViewLoadingFail:false error:true];
                                                }
//                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                [_orderTableView.mj_header endRefreshing];
                                                [_orderTableView.mj_footer endRefreshing];
                                            } failure:^(NSError *error) {
                                                if (_page > 0) {
                                                    _page -= 1;
                                                }
                                                if (!_isFirstPostData) {
                                                    [ShowMessage showMessage:kErrorTitle withCenter:self.view.center];
                                                }
                                                
                                                [self.netView stopNetViewLoadingFail:true error:false];
//                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                [_orderTableView.mj_header endRefreshing];
                                                [_orderTableView.mj_footer endRefreshing];
                                            } isLogin:^{
                                                [_orderTableView.mj_header endRefreshing];
                                                [_orderTableView.mj_footer endRefreshing];
                                                [self.netView stopNetViewLoadingFail:NO error:YES];
                                                [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                            }];
}


#pragma mark - Notification

/**
 添加通知
 */
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderSuccess:) name:kNSNotificationPayOrderSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCommentSuccess:) name:kNSNotificationCommentSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderSuccess:) name:kNSNotificationReceiveSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderSuccess:) name:kNSNotificationDeleteOrderSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderSuccess:) name:kNSNotificationOrderInvalid object:nil];
}

#pragma mark - Initial Method

/**
 初始化变量
 */
- (void)initialVariables {
    _page = DefaultPageNumber;
    _pageLength = DefaultPageLength;
    _dataCount = DefaultDataCount;
    _isFirstPostData = true;
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.orderTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) style:UITableViewStyleGrouped];

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.orderTableView];
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.orderTableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.orderTableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ordersModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXOrderTableViewCell *cell = [TXOrderTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    TXOrderModel *model = self.ordersModel.data[indexPath.section];
    [cell configOrderCellWithOrderModel:model isAllOrderCell:true];
    
    cell.cellLineRightMargin = TXCellRightMarginType131;
    cell.cellLineType = TXCellSeperateLinePositionType_None;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    TXOrderModel *orderModel = self.ordersModel.data[indexPath.section];
    UIViewController<ZJScrollPageViewChildVcDelegate> *baseVC = nil;
    switch ([orderModel.status integerValue]) {
        case TXOrderStatusForPay: {
            TXForPayDetailViewController *vwcPay = [TXForPayDetailViewController new];
            vwcPay.orderId = orderModel.orderNo;
            vwcPay.orderStatus = [orderModel.status integerValue];
            baseVC = vwcPay;
        }
            break;
            
        case TXOrderStatusInQueue: {
            TXInQueueOrderDetailViewController *vwcQueue = [TXInQueueOrderDetailViewController new];
            vwcQueue.orderId = orderModel.orderNo;
            baseVC = vwcQueue;
        }
            break;
            
        case TXOrderStatusInProduct: {
            TXInProductDetailViewController *vwcProduct = [TXInProductDetailViewController new];
            vwcProduct.orderId = orderModel.orderNo;
            baseVC = vwcProduct;
        }
            break;
            
        case TXOrderStatusForReceiveDelivered:
        case TXOrderStatusForReceiveGetBySelf:
        case TXOrderStatusForReceiveWaitDeliver:{
            TXForReceiveDetailViewController *vwcReceive = [TXForReceiveDetailViewController new];
            vwcReceive.orderId = orderModel.orderNo;
            if (orderModel.delivery == 0) {
                vwcReceive.orderStatus = [orderModel.status integerValue];
            }
            baseVC = vwcReceive;
        }
            break;
            
        case TXOrderStatusForComment:
        case TXOrderStatusCommented: {
            TXForCommentDetailViewController *vwcComment = [TXForCommentDetailViewController new];
            vwcComment.orderId = orderModel.orderNo;
            vwcComment.orderStatus = [orderModel.status integerValue];
            baseVC = vwcComment;
        }
            break;
            
        case TXOrderStatusInvalidHasDeposit:
        case TXOrderStatusInvalidNoDeposit: {
            TXForPayDetailViewController *vwcPay = [TXForPayDetailViewController new];
            vwcPay.orderId = orderModel.orderNo;
            vwcPay.orderStatus = [orderModel.status integerValue];
            baseVC = vwcPay;
        }
            break;
            
        case TXOrderStatusAppointmentSuccess:
        case TXOrderStatusAppointmentCancel: {
            TXAppointmentDetailViewController *vwcAppointment = [TXAppointmentDetailViewController new];
            vwcAppointment.appointmentNo = orderModel.orderNo;
            weakSelf(self);
            vwcAppointment.block = ^(){
                [weakSelf.orderTableView.mj_header beginRefreshing];
            };
            baseVC = vwcAppointment;
        }
            break;
            
        default:
            break;
    }
    
    [TXCustomTools pushContainerVCWithParentVC:self childVC:baseVC orderNo:orderModel.orderNo indexPage:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TableViewOrderCellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.ordersModel.data.count != 0 && self.ordersModel.data.count != section + 1) return TableViewOrderCellFooterHeight;
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}

#pragma mark - TXOrderTableViewCellDelegate

/**
 *  点击cell 按钮
 */
- (void)touchActionButtonWithOrder:(TXOrderModel *)order {
    switch ([order.status integerValue]) {
        case TXOrderStatusForPay:
        {
            TXForPayDetailViewController *vwcPay = [TXForPayDetailViewController new];
            vwcPay.orderId = order.orderNo;
            vwcPay.orderStatus = [order.status integerValue];
            [TXCustomTools pushContainerVCWithParentVC:self childVC:vwcPay orderNo:order.orderNo indexPage:0];
        }
            break;
            
        case TXOrderStatusInQueue:
        {
            TXTradeQueueNoController *vwcQueue = [TXTradeQueueNoController new];
            vwcQueue.isQuickProduce = true;
            [self.navigationController pushViewController:vwcQueue animated:true];
        }
            break;
            
        case TXOrderStatusForReceiveWaitDeliver:
        {
            [UIAlertController showAlertWithTitle:@"" message:@"您确认收到为您量身定制的服装了吗？" actionsMsg:@[@"确认收到", @"没有收到"] buttonActions:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    NSMutableDictionary *params = [NSMutableDictionary new];
                    [params setValue:order.orderNo forKey:@"orderNo"];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [TXNetRequest userCenterRequestMethodWithParams:params
                                                        relativeUrl:strOrderConfirmReceive
                                                            success:^(id responseObject) {
                                                                if ([responseObject[ServerResponse_success] boolValue]) {
                                                                    [MBProgressHUD hideHUDForView:self.view];
                                                                    TXInputCommentViewController *vwcComment = [TXInputCommentViewController new];
                                                                    vwcComment.orderNo = order.orderNo;
                                                                    [self.navigationController pushViewController:vwcComment animated:true];
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationReceiveSuccess object:nil];
                                                                } else {
                                                                    [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                                                }
                                                                [MBProgressHUD hideHUDForView:self.view];
                                                            } failure:^(NSError *error) {
                                                                [ShowMessage showMessage:error.description withCenter:self.view.center];
                                                                [MBProgressHUD hideHUDForView:self.view];
                                                            } isLogin:^{
                                                                [self.netView stopNetViewLoadingFail:NO error:YES];
                                                                [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                                            }];
                }
            } target:self];
        }
            break;
            
        case TXOrderStatusAppointmentSuccess: {
            // 联系门店
            [TXCustomTools callStoreWithPhoneNo:order.storePhone target:self];
        }
            break;
            
        case TXOrderStatusForComment:
        {
            TXInputCommentViewController *vwcComment = [TXInputCommentViewController new];
            vwcComment.orderNo = order.orderNo;
            [self.navigationController pushViewController:vwcComment animated:true];
        }
            break;
            
        case TXOrderStatusCommented: {
            TXCommentDetailViewController *vwcComment = [TXCommentDetailViewController new];
            vwcComment.orderId = order.orderNo;
            [self.navigationController pushViewController:vwcComment animated:true];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  待收货状态点击 查看物流 按钮
 */
- (void)touchLogisticButtonWithOrder:(TXOrderModel *)order {
    
    switch ([order.status integerValue]) {
        case TXOrderStatusForReceiveWaitDeliver: {
            TXLogisticsDetailViewController *vwcLogistic = [TXLogisticsDetailViewController new];
            vwcLogistic.orderId = order.orderNo;
            [self.navigationController pushViewController:vwcLogistic animated:true];
        }
            break;
            
        case TXOrderStatusForComment:
        case TXOrderStatusCommented:
        case TXOrderStatusInvalidHasDeposit:
        case TXOrderStatusInvalidNoDeposit: {
            [UIAlertController showAlertWithTitle:nil msg:@"您确定要删除本次订单吗？" actionsMsg:@[@"取消",@"确定"] buttonActions:^(NSInteger i) {
                if (i==1) {
                    NSMutableDictionary *dict = [@{}mutableCopy];
                    [dict setValue:order.orderNo forKey:@"orderNo"];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    // 删除订单
                    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeDeleteAppointment completion:^(id responseObject, NSError *error) {
                        if (error) {
                            [ShowMessage showMessage:error.localizedDescription];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            return ;
                        }
                        if (responseObject) {
                            [_orderTableView.mj_header beginRefreshing];
                            [ShowMessage showMessage:responseObject[kMsg]];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }
                    }isLogin:^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                    }];
                }
            } target:self];
        }
            break;
            
        case TXOrderStatusAppointmentCancel: {
            [UIAlertController showAlertWithTitle:nil msg:@"您确定要删除本次预约吗？" actionsMsg:@[@"取消",@"确定"] buttonActions:^(NSInteger i) {
                if (i==1) {
                    NSMutableDictionary *dict = [@{}mutableCopy];
                    [dict setValue:order.orderNo forKey:@"orderNo"];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    // 删除订单
                    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeDeleteAppointment completion:^(id responseObject, NSError *error) {
                        if (error) {
                            [ShowMessage showMessage:error.localizedDescription];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            return ;
                        }
                        if (responseObject) {
                            [self.orderTableView.mj_header beginRefreshing];
                            [ShowMessage showMessage:responseObject[kMsg]];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }
                    }isLogin:^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                    }];
                }
            } target:self];
        }
            break;
            
        default:
            break;
    }
}

- (void)touchProcessButtonWithOrder:(TXOrderModel *)order {
//    TXProcessNodeViewController *vwcProcess = [TXProcessNodeViewController new];
//    vwcProcess.orderNo = order.orderNo;
//    vwcProcess.isInsert = YES;
//    [self.navigationController pushViewController:vwcProcess animated:true];
    
//    TXOrderModel *orderModel = self.ordersModel.data[indexPath.section];
    UIViewController<ZJScrollPageViewChildVcDelegate> *baseVC = nil;
    switch ([order.status integerValue]) {
        case TXOrderStatusForPay: {
            TXForPayDetailViewController *vwcPay = [TXForPayDetailViewController new];
            vwcPay.orderId = order.orderNo;
            vwcPay.orderStatus = [order.status integerValue];
            baseVC = vwcPay;
        }
            break;
            
        case TXOrderStatusInQueue: {
            TXInQueueOrderDetailViewController *vwcQueue = [TXInQueueOrderDetailViewController new];
            vwcQueue.orderId = order.orderNo;
            baseVC = vwcQueue;
        }
            break;
            
        case TXOrderStatusInProduct: {
            TXInProductDetailViewController *vwcProduct = [TXInProductDetailViewController new];
            vwcProduct.orderId = order.orderNo;
            baseVC = vwcProduct;
        }
            break;
            
        case TXOrderStatusForReceiveDelivered:
        case TXOrderStatusForReceiveGetBySelf:
        case TXOrderStatusForReceiveWaitDeliver:{
            TXForReceiveDetailViewController *vwcReceive = [TXForReceiveDetailViewController new];
            vwcReceive.orderId = order.orderNo;
            if (order.delivery == 0) {
                vwcReceive.orderStatus = [order.status integerValue];
            }
            baseVC = vwcReceive;
        }
            break;
            
        case TXOrderStatusForComment:
        case TXOrderStatusCommented: {
            TXForCommentDetailViewController *vwcComment = [TXForCommentDetailViewController new];
            vwcComment.orderId = order.orderNo;
            vwcComment.orderStatus = [order.status integerValue];
            baseVC = vwcComment;
        }
            break;
            
        case TXOrderStatusInvalidHasDeposit:
        case TXOrderStatusInvalidNoDeposit: {
            TXForPayDetailViewController *vwcPay = [TXForPayDetailViewController new];
            vwcPay.orderId = order.orderNo;
            vwcPay.orderStatus = [order.status integerValue];
            baseVC = vwcPay;
        }
            break;
            
        case TXOrderStatusAppointmentSuccess:
        case TXOrderStatusAppointmentCancel: {
            TXAppointmentDetailViewController *vwcAppointment = [TXAppointmentDetailViewController new];
            vwcAppointment.appointmentNo = order.orderNo;
            weakSelf(self);
            vwcAppointment.block = ^(){
                [weakSelf.orderTableView.mj_header beginRefreshing];
            };
            baseVC = vwcAppointment;
        }
            break;
            
        default:
            break;
    }
    
    [TXCustomTools pushContainerVCWithParentVC:self childVC:baseVC orderNo:order.orderNo indexPage:1];
    
}

#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
- (void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self getAllOrdersDataFromServer];
}

#pragma mark - Custom Method

/**
 空白页
 */
- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

- (void)orderCommentSuccess:(NSNotification *)notification {
    [self.orderTableView.mj_header beginRefreshing];
    
    NSDictionary *dic = notification.userInfo;
    if (dic[@"orderNo"]) {
        TXForCommentDetailViewController *vwcComment = [TXForCommentDetailViewController new];
        vwcComment.orderId = dic[@"orderNo"];
        // 6 订单已评价
        vwcComment.orderStatus = 6;
        [TXCustomTools pushContainerVCWithParentVC:self childVC:vwcComment orderNo:dic[@"orderNo"] indexPage:0];
    }
}

/**
 支付成功通知
 
 @param notification
 */
- (void)payOrderSuccess:(NSNotification *)notification {
    [self.orderTableView.mj_header beginRefreshing];
    NSDictionary *dic = notification.userInfo;
    if (dic[@"orderNo"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            TXInQueueOrderDetailViewController *vwcInQueue = [TXInQueueOrderDetailViewController new];
            vwcInQueue.orderId = dic[@"orderNo"];
            [TXCustomTools pushContainerVCWithParentVC:self childVC:vwcInQueue orderNo:dic[@"orderNo"] indexPage:0];
        });
    }
}

#pragma mark - Lazy

/**
 空白页
 
 @return
 */
- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        _blankView.backgroundColor = RGB(255, 255, 255);
        [_blankView createBlankViewWithImage:@"ic_mian_default_order" title:@"您还未生成任何订单"];
    }
    
    return _blankView;
}

/**
 订单模型
 
 @return
 */
- (TXAllServerOrdersModel *)ordersModel {
    if (!_ordersModel) {
        _ordersModel = [TXAllServerOrdersModel new];
        _ordersModel.data = [NSMutableArray new];
    }
    return _ordersModel;
}

/**
 网络错误页
 
 @return
 */
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _netView.delegate = self;
    }
    return _netView;
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

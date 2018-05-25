//
//  TXForReceiveViewController.m
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXForReceiveDetailViewController.h"
#import "TXLogisticsDetailViewController.h"
#import "TXStoreDetailController.h"
#import "TXDesignerDetailController.h"
#import "TXInputCommentViewController.h"
#import "TXAccountDetailTableViewCell.h"
#import "TXOrderCategoryTableViewCell.h"
#import "TXOrderHeaderTableViewCell.h"
#import "TXOrderReceiveDefaultTableViewCell.h"
#import "TXAddressTableViewCell.h"
#import "TXAvatarTableViewCell.h"
#import "TXOrderTableViewCell.h"
#import "TXOrderHeaderView.h"
#import "TXOrderDetailModel.h"
#import "TXBlankView.h"

@interface TXForReceiveDetailViewController () <UITableViewDelegate, UITableViewDataSource, TXOrderTableViewCellDelegate, NetErrorViewDelegate, TXOrderHeaderViewDelegate>

/** TableView */
@property (nonatomic, strong) UITableView *receiveTableView;
/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 详情对象 */
@property (nonatomic, strong) TXOrderDetailModel *orderDetail;
/** 底部视图*/
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation TXForReceiveDetailViewController

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器属性
    [self configViewController];
    // 初始化tableView
    [self setUpContentTableView];
    [self.view addSubview:self.bottomView];
    
    // 网络请求获取订单列表
    [self getOrderDetailDataFromServer];
}

#pragma mark - Net Request

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
                                                }
                                            }
                                            
                                            [self.receiveTableView reloadData];
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
    self.receiveTableView = ({
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
    [self.view addSubview:self.receiveTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return 2;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cell = nil;
    if (indexPath.section == 0) {
        TXOrderHeaderTableViewCell *headerCell = [TXOrderHeaderTableViewCell cellWithTableView:tableView];
        headerCell.headerType = TXOrderCellHeaderTypeForReceive;
        headerCell.headerDesLabel.text = @"请您确认是否收到在TailorX的定制服装";
        headerCell.headerStatusLabel.text = @"待收货";
        headerCell.cellLineType = TXCellSeperateLinePositionType_None;
        cell = headerCell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TXOrderReceiveDefaultTableViewCell *defaultCell = [TXOrderReceiveDefaultTableViewCell cellWithTableView:tableView];
            if (self.orderDetail.delivery == TXOrderDeliveryTypeGetSelf) {
                defaultCell.logisticCompanyLabel.text = @"配送方式";
                defaultCell.logisticNoLabel.text = @"到店自取";
                defaultCell.logisticCompanyLabel.textColor = RGB(108, 108, 108);
                defaultCell.logisticCompanyLabel.font = FONT(13);
                defaultCell.cellLineType = TXCellSeperateLinePositionType_Single;
                defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
                defaultCell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                defaultCell.logisticCompanyLabel.text = @"物流单号";
                defaultCell.logisticNoLabel.text = self.orderDetail.expressNo;
                defaultCell.accessoryView = [defaultCell setCustomAccessoryView];
                defaultCell.cellLineType = TXCellSeperateLinePositionType_Single;
            }
            cell = defaultCell;
        } else {
            TXAddressTableViewCell *addressCell = [TXAddressTableViewCell cellWithTableView:tableView];
            addressCell.cellType = self.orderDetail.delivery == TXOrderDeliveryTypeGetSelf ? TXAddressTypeOnlyStoreAddress : TXAddressTypeDefault;
            addressCell.cellLineType = TXCellSeperateLinePositionType_None;
            [addressCell configAddressWithName:self.orderDetail.delivery == TXOrderDeliveryTypeDelivery ? self.orderDetail.deliveryAddress.name : self.orderDetail.storeName
                                      phoneNum:self.orderDetail.delivery == TXOrderDeliveryTypeDelivery ? self.orderDetail.deliveryAddress.telephone : self.orderDetail.storePhone
                                       address:self.orderDetail.delivery == TXOrderDeliveryTypeDelivery ? [self.orderDetail combineUserAddress] : self.orderDetail.storeAddress];
            cell = addressCell;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TXOrderCategoryTableViewCell *categoryCell = [TXOrderCategoryTableViewCell cellWithTableView:tableView];
            categoryCell.categoryLabel.text = self.orderDetail.orderNo;
            categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = categoryCell;
        } else if (indexPath.row == 1) {
            TXOrderTableViewCell *orderCell = [TXOrderTableViewCell cellWithTableView:tableView];
            orderCell.cellType = TXOrderStatusContactStore;
            orderCell.delegate = self;
            [orderCell configOrderCellWithOrderModel:[self.orderDetail convertOrderDetailModelToOrderModel] isAllOrderCell:false];
            cell = orderCell;
        } else {
            TXAccountDetailTableViewCell *accountCell = [TXAccountDetailTableViewCell cellWithTableView:tableView];
            accountCell.cellType = TXAccountDetailTableViewCellTypeInvalid;
            accountCell.topDesLabel.text = @"预约定金";
            accountCell.depositLabel.text = @"定制总额";
            
            accountCell.totalLabel.text = [NSString stringWithFormat:@"￥ %.2f", [self.orderDetail.deposit floatValue]];
            accountCell.depositAccountLabel.text = [NSString stringWithFormat:@"￥ %.2f", [self.orderDetail.totalAmount floatValue]];
            accountCell.selectionStyle = UITableViewCellSelectionStyleNone;
            accountCell.payOriginPriceLabel.hidden = true;
            accountCell.payOriginLineLabel.hidden = true;
            if ([NSString isTextEmpty:self.orderDetail.totalListPrice] || [self.orderDetail.totalListPrice floatValue] == 0 || [self.orderDetail.totalListPrice floatValue] == [self.orderDetail.totalAmount floatValue]) {
                accountCell.originPriceLabel.hidden = true;
                accountCell.originLineLabel.hidden = true;
            } else {
                accountCell.originPriceLabel.hidden = false;
                accountCell.originLineLabel.hidden = false;
                accountCell.originPriceLabel.text = [NSString stringWithFormat:@"￥ %.2f", [self.orderDetail.totalListPrice floatValue]];
            }
            cell = accountCell;
        }
        cell.cellLineType = TXCellSeperateLinePositionType_None;
    }    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 1 && indexPath.row == 0 && self.orderDetail.delivery == TXOrderDeliveryTypeDelivery) {
        TXLogisticsDetailViewController *vwclogistic = [TXLogisticsDetailViewController new];
        vwclogistic.orderId = self.orderDetail.orderNo;
        [self.navigationController pushViewController:vwclogistic animated:true];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        TXOrderHeaderView *headerView = [TXOrderHeaderView instanceView];
        headerView.delegate = self;
        headerView.headerType = TXOrderHeaderTypeDismiss;
        headerView.headerStoreType = TXOrderHeaderStoreTypeEnable;
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
    if (indexPath.section == 2 && indexPath.row == 2) return 77;
    return UITableViewAutomaticDimension;
}

#pragma mark - Custom Method

- (void)touchContactStore {
    // 联系门店
    [TXCustomTools callStoreWithPhoneNo:self.orderDetail.storePhone target:self];
}


- (void)touchReceiveButton:(UIButton *)sender {
    [UIAlertController showAlertWithTitle:@"" message:@"您确认收到为您量身定制的服装了吗？" actionsMsg:@[@"确认收到", @"没有收到"] buttonActions:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setValue:self.orderDetail.orderNo forKey:@"orderNo"];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [TXNetRequest userCenterRequestMethodWithParams:params
                                                relativeUrl:strOrderConfirmReceive
                                                    success:^(id responseObject) {
                                                        if ([responseObject[ServerResponse_success] boolValue]) {
                                                            [MBProgressHUD hideHUDForView:self.view];
                                                            TXInputCommentViewController *vwcComment = [TXInputCommentViewController new];
                                                            vwcComment.orderNo = self.orderDetail.orderNo;
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

#pragma mark - TXOrderHeaderViewDelegate

- (void)touchHeaderViewStoreButton {
    TXStoreDetailController *vwcStore = [TXStoreDetailController new];
    vwcStore.storeid = self.orderDetail.storeId;
    vwcStore.isHidden = true;
    [self.navigationController pushViewController:vwcStore animated:true];
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
        
        // 确认收货
        UIButton *contactStoreBtn = [UIButton buttonWithTitle:@"确认收货" textColor:RGB(255, 51, 102) font:13 superView:_bottomView];
        contactStoreBtn.layer.borderColor = RGB(255, 51, 102).CGColor;
        contactStoreBtn.layer.cornerRadius = 3;
        contactStoreBtn.layer.borderWidth = 0.6f;
        contactStoreBtn.frame = CGRectMake(SCREEN_WIDTH-72.5-15, 10, 72.5, 30);
        contactStoreBtn.tag = 100;
        [contactStoreBtn addTarget:self action:@selector(touchReceiveButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:contactStoreBtn];
        
        // 联系门店
        UIButton *cancellationBtn = [UIButton buttonWithTitle:@"联系门店" textColor:RGB(46, 46, 46) font:13 superView:_bottomView];
        cancellationBtn.layer.borderColor = RGB(46, 46, 46).CGColor;
        cancellationBtn.layer.cornerRadius = 3;
        cancellationBtn.layer.borderWidth = 0.6f;
        cancellationBtn.frame = CGRectMake(SCREEN_WIDTH-72.5*2-15-20, 10, 72.5, 30);
        cancellationBtn.tag = 101;
        [cancellationBtn addTarget:self action:@selector(touchContactStore) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancellationBtn];
    }
    return _bottomView;
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

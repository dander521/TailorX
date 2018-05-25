//
//  TXLogisticsDetailViewController.m
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXLogisticsDetailViewController.h"
#import "TXOrderReceiveDefaultTableViewCell.h"
#import "TXAddressTableViewCell.h"
#import "TXOrderTableViewCell.h"
#import "TXLogicTableViewCell.h"
#import "TXOrderLogisticModel.h"
#import "NSString+Extension.h"
#import "TXLogicInfoTableViewCell.h"

@interface TXLogisticsDetailViewController () <UITableViewDelegate, UITableViewDataSource, NetErrorViewDelegate>

/** TableView */
@property (nonatomic, strong) UITableView *logisticsTableView;
/** 设置 */
@property (nonatomic, strong) TXOrderLogisticModel *orderLogistic;
/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 无数据提示页面 */
@property (nonatomic, strong) TXBlankView *blankView;
/** 选择地址 */
@property (nonatomic, strong) TXAddressModel *selectedAdress;

@end

@implementation TXLogisticsDetailViewController

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器属性
    [self configViewController];
    // 初始化tableView
    [self setUpContentTableView];
    // 获取用户默认地址
    [self getUserDefaultAddress];
    // 网络请求获取订单列表
    [self getOrderLogisticDataFromServer];
}

#pragma mark - Net Request

/**
 获取用户默认地址
 */
- (void)getUserDefaultAddress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterGetUserDefaultAddress
                                         success:^(id responseObject) {
                                             if ([responseObject[ServerResponse_success] boolValue]) {
                                                 self.selectedAdress = [TXAddressModel mj_objectWithKeyValues:responseObject[@"data"]];
                                             } else {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             }
                                             [self.logisticsTableView reloadData];
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
 * 网络请求获取订单列表
 */
- (void)getOrderLogisticDataFromServer {
    [self.netView showAddedTo:self.view isClearBgc:false];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.orderId forKey:ServerParams_orderNo];
    [TXNetRequest userCenterRequestMethodWithParams:params
                                   relativeUrl:strOrderLogisticDetail
                                    success:^(id responseObject) {
                                        if ([responseObject[ServerResponse_success] boolValue]) {
                                            [self.netView stopNetViewLoadingFail:false error:false];
                                            if (responseObject) {
                                                if (responseObject[ServerResponse_data]) {
                                                    self.orderLogistic = [TXOrderLogisticModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
                                                }
                                            }
                                            
                                            [self.blankView removeFromSuperview];
                                            [self.logisticsTableView reloadData];
                                        } else if ([responseObject[ServerResponse_code] integerValue] == 100000) {
                                            // 暂无物流数据
                                            [self.netView stopNetViewLoadingFail:false error:false];
                                            [self showBlankView];
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
    self.navigationItem.title = LocalSTR(@"Str_CheckLogistics");
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.logisticsTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
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
    [self.view addSubview:self.logisticsTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return self.orderLogistic.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        TXLogicInfoTableViewCell *logicInfo = [TXLogicInfoTableViewCell cellWithTableView:tableView];
        logicInfo.logicCompanyLabel.text = self.orderLogistic.company;
        logicInfo.logicTransNoLabel.text = self.orderLogistic.no;
        cell = logicInfo;
    } else {
        TXLogicTableViewCell *logicCell = [TXLogicTableViewCell cellWithTableView:tableView];
        logicCell.cellLineType = indexPath.row + 1 == self.orderLogistic.data.count ? TXCellSeperateLinePositionType_None : TXCellSeperateLinePositionType_Single;
        logicCell.cellLineRightMargin = TXCellRightMarginType47;
        
        TXOrderLogisticContentModel *model = self.orderLogistic.data[indexPath.row];
        
        if (![NSString isTextEmpty:model.context]) {
            // 调整行间距
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.context];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.context length])];
            logicCell.statusLabel.attributedText = attributedStr;
        }else {
            logicCell.statusLabel.text = @"";
        
        }
        logicCell.timeLabel.text = model.time;
        logicCell.statusImageView.image = [UIImage imageNamed:@"ic_main_tracking_the_status"];
        if (indexPath.row == 0) {
            logicCell.statusLabel.textColor = RGB(46, 46, 46);
            logicCell.isTop = true;
            logicCell.statusImageView.image = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_main_tracking_state"];
        }
        cell = logicCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80.0;
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)] && indexPath.section == 1) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, TableViewSeperateLineLogisticOriginX, 0, 0)];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
- (void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self getOrderLogisticDataFromServer];
}

#pragma mark - Custom Method

/**
 空白页
 */
- (void)showBlankView {
    [self.blankView createBlankViewWithImage:@"ic_mian_default_order"
                                       title:@"暂无物流数据"
                                    subTitle:@"请耐心等待"];
}

#pragma mark - Lazy

/**
 错误页

 @return
 */
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:self.view.bounds];
        _netView.delegate = self;
    }
    return _netView;
}

/**
 空白页

 @return
 */
- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        self.blankView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_blankView];
    }
    
    return _blankView;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  TXTradeQueueNoController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTradeQueueNoController.h"
#import "TXQueueNoCell.h"
#import "TXKeyboardView.h"
#import "TXPayNoController.h"
#import "TXQueueNoModel.h"

@interface TXTradeQueueNoController ()<UITableViewDelegate, UITableViewDataSource, TXQueueNoCellDelegate,NetErrorViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NetErrorView *netView;
@property (nonatomic, strong) TXBlankView *blanView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger dataCount;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isLoadNewData;

@end

@implementation TXTradeQueueNoController

- (void)zj_viewWillAppearForIndex:(NSInteger)index {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"排号交易";
    _page = 0;
    _pageLength = 10;
    _dataCount = 0;
    _dataArr = [NSMutableArray array];
    
    // 初始化界面
    [self setupTabelView];
    // 添加通知
    [self addNotification];
    // 先加载我的订单 如果为空 则不加载交易的列表
    [self.netView showAddedTo:self.view isClearBgc:NO];
    [self loadMyQueueNoList];
}

- (void)setupTabelView {
    CGFloat viewHeight = self.isQuickProduce ? SCREEN_HEIGHT : SCREEN_HEIGHT-kTabBarHeight-kTopHeight;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.tableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - Notification

- (void)addNotification {
    // 订单支付成功
    // 程荣刚：2017-4-24 添加订单支付成功通知 处理页面显示问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDisplay) name:kNSNotificationPayOrderSuccess object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDisplay) name:kNSNotificationQueueNoBuySucceed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDisplay) name:kNSNotificationLoginSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDisplay) name:kNSNotificationQueueNoHandle object:nil];
}

/**
 * 操作我的排号 成功失败都需要刷新列表
 */
- (void)refreshDisplay {
    [self loadNewData];
}

#pragma mark - request

- (void)loadNewData {
    _page = 0;
    _isLoadNewData = YES;
    
    // 先拉取我的排号
    [self loadMyQueueNoList];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer setState:MJRefreshStateIdle];
}

- (void)loadMoreData {
    _page += 1;
    _isLoadNewData = NO;
    
    if (_dataCount < _pageLength) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        // 先拉取我的排号
        [self loadMyQueueNoList];
    }
}

/** 
 * 有我的排号 - 才请求排号交易列表
 */
- (void)loadMyQueueNoList {
    
    TXQueueNoRequestParams *params = [TXQueueNoRequestParams param];
    params.page = 0;
    params.pageLength = 1;
    params.saleStatus = -1;
    
    weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:findMyRankNumList];
    [TXBaseNetworkRequset requestWithURL:url params:params.mj_keyValues success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            TXQueueNoList *data = [TXQueueNoList mj_objectWithKeyValues:responseObject[ServerResponse_data]];
            if (data.queueNos.count) {
                [weakSelf.blanView removeFromSuperview];
                // 请求排号交易列表
                [weakSelf loadData];
            }else {
                [weakSelf.view addSubview:weakSelf.blanView];
                [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
                
                weakSelf.blanView.imgClickBlock = ^(){
                    [weakSelf.tableView.mj_header beginRefreshing];
                };
            }
        }
    } failure:^(NSError *error) {
        if (self.dataArr.count) {
            [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
            if (weakSelf.tableView.contentOffset.y) {
                [ShowMessage showMessage:kErrorTitle];
            }
        }else {
            [weakSelf.netView stopNetViewLoadingFail:YES error:NO];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } isLogin:^{
        [weakSelf.netView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/**
 * 请求交易列表
 */
- (void)loadData {
    
    TXQueueNoRequestParams *params = [TXQueueNoRequestParams param];
    params.page = _page;
    params.pageLength = _pageLength;
    params.saleStatus = -1;
    
    weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:findRankNumList];
    [TXBaseNetworkRequset requestWithURL:url params:params.mj_keyValues success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            
            TXQueueNoList *data = [TXQueueNoList mj_objectWithKeyValues:responseObject[ServerResponse_data]];
            weakSelf.dataCount = data.queueNos.count;
            
            if (weakSelf.isLoadNewData) {
                [weakSelf.dataArr removeAllObjects];
            }
            if (weakSelf.dataCount) {
                [weakSelf.blanView removeFromSuperview];
                [weakSelf.dataArr addObjectsFromArray:data.queueNos];
                [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
            }
        }else {
            [ShowMessage showMessage:responseObject[ServerResponse_msg]];
            if (weakSelf.dataArr.count) {
                [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
            }else {
                [weakSelf.netView stopNetViewLoadingFail:NO error:YES];
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        if (weakSelf.dataArr.count) {
            [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
            if (weakSelf.tableView.contentOffset.y) {
                [ShowMessage showMessage:kErrorTitle];
                if (weakSelf.tableView.contentOffset.y > 0) {
                    weakSelf.page -= 1;
                }
            }
        }else {
            [weakSelf.netView stopNetViewLoadingFail:YES error:NO];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } isLogin:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.netView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];

}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXQueueNoCell *cell = [TXQueueNoCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.cellType = TXQueueNoCellTypeTransNum;
    
    if (self.dataArr.count) {
        TXQueueNoModel *data = self.dataArr[indexPath.row];
        cell.data = data;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXQueueNoModel *data;
    if (self.dataArr.count) {
        data = self.dataArr[indexPath.row];
        if (data.ownerType == 0) {
            return 96;
        }else {
            return 116;
        }
    }
    return 0;
}

#pragma mark - cell-购买按钮事件

- (void)cellOfButtonClick:(TXQueueNoCell *)cell senderType:(TXQueueNoCellBtnType)senderType {
    
    if (senderType != TXQueueNoCellBtnTypepay) {
        return;
    }
    weakSelf(self);
    if ([GetUserInfo.isLogin integerValue] != 1) {
        [TXServiceUtil LoginController:(TXNavigationViewController *)self.navigationController];
    }else {
        TXQueueNoRequestParams *params = [TXQueueNoRequestParams param];
        params.rankId = cell.data.rankId;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *url = [strTailorxAPI stringByAppendingString:addRankNumRecord];
        
        [TXBaseNetworkRequset requestWithURL:url params:params.mj_keyValues success:^(id responseObject) {
            if ([responseObject[ServerResponse_success] boolValue]) {
                
                TXQueueNoModel *data = cell.data;
                NSInteger recordId = [responseObject[ServerResponse_data][@"recordId"] integerValue];
                
                TXPayNoController *vc = [[TXPayNoController alloc] init];
                vc.data = data;
                vc.recordId = recordId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                // 从支付页面回来刷新列表数据
                vc.popBlock = ^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                };
            }else {
                [ShowMessage showMessage:responseObject[ServerResponse_msg]];
            }
            [MBProgressHUD hideHUDForView:self.view];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        } isLogin:^{
            
        }];
    }
}

#pragma mark - NetErrorViewDelegate

-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self.netView showAddedTo:self.view isClearBgc:NO];
    _page = 0;
    [self loadMyQueueNoList];
}

#pragma - lazy

- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _netView.delegate = self;
    }
    return _netView;
}
- (TXBlankView *)blanView {
    if (!_blanView) {
        CGFloat viewHeight = self.isQuickProduce ? SCREEN_HEIGHT-kTopHeight : SCREEN_HEIGHT-kTopHeight;
        _blanView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
        _blanView.backgroundColor = [UIColor whiteColor];
        [_blanView createBlankViewWithImage:@"ic_main_default_row_number" title:@"排号可交易，赚取额外收益" subTitle:@"排号赚取收益，预约第一步"];
    }
    return _blanView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

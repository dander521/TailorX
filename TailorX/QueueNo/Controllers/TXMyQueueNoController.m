//
//  TXMyQueueNoController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXMyQueueNoController.h"
#import "TXKeyboardView.h"
#import "TXQueueNoCell.h"

#import "TXQueueNoModel.h"

@interface TXMyQueueNoController () <UITableViewDelegate, UITableViewDataSource, TXQueueNoCellDelegate,TXKeyboardViewDelegate,NetErrorViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NetErrorView *netView;
@property (weak, nonatomic) TXKeyboardView *keyboardView;
@property (nonatomic, strong) TXBlankView *blanView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger dataCount;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL isLoadNewData;

@end

@implementation TXMyQueueNoController

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
    
    _page = 0;
    _pageLength = 10;
    _dataCount = 0;
    _dataArr = [NSMutableArray array];
    
    // 初始化界面
    [self setupTabelView];
    // 添加通知
    [self addNotification];
    // 加载数据
    [self.netView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

- (void)setupTabelView {
    
    CGFloat viewHeight = self.isQuickProduce ? SCREEN_HEIGHT-kTopHeight : SCREEN_HEIGHT-kTabBarHeight-kTopHeight;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.tableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - Notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDisplay) name:kNSNotificationPayOrderSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDisplay) name:kNSNotificationQueueNoBuySucceed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDisplay) name:kNSNotificationLoginSuccess object:nil];
    
}

- (void)refreshDisplay {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - request

- (void)loadNewData {
    _page = 0;
    _isLoadNewData = YES;
    
    [self loadData];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer setState:MJRefreshStateIdle];
}

- (void)loadMoreData {
    _page += 1;
    _isLoadNewData = NO;
    
    if (_dataCount < _pageLength) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

- (void)loadData {
    
    TXQueueNoRequestParams *params = [TXQueueNoRequestParams param];
    params.page = _page;
    params.pageLength = _pageLength;
    params.saleStatus = -1;
    
     weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:findMyRankNumList];
    
    [TXBaseNetworkRequset requestWithURL:url params:params.mj_keyValues success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            
            TXQueueNoList *data = [TXQueueNoList mj_objectWithKeyValues:responseObject[ServerResponse_data]];
            
            weakSelf.dataCount = data.queueNos.count;
            
            if (weakSelf.isLoadNewData) {
                [weakSelf.dataArr removeAllObjects];
            }
            if (weakSelf.dataCount) {
                [weakSelf.dataArr addObjectsFromArray:data.queueNos];
                [weakSelf.blanView removeFromSuperview];
                
            }else {
                if (weakSelf.dataArr.count == 0) {
                    [weakSelf.view addSubview:weakSelf.blanView];
                    weakSelf.blanView.imgClickBlock = ^(){
                        [weakSelf.tableView.mj_header beginRefreshing];
                    };
                }
            }
            [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
            [weakSelf.tableView reloadData];
        }else {
            [ShowMessage showMessage:responseObject[ServerResponse_msg]];
            if (!weakSelf.dataArr.count) {
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
    cell.cellType = TXQueueNoCellTypeMyNum;
    
    if (self.dataArr.count) {
        TXQueueNoModel *data = self.dataArr[indexPath.row];
        cell.data = data;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

#pragma mark - TXQueueNoCellDelegate

- (void)cellOfButtonClick:(TXQueueNoCell *)cell senderType:(TXQueueNoCellBtnType)senderType {
    
    TXQueueNoRequestParams *param = [TXQueueNoRequestParams param];
    param.rankId = cell.data.rankId;
    param.amount = cell.data.amount;
    param.opType = cell.data.saleStatus;
    
    weakSelf(self);
    if ([GetUserInfo.isLogin integerValue] != 1) {
        [TXServiceUtil LoginController:(TXNavigationViewController *)self.navigationController];
    }else {
        if (senderType == TXQueueNoCellBtnTypeCancel) { // 取消
            [UIAlertController showAlertWithTitle:@"" message:@"此操作将会取消出让排号？" actionsMsg:@[@"确定",@"取消"] buttonActions:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [weakSelf updateRankNumStatus:param];
                }
            } target:self];
        }
        else if (senderType == TXQueueNoCellBtnTypeTrans) { // 出让
            TXKeyboardView *keyboardView = [[TXKeyboardView alloc] init];
            keyboardView.delegate = self;
            self.keyboardView = keyboardView;
            keyboardView.param = param;
            [self.keyboardView show];
        }
    }
}

#pragma mark - request

- (void)updateRankNumStatus:(TXQueueNoRequestParams *)param {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:updateRankNumStatus];
    [TXBaseNetworkRequset requestWithURL:url params:param.mj_keyValues success:^(id responseObject) {
        if (responseObject) {
            if ([responseObject[ServerResponse_success] boolValue]) {
                [weakSelf.tableView.mj_header beginRefreshing];
                [self.keyboardView hidden];
                // 发出转让/取消通知 交易列表刷新数据
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationQueueNoHandle object:nil];
            }
        }
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [ShowMessage showMessage:responseObject[ServerResponse_msg]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [ShowMessage showMessage:error.description];
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - TXKeyboardViewDelegate - 确定转让

- (void)keyboardSureBtnClick:(NSString *)price {
    self.keyboardView.param.amount = price.floatValue;

    [self updateRankNumStatus:self.keyboardView.param];
}


#pragma mark - NetErrorViewDelegate

-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self.netView showAddedTo:self.view isClearBgc:NO];
    [self loadNewData];
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
        _blanView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _blanView.backgroundColor = [UIColor whiteColor];
        [_blanView createBlankViewWithImage:@"ic_main_default_row_number" title:@"排号可交易，赚取额外收益" subTitle:@"排号赚取收益，预约第一步"];
    }
    return _blanView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

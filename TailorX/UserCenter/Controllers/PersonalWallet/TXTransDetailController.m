//
//  TXTransDetailController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTransDetailController.h"
#import "TXTransDetailCell.h"
#import "TXTransactionRecordModel.h"
#import "TXWalletParams.h"

@interface TXTransDetailController () <UITableViewDelegate, UITableViewDataSource, NetErrorViewDelegate>
{
    
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NetErrorView *netView;
@property (nonatomic, strong) TXBlankView *blanView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger dataCount;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL isLoadNewData;

@end

@implementation TXTransDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"明细";
    
    _page = 0;
    _pageLength = 10;
    _dataArr = [NSMutableArray array];
    
    [self setupTableView];
 
    [self.netView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

- (void)setupTableView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(242, 242, 242);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.tableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 数据请求
- (void)loadNewData {
    // 程荣刚：2017-4-24 修改拉去最新数据参数
    _page = 0;
    _pageLength = 10;
    _isLoadNewData = YES;
    
    [self loadData];
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_footer setState:MJRefreshStateIdle];
}
- (void)loadMoreData {
    
    _page += 1;
    _isLoadNewData = NO;
    
    if (_dataCount < _pageLength) {
        [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

- (void)loadData {
    
    TXWalletParams *params = [TXWalletParams param];
    params.page = _page;
    params.pageLength = _pageLength;
    params.accountType = _accountType;
    
    weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:findTransactionRecordList];
    
    [TXBaseNetworkRequset requestWithURL:url params:params.mj_keyValues success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            
            [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
            
            TXTransactionRecordModelList *data = [TXTransactionRecordModelList mj_objectWithKeyValues:responseObject[ServerResponse_data]];
            
            weakSelf.dataCount = data.data.count;
            
            if (_isLoadNewData) {
                [weakSelf.dataArr removeAllObjects];
            }
            
            if (weakSelf.dataCount) {
                [weakSelf.blanView removeFromSuperview];
                [weakSelf.dataArr addObjectsFromArray:data.data];
            }
            
            if (weakSelf.dataArr.count == 0) {
                [weakSelf.view addSubview:weakSelf.blanView];
            }
        }else {
            if (!weakSelf.dataArr.count) {
                [weakSelf.view addSubview:weakSelf.blanView];
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
        [weakSelf.netView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TXTransDetailCell *cell = [TXTransDetailCell cellWithTableView:tableView];
    if (self.dataArr.count) {
        TXTransactionRecordModel *data = self.dataArr[indexPath.row];
        cell.data = data;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94;
}

#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self.netView showAddedTo:self.view isClearBgc:NO];
    [self loadNewData];
}

#pragma - lazy

- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        _netView.delegate = self;
    }
    return _netView;
}

- (TXBlankView *)blanView {
    if (!_blanView) {
        _blanView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        [_blanView createBlankViewWithImage:@"ic_main_default_detail" title:@"还未生成明细"];
    }
    return _blanView;
}


@end

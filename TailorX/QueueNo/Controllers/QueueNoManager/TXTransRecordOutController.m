//
//  TXTransRecordOutController.m
//  TailorX
//
//  Created by liuyanming on 2017/4/11.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTransRecordOutController.h"
#import "TXTransRecordCell.h"
#import "TXQueueNoRequestParams.h"
#import "TXFindRecordListModel.h"

@interface TXTransRecordOutController ()<UITableViewDelegate, UITableViewDataSource,NetErrorViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NetErrorView *netView;
@property (nonatomic, strong) TXBlankView *blanView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger opType; //操作类型：0买入，1卖出

@property (nonatomic, assign) NSInteger dataCount;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL isLoadNewData;

@end

@implementation TXTransRecordOutController


- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
}

- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    self.opType = index;
}

- (void)zj_viewDidDisappearForIndex:(NSInteger)index {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    _pageLength = 10;
    _dataCount = 0;
    _opType = 1;
    _dataArr = [NSMutableArray array];
    
    [self setupTabelView];
    
    [self.netView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

- (void)setupTabelView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(255, 255, 255);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.tableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    params.opType = self.opType;
    
    weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:findRecordList];
    
    [TXBaseNetworkRequset requestWithURL:url params:params.mj_keyValues success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            
            [weakSelf.netView stopNetViewLoadingFail:NO error:NO];
            
            TXFindRecordListModel *data = [TXFindRecordListModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
            
            weakSelf.dataCount = data.data.count;
            
            if (weakSelf.isLoadNewData) {
                [weakSelf.dataArr removeAllObjects];
            }
            if (weakSelf.dataCount) {
                [weakSelf.dataArr addObjectsFromArray:data.data];
                [weakSelf.blanView removeFromSuperview];
            }else {
                if (!weakSelf.dataArr.count) {
                    [weakSelf.view addSubview:weakSelf.blanView];
                }
            }
        }else {
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
        if (self.dataArr.count) {
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
        
    }];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTransRecordCell *cell = [TXTransRecordCell cellWithTableView:tableView];
    if (self.dataArr.count) {
        TXFindRecordModel *data = self.dataArr[indexPath.row];
        cell.data = data;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
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
        [_blanView createBlankViewWithImage:@"ic_main_default_transaction_record" title:@"还未生成交易记录"];
    }
    return _blanView;
}

@end

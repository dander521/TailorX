//
//  TXAllStoreViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAllStoreViewController.h"
// M
#import "TXStroeListModel.h"
// V
#import "TXSelectStoreTableViewCell.h"
#import "NetErrorView.h"
// C
#import "TXStoreDetailController.h"
// T
#import "TXStroeDataTool.h"
#import "TXLocationManager.h"

@interface TXAllStoreViewController ()<UITableViewDelegate,UITableViewDataSource,NetErrorViewDelegate>
@property (nonatomic, strong) UITableView *mainTabView;
@property (nonatomic, strong) NetErrorView *netErrorView;

@property (nonatomic, strong) NSMutableArray *stroeListDataAry;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger dataCount;
/** 定位*/
@property (nonatomic, strong) TXLocationManager *locationManager;

@property (nonatomic, assign) BOOL isPullUp;
@property (nonatomic, assign) BOOL isPullDown;

@end

static NSString * storeListCellID = @"TXSelectStoreTableViewCell";

@implementation TXAllStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsScrollViewInsets_NO(self.mainTabView, self);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"预约定制";
    _page = 0;
    _pageLength = 10;
    _dataCount = 0;
    // 设置主题列表视图
    [self setUpMainTabView];
    // 实时获取金纬度，根据当前经纬度请求数据
    [self locate];
    // 加载数据
    [self.netErrorView showAddedTo:self.view isClearBgc:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 数据请求

- (void)loadData {
    NSMutableDictionary *param = [@{}mutableCopy];
    [param setValue:@(_page) forKey:@"page"];
    [param setValue:@(_pageLength) forKey:@"pageLength"];
    [param setValue:GetUserInfo.longitude forKey:@"longitude"];
    [param setValue:GetUserInfo.latitude forKey:@"latitude"];
    
    [self findStoreListWithParams:param];
}

- (void)locate {
    weakSelf(self);
    self.locationManager = [[TXLocationManager alloc] init];
    [self.locationManager locationManagerWithsuccess:^(NSString *cityName) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadData) object:nil];
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    } failure:^(NSError *error) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadData) object:nil];
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    }];
}

- (void)findStoreListWithParams:(NSMutableDictionary *)param {
    [TXNetRequest userCenterRequestMethodWithParams:param relativeUrl:strUserStoreAllList success:^(id responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            NSArray *dataAry = [TXStroeDataTool getStroeListModelArrayWithData:responseObject];
            self.dataCount = dataAry.count;
            if (self.dataCount) {
                // 普通请求或下拉刷新
                if (!self.isPullUp) {
                    [self.stroeListDataAry removeAllObjects];
                    [self.stroeListDataAry addObjectsFromArray:dataAry];
                }
                // 上拉加载更多
                else {
                    [self.stroeListDataAry addObjectsFromArray:dataAry];
                }
                
                [self.netErrorView stopNetViewLoadingFail:NO error:NO];
                [self.mainTabView reloadData];
            }else {
                [self.netErrorView stopNetViewLoadingFail:NO error:YES];
                [self checkNetStaus];
            }
        }else {
            [self.netErrorView stopNetViewLoadingFail:NO error:YES];
        }
        [self.mainTabView.mj_header endRefreshing];
        [self.mainTabView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self checkNetStaus];
        [self.netErrorView stopNetViewLoadingFail:YES error:NO];
        [self.mainTabView.mj_header endRefreshing];
        [self.mainTabView.mj_footer endRefreshing];
    } isLogin:^{
        
    }];
}

- (void)checkNetStaus {
    if (_isPullDown || _isPullUp) {
        [ShowMessage showMessage:kErrorTitle withCenter:self.view.center];
    }
    if (_isPullUp) {
        _page -= 1;
    }
    _isPullUp = NO;
    _isPullDown = NO;
}

- (void)loadNewData {
    _page = 0;
    _isPullUp = NO;
    _isPullDown = YES;
    self.dataCount = 0;
    [self loadData];
    [self.mainTabView.mj_footer endRefreshing];
    [self.mainTabView.mj_footer setState:MJRefreshStateIdle];
}

- (void)loadMoreData {
    _page += 1;
    _isPullUp = YES;
    _isPullDown = NO;
    if (_dataCount < _pageLength) {
        [self.mainTabView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

#pragma mark - netErrorView delegate

-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self loadData];
}

#pragma mark - setUpTabView

- (void)setUpMainTabView {
    self.mainTabView = [UITableView tableWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight) style:UITableViewStylePlain superView:self.view];
    self.mainTabView.delegate = self;
    self.mainTabView.dataSource = self;
    self.mainTabView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.mainTabView registerNib:[UINib nibWithNibName:storeListCellID bundle:nil] forCellReuseIdentifier:storeListCellID];
    self.mainTabView.backgroundColor = RGB(255, 255, 255);
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.mainTabView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainTabView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - tabelView delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stroeListDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSelectStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeListCellID forIndexPath:indexPath];
    cell.model = self.stroeListDataAry[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (SCREEN_WIDTH == 320) {
        return LayoutW(130) + 20;
    } else {
        return LayoutH(130);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXStroeListModel *model = self.stroeListDataAry[indexPath.row];
    TXStoreDetailModel *detailModel = [model converListModelToDetailModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeStore object:detailModel userInfo:nil];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - lazy

- (NSMutableArray *)stroeListDataAry {
    if (nil == _stroeListDataAry) {
        _stroeListDataAry = [NSMutableArray array];
    }
    return _stroeListDataAry;
}

- (NetErrorView *)netErrorView {
    if (_netErrorView == nil) {
        _netErrorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH , SCREEN_HEIGHT)];
        _netErrorView.delegate = self;
    }
    return _netErrorView;
}

@end
//
//  TXDesignerListViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/8/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignerListViewController.h"
#import "TXDesignerListModel.h"
#import "TXDesignerDetailModel.h"
#import "TXReservaDesingerViewController.h"

@interface TXDesignerListViewController ()<UITableViewDelegate,UITableViewDataSource,NetErrorViewDelegate>

/** TableView */
@property (nonatomic, strong) UITableView *designerListTableView;
@property (strong, nonatomic) NetErrorView *netView;
@property (nonatomic, strong) TXBlankView *blankView;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger pageLength;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 第一次获取数据 */
@property (nonatomic, assign) BOOL isFirstPostData;
/** 所有设计师 */
@property (nonatomic, strong) NSMutableArray *allDesignerArray;

@end

@implementation TXDesignerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViewController];
    
    [self setUpContentTableView];
    
    [self initialVariables];
    [self.netView showAddedTo:self.view isClearBgc:false];
    
    [self getDataFromServer];
}

/**
 * 设置页面属性
 */
- (void)configViewController {
    self.view.backgroundColor = RGB(245, 245, 245);
}

/**
 * 初始化变量
 */
- (void)initialVariables {
    _page = DefaultPageNumber;
    _pageLength = DefaultPageLength;
    _dataCount = DefaultDataCount;
    _isFirstPostData = true;
}

/**
 * 空白页
 */
- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.designerListTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-kTabBarHeight-kTopHeight) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.scrollEnabled = true;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundColor = RGB(245, 245, 245);
        tableView.bounces = true;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });

    [self.view addSubview:self.designerListTableView];
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.designerListTableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.designerListTableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/**
 * 下拉刷新
 */
- (void)loadNewData {
    _page = DefaultPageNumber;
    
    [self getDataFromServer];
    [_designerListTableView.mj_footer endRefreshing];
    [_designerListTableView.mj_footer setState:MJRefreshStateIdle];
}

/**
 * 上拉加载更多
 */
- (void)loadMoreData {
    _page += 1;
    
    if (_dataCount < _pageLength) {
        [_designerListTableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self getDataFromServer];
    }
}

- (void)getDataFromServer {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[NSString stringWithFormat:@"%zd", self.designerType] forKey:@"showMode"];
    [params setValue:[NSString stringWithFormat:@"%zd", _page] forKey:ServerParams_page];
    [params setValue:[NSString stringWithFormat:@"%zd", _pageLength] forKey:ServerParams_pageLength];
    [params setValue:[TXUserModel defaultUser].longitude forKey:@"longitude"];
    [params setValue:[TXUserModel defaultUser].latitude forKey:@"latitude"];

    [TXNetRequest userCenterRequestMethodWithParams:params
                                        relativeUrl:strHomeFindDesignerList
                                            success:^(id responseObject) {
                                                if ([responseObject[ServerResponse_success] boolValue]) {
                                                    _isFirstPostData = false;
                                                    [self.netView stopNetViewLoadingFail:false error:false];
                                                    if (_page == 0) {
                                                        [self.allDesignerArray removeAllObjects];
                                                    }
                                                    if (responseObject) {
                                                        if (responseObject[ServerResponse_data]) {
                                                            TXAllDesignerListModel *allDesigner = [TXAllDesignerListModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
                                                            _dataCount = allDesigner.data.count;
                                                            if (_dataCount > 0) {
                                                                [self.allDesignerArray addObjectsFromArray:allDesigner.data];
                                                            }
                                                        }
                                                    }
                                                
                                                    if (self.allDesignerArray.count == 0) {
                                                        [self showBlankView];
                                                    } else {
                                                        [self.blankView removeFromSuperview];
                                                        if (_dataCount < _pageLength) {
                                                            [_designerListTableView.mj_footer setState:MJRefreshStateNoMoreData];
                                                        }
                                                    }
                                                    [self.designerListTableView reloadData];
                                                } else {
                                                    if (_page > 0) {
                                                        _page -= 1;
                                                    }
                                                    if (!_isFirstPostData) {
                                                        [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                                    }
                                                    
                                                    [self.netView stopNetViewLoadingFail:false error:true];
                                                }
                                                [_designerListTableView.mj_header endRefreshing];
                                                [_designerListTableView.mj_footer endRefreshing];
                                            } failure:^(NSError *error) {
                                                if (_page > 0) {
                                                    _page -= 1;
                                                }
                                                if (!_isFirstPostData) {
                                                    [ShowMessage showMessage:kErrorTitle withCenter:self.view.center];
                                                }
                                                
                                                [self.netView stopNetViewLoadingFail:true error:false];
                                                [_designerListTableView.mj_header endRefreshing];
                                                [_designerListTableView.mj_footer endRefreshing];
                                            } isLogin:^{
                                                [_designerListTableView.mj_header endRefreshing];
                                                [_designerListTableView.mj_footer endRefreshing];
                                                [self.netView stopNetViewLoadingFail:NO error:YES];
                                                [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                            }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allDesignerArray.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXDesignerListModel *model = self.allDesignerArray[indexPath.section];
    TXDesignerListTableViewCell *cell = [TXDesignerListTableViewCell cellWithTableView:tableView];
    cell.designerModel = model;
    return cell;
}

#pragma mark - UITableViewDelegate

/**
 * 在此跳转子控制器
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        TXDesignerListModel *model = self.allDesignerArray[indexPath.section];
        
        if (self.isSelect) {
            TXReservaDesingerViewController *vc = [TXReservaDesingerViewController new];
            vc.isHeadImgBtnClick = YES;
            vc.designerId = model.ID;
            vc.customType = NO;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            TXDesignerDetailController *vwcDetail = [TXDesignerDetailController new];
            vwcDetail.designerId = model.ID;
            vwcDetail.bEnterStoreDetail = true;
            vwcDetail.isHavaCommitBtn = true;
            [self.navigationController pushViewController:vwcDetail animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 151.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - NetErrorViewDelegate

-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self getDataFromServer];
}

#pragma mark - Lazy

- (NSMutableArray *)allDesignerArray {
    if (!_allDesignerArray) {
        _allDesignerArray = [NSMutableArray new];
    }
    return _allDesignerArray;
}

/**
 空白页
 @return
 */
- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight-50)];
        _blankView.backgroundColor = RGB(255, 255, 255);
        [_blankView createBlankViewWithImage:@"ic_mian_default_order"
                                       title:@"暂无设计师"];
        
        _blankView.isFull = YES;
    }
    
    return _blankView;
}

/**
 网络错误页
 @return
 */
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight-50)];
        _netView.delegate = self;
    }
    return _netView;
}

@end

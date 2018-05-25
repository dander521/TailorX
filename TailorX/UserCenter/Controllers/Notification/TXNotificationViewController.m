//
//  TXNotificationViewController.m
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXNotificationViewController.h"
#import "TXNotificationCell.h"
#import "TXBlankView.h"
#import "TXGetMsgModel.h"
#import "ReachabilityUtil.h"
#import "TXQueueTradeDetailViewController.h"
#import "TXCommentNotPassViewController.h"
#import "TXAppointmentDetailViewController.h"
#import "TXAllDetailViewController.h"

static NSString *cellID = @"TXNotificationCell";

@interface TXNotificationViewController ()<UITableViewDataSource,UITableViewDelegate,NetErrorViewDelegate>

/** 列表*/
@property (nonatomic, strong) UITableView *tableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray<TXGetMsgModel*> *dataSource;
/** 提示页面*/
@property (nonatomic, strong) TXBlankView *blankView;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** 上拉加载*/
@property (nonatomic, assign, getter=isPullUp) BOOL pullUp;
/** 下拉刷新*/
@property (nonatomic, assign, getter=isPullDown) BOOL pullDown;
/** 初始化页码*/
@property (nonatomic, assign) NSInteger page;
/** 每一页的总条数*/
@property (nonatomic, assign) NSInteger dataCount;
/** 每页条数*/
@property (nonatomic, assign) NSInteger pageLength;

@end

@implementation TXNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    // 设置控制器属性
    [self configViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - Config ViewController

/** 
 初始化数据源
 */
- (void)initializeDataSource {
    self.dataSource = [@[] mutableCopy];
    self.pullUp = NO;
    self.pullDown = NO;
    self.page = 0;
    self.pageLength = 10;
    self.dataCount = 0;
    
    [self loadData];
}

/**
 设置控制器属性
 */
- (void)configViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = LocalSTR(@"Str_Notification");
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.errorView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"一键全读" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:RGB(138, 138, 138) forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 63, 44);
    [rightBtn addTarget:self action:@selector(respondsToRightItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

#pragma mark - methods

- (void)loadData {
    
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.page] forKey:@"page"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.pageLength] forKey:@"pageLength"];
    
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeFindMsgList completion:^(id responseObject, NSError *error) {
        if (error) {
            if (self.isPullUp || self.isPullDown) {
                [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
                if (self.isPullUp) {
                    _page -= 1;
                }
            }else {
                [self.errorView stopNetViewLoadingFail:YES error:NO];
            }
            [self stopRefreshing];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue] == true) {
                if (self.isPullDown && !self.isPullUp) {
                    [self.dataSource removeAllObjects];
                }
                NSArray *dicArr = responseObject[kData][kData];
                self.dataCount = dicArr.count;
                [self.dataSource addObjectsFromArray:[TXGetMsgModel mj_objectArrayWithKeyValuesArray:dicArr]];
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                if (!self.dataSource || !self.dataSource.count) {
                    [self.view addSubview:self.blankView];
                    [self.blankView createBlankViewWithImage:@"ic_main_default_news" title:@"还没有通知消息"];
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                }else {
                    [self.blankView removeFromSuperview];
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                }
                [self.tableView reloadData];
                [self stopRefreshing];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    //不做处理
                    _page = 0;
                }else {
                    [self.errorView stopNetViewLoadingFail:NO error:YES];
                }
                [self stopRefreshing];
            }
        }
    }isLogin:^{
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)loadNewData {
    _page = 0;
    self.pullDown = YES;
    self.pullUp = NO;
    [self loadData];
}
- (void)loadMoreData {
    _page += 1;
    self.pullUp = YES;
    self.pullDown = NO;
    if (self.dataCount < self.pageLength) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

- (void)stopRefreshing {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - events

- (void)respondsToRightItem:(UIButton *)item {
    
    NSMutableArray *status = [@[]mutableCopy];
    for (TXGetMsgModel *model in self.dataSource) {
        if (model.status == 1) {
            [status addObject:@(1)];
        }
    }
    if (status.count == self.dataSource.count) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"1" forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%zd",self.dataSource.firstObject.createTime] forKey:@"createTime"];
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [TXNetRequest homeRequestMethodWithParams:params
                                  relativeUrl:strHomeUpdateAllStatus
                                   completion:^(id responseObject, NSError *error) {
        if (error) {
            [ShowMessage showMessage:error.description];
            [MBProgressHUD hideHUDForView:self.view];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            return;
        }
        
        if ([responseObject[ServerResponse_success] boolValue]) {
            for (TXGetMsgModel *model in weakSelf.dataSource) {
                model.status = 1;
            }
            [weakSelf.tableView reloadData];
            [TXNetRequest findUserUnreadMsgCount];
        } else {
            [ShowMessage showMessage:responseObject[ServerResponse_msg]];
        }
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXGetMsgModel *model = self.dataSource[indexPath.row];
    if (model.status == 1 && ([model.contentType integerValue] == TXMessageStatusPaySuccess || [model.contentType integerValue] == TXMessageStatusOrderForReceive)) {
        return;
    }
    if (![ReachabilityUtil checkCurrentNetworkState]) {
        [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
        return;
    }
    
    if (model.status != 1) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:@"1" forKey:@"status"];
        [params setValue:[NSString stringWithFormat:@"%zd",model.ID] forKey:@"id"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [TXNetRequest homeRequestMethodWithParams:params relativeUrl:strHomeUpdateStatus completion:^(id responseObject, NSError *error) {
            
            if (error) {
                [ShowMessage showMessage:error.description];
                [MBProgressHUD hideHUDForView:self.view];
                return;
            }
            
            if ([responseObject[ServerResponse_success] boolValue]) {
                model.status = 1;
                [tableView reloadData];
                [TXNetRequest findUserUnreadMsgCount];
            } else {
                [ShowMessage showMessage:responseObject[ServerResponse_msg]];
            }
            [MBProgressHUD hideHUDForView:self.view];
        }isLogin:^{
            [MBProgressHUD hideHUDForView:self.view];
            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        }];
    }

    // 排号交易成功
    if ([model.contentType integerValue] == TXMessageStatusQueueTradeSuccess) {
        TXQueueTradeDetailViewController *vwcTradeDetail = [TXQueueTradeDetailViewController new];
        vwcTradeDetail.contentTypeId = model.contentTypeId;
        [self.navigationController pushViewController:vwcTradeDetail animated:true];
    }
    // 评论未通过
    if ([model.contentType integerValue] == TXMessageStatusCommentNotPass) {
        TXCommentNotPassViewController *vwcComment = [TXCommentNotPassViewController new];
        vwcComment.contentTypeId = model.contentTypeId;
        [self.navigationController pushViewController:vwcComment animated:true];
    }
    
    if ([model.contentType integerValue] == TXMessageStatusAppointmentRemind || [model.contentType integerValue] == TXMessageStatusCancelAppointment) {
        TXAppointmentDetailViewController *vwcAppointmentDetail = [TXAppointmentDetailViewController new];
        vwcAppointmentDetail.appointmentNo = model.contentTypeId;

        [TXCustomTools pushContainerVCWithParentVC:self childVC:vwcAppointmentDetail orderNo:model.contentTypeId indexPage:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - setters

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 108;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [TXCustomTools customHeaderRefreshWithScrollView:_tableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}

- (TXBlankView *)blankView {
    if (!_blankView) {
        _blankView = [[TXBlankView alloc]initWithFrame:CGRectMake(0, kTopHeight , SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _blankView.backgroundColor = [UIColor whiteColor];
    }
    return _blankView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
    
}

@end

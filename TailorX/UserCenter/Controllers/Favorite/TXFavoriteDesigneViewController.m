//
//  TXFavoriteDesigneViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/8/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFavoriteDesigneViewController.h"

#import "TXFavoriteDesignTableViewCell.h"
#import "TXBlankView.h"
#import "NetErrorView.h"
// M
#import "TXFavoriteDesignerListModel.h"
// C
#import "MSSBrowseNetworkViewController.h"
#import "TXDesignerDetailController.h"
// T
#import "TXFavoriteDataTool.h"
#import "AppDelegate.h"

#import "TXLocationManager.h"

@interface TXFavoriteDesigneViewController ()<UITableViewDelegate,UITableViewDataSource,NetErrorViewDelegate, TXFavoriteDesignTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *favoriteDesignerDataAarry;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) TXBlankView *blankView;
@property (nonatomic, strong) NetErrorView *netErrorView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, assign) BOOL isPullUp;
@property (nonatomic, assign) BOOL isPullDown;
/** 定位*/
@property (nonatomic, strong) TXLocationManager *locationManager;

@end

@implementation TXFavoriteDesigneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设计师";
    
    _page = 0;
    _pageLength = 10;
    _dataCount = 0;
    // 主界面
    [self setUpMainTableView];
    self.view.backgroundColor = RGB(247, 247, 247);
    adjustsScrollViewInsets_NO(self.mainTableView, self);
    // 数据加载
    [self.netErrorView showAddedTo:self.view isClearBgc:NO];
    // 实时获取金纬度，根据当前经纬度请求数据
    [self locate];
}


#pragma mark - load data
// 通知触发的刷新
- (void)reloadData {
    _page = 0;
    _isPullUp = NO;
    _isPullDown = YES;
    _dataCount = 0;
    [self.favoriteDesignerDataAarry removeAllObjects];
    
//    [self.netErrorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
    
    // 数组为0条时，刷新集合视图，以免页面重叠
    if (!self.favoriteDesignerDataAarry.count) {
        [self.mainTableView reloadData];
    }
}

- (void)locate {
    weakSelf(self);
    self.locationManager = [[TXLocationManager alloc]init];
    [self.locationManager locationManagerWithsuccess:^(NSString *cityName) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadData) object:nil];
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    } failure:^(NSError *error) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadData) object:nil];
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    }];
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:@(_page) forKey:@"page"];
    [param setValue:@(_pageLength) forKey:@"pageLength"];
    [param setValue:GetUserInfo.longitude forKey:@"longitude"];
    [param setValue:GetUserInfo.latitude forKey:@"latitude"];
    
    [TXNetRequest userCenterRequestMethodWithParams:param
                                        relativeUrl:strUserCenterGetFavoriteDesignerList
                                            success:^(id responseObject) {
                                                if ([responseObject[@"success"] boolValue]) { // 返回正确
                                                    
                                                    NSArray *dataAry = [TXFavoriteDataTool getFavoriteDesignerListArrayWith:responseObject];
                                                    [self.netErrorView stopNetViewLoadingFail:NO error:NO];
                                                    self.dataCount = dataAry.count;
                                                    // 请求回来列表数量为0
                                                    if (self.dataCount ==0 && !self.favoriteDesignerDataAarry.count) {
                                                        // 显示空白页
                                                        [self showBlankView];
                                                    } else {
                                                        [self.blankView removeFromSuperview];
                                                        // 普通加载或下拉刷新
                                                        if (!self.isPullUp) {
                                                            [self.favoriteDesignerDataAarry removeAllObjects];
                                                            [self.favoriteDesignerDataAarry addObjectsFromArray:dataAry];
                                                        }
                                                        // 上拉加载更多
                                                        else {
                                                            [self.favoriteDesignerDataAarry addObjectsFromArray:dataAry];
                                                        }

                                                        [self.mainTableView reloadData];
                                                    }
                                                } else {// 返回失败
                                                    //  有返回 但错误
                                                    [self checkNetStaus];
                                                    [self.netErrorView stopNetViewLoadingFail:NO error:YES];
                                                }
                                                [self.mainTableView.mj_header endRefreshing];
                                                [self.mainTableView.mj_footer endRefreshing];
                                            } failure:^(NSError *error) {
                                                //  无返回  netErrorView 的Bool 参数 （网络异常）
                                                [self checkNetStaus];
                                                [self.netErrorView stopNetViewLoadingFail:YES error:NO];
                                                [self.mainTableView.mj_header endRefreshing];
                                                [self.mainTableView.mj_footer endRefreshing];
                                            } isLogin:^{
                                                [self.mainTableView.mj_header endRefreshing];
                                                [self.mainTableView.mj_footer endRefreshing];
                                                [self.netErrorView stopNetViewLoadingFail:NO error:YES];
                                                [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                            }];
}

- (void)checkNetStaus {
    
    if (_isPullDown || _isPullUp) {
        [ShowMessage showMessage:kErrorTitle];
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
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_footer setState:MJRefreshStateIdle];
}
- (void)loadMoreData {
    _page += 1;
    _isPullUp = YES;
    _isPullDown = NO;
    if (_dataCount < _pageLength) {
        [self.mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

#pragma mark - UI

// 空白页
- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

- (void)setUpMainTableView {
    
    self.mainTableView = [UITableView tableWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)
                                               style:UITableViewStylePlain
                                           superView:self.view];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.mainTableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainTableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

#pragma mark --tableView delegate/dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteDesignerDataAarry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXFavoriteDesignerListModel *model = self.favoriteDesignerDataAarry[indexPath.row];
    TXFavoriteDesignTableViewCell *cell = [TXFavoriteDesignTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.designerModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TXFavoriteDesignerListModel *model = self.favoriteDesignerDataAarry[indexPath.row];
    if (![NSString isTextEmpty:model.productionPictures]) {
        return LayoutH(188);
    } else {
        return LayoutH(80);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    TXDesignerDetailController *designerDetailVc = [[TXDesignerDetailController alloc] init];
    designerDetailVc.bEnterStoreDetail = YES;
    TXFavoriteDesignerListModel *model= self.favoriteDesignerDataAarry[indexPath.row];
    designerDetailVc.designerId = [NSString stringWithFormat:@"%ld",(long)model.ID];
    designerDetailVc.isHavaCommitBtn = YES;
    [self.navigationController pushViewController:designerDetailVc animated:YES];
}

#pragma mark - netErrorView delegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    self.dataCount = 0;
    [self loadData];
}

#pragma mark - TXFavoriteDesignTableViewCellDelegate

- (void)tapImageViewWithIndex:(NSUInteger)index photoArray:(NSArray *)photoArray cell:(TXFavoriteDesignTableViewCell *)cell {

    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [photoArray count];i++) {
        NSString *imagePath = photoArray[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imagePath;// 加载网络图片大图地址
        
        if (i == 0) {
            browseItem.smallImageView = cell.designerOpusImg1;
        } else if (i == 1) {
            browseItem.smallImageView = cell.designerOpusImg2;
        } else {
            browseItem.smallImageView = cell.designerOpusImg3;
        }
        
        [browseItemArray addObject:browseItem];
    } 
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    [vwcBrowse showBrowseViewController];
}

- (void)cancelSaveDesignerWithDesignerModel:(TXFavoriteDesignerListModel *)designerModel {
    NSDictionary *dic = @{@"designerIds" : @(designerModel.ID)};
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [TXNetRequest informationRequestMethodWithParams:dic relativeUrl:strInformationDeleteFavoriteDesigner completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            if ([responseObject[@"success"] boolValue]) {
                [MBProgressHUD hideHUDForView:weakSelf.view];
                [ShowMessage showMessage:@"取消关注成功"];
                
                if ([weakSelf.favoriteDesignerDataAarry containsObject:designerModel]) {
                    [weakSelf.favoriteDesignerDataAarry removeObject:designerModel];
                }
                [self.mainTableView reloadData];
                if (self.favoriteDesignerDataAarry.count == 0) {
                    [self showBlankView];
                }
            }else {
                [MBProgressHUD hideHUDForView:weakSelf.view];
                [ShowMessage showMessage:@"取消关注失败，请重试"];
            }
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [ShowMessage showMessage:error.description];
        }
    }isLogin:^{
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}

#pragma mark --lazy

- (NSMutableArray *)favoriteDesignerDataAarry {
    if (nil == _favoriteDesignerDataAarry) {
        _favoriteDesignerDataAarry = [NSMutableArray array];
    }
    return _favoriteDesignerDataAarry;
}

- (TXBlankView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        [_blankView createBlankViewWithImage:@"ic_main_default_collect" title:@"还未收藏设计师"];
    }
    
    return _blankView;
}

- (NetErrorView *)netErrorView {
    
    if (_netErrorView == nil) {
        _netErrorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _netErrorView.delegate = self;
    }
    return _netErrorView;
    
}

- (void)dealloc {

}


@end

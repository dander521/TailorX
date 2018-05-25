//
//  HomeViewController.m
//  TailorX
//
//  Created by Roger on 17/3/14.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXHomeViewController.h"
#import "TXInformationDetailViewController.h"
#import "TXDesignerDetailController.h"
#import "TXHomeBannerWebController.h"
#import "TXSelectCityController.h"
#import "MSSBrowseNetworkViewController.h"
#import "TXStoreViewController.h"
#import "TXFashionViewController.h"
#import "TXStoreDetailController.h"
#import "TXTabBarController.h"
#import "HDMessageViewController.h"
#import "TXAllDesignerViewController.h"

#import "SDCycleScrollView.h"
#import "NetErrorView.h"
#import "TXFashionTabCell.h"
#import "TXStoreTabCell.h"
#import "TXStarDesignerTabCell.h"
#import "TXWaterfallColCell.h"

#import "TXHomeBannerModel.h"
#import "TXFindStarDesignerModel.h"
#import "TXTagGroupModel.h"
#import "TXDesignerProductionListModel.h"
#import "TXStroeListModel.h"

#import "AppDelegate.h"
#import "TXKfLoginManager.h"
#import "TXLocationManager.h"

/** 门店*/
static NSString *storeCellID = @"TXStoreTabCell";
/** 明星设计师*/
static NSString *starDesignerCellID = @"TXStarDesignerTabCell";
/** 时尚专区*/
static NSString *fashionTabCellID = @"TXFashionTabCell";

typedef NS_ENUM(NSInteger, TXTabViewCellType) {
    TXTabViewCellStore = 0,
    TXTabViewCellDesigner,
    TXTabViewCellFashion
};

@interface TXHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NetErrorViewDelegate,SDCycleScrollViewDelegate,TXStarDesignerTabCellDelegate,TXStoreTabCellDelegate>

/** 列表*/
@property (nonatomic, strong) UITableView *tableView;
/** 头部视图*/
@property (nonatomic, strong) SDCycleScrollView *headerView;
/** 精品推荐列表数据源*/
@property (nonatomic, strong) NSArray *recommendArr;
/** Banner数据*/
@property (nonatomic, strong) NSArray<TXHomeBannerModel*> *bannerModels;
/** 明星设计师列表*/
@property (nonatomic, strong) NSMutableArray<TXFindStarDesignerModel*> *starDesignerList;
/** 门店列表*/
@property (nonatomic, strong) NSMutableArray<TXStroeListModel*> *stroeListDataAry;
/** 精选图*/
@property (nonatomic, strong) NSMutableArray<TXTagGroupModel*> *tagGroups;
/** 时尚专区*/
@property (nonatomic, strong) NSMutableArray *fashionArr;
/** 定位*/
@property (nonatomic, strong) TXLocationManager *locationManager;
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
/** 城市*/
@property (nonatomic, strong) UIButton *cityBtn;
/** 设计师作品图*/
@property (nonatomic, strong) NSArray<TXDesignerProductionListModel*> *authorInfoArr;
/** 通知按钮 */
@property (nonatomic, strong) UIButton *notificationBtn;
/** 客服按钮按钮 */
@property (nonatomic, strong) UIButton *customerServiceItem;
/** 客服按钮图标名字 */
@property (nonatomic, strong) NSString *customerServiceIconName;
/** 保存之前的偏移量*/
@property (nonatomic, assign) CGFloat oldOffset;
/** 上拉*/
@property (nonatomic, assign, getter=isAnimationPullUp) BOOL animationPullUp;
/** 动画开始位置*/
@property (nonatomic, assign) CGFloat beginAnimationY;
/** 动画结束位置*/
@property (nonatomic, assign) CGFloat endAnimationY;

@end

@implementation TXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
    [self locate];
    
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    [TXKVPO setIsInfomation:@"0"];
    [TXKVPO setIsDiscover:@"0"];
    // 每次打开侧边栏 获取未读消息数量
    if ([[TXModelAchivar getUserModel] userLoginStatus]) {
        [TXNetRequest findUserUnreadMsgCount];
    }
    // 实时获取定位信息
    if ([GetUserInfo.currentCity isEqualToString:@"无法定位当前城市"]) {
        [self.cityBtn setTitle:@" " forState:UIControlStateNormal];
        [self.cityBtn setImage:[UIImage imageNamed:@"ic_nav_position_home"] forState:UIControlStateNormal];
        [self upDateButtomFrame:self.cityBtn];
    }else {
        [self.cityBtn setTitle:GetUserInfo.currentCity forState:UIControlStateNormal];
        [self.cityBtn setImage:[UIImage imageNamed:@"ic_nav_arrow_city"] forState:UIControlStateNormal];
        [self upDateButtomFrame:self.cityBtn];
    }
    GetUserInfo.isUnreadMessages == YES ? (self.customerServiceIconName = @"ic_nav_customer_service_prompt") : (self.customerServiceIconName = @"ic_nav_customer_service");
    
    // 处理 出现时轮播图卡在一半的问题
    [self.headerView adjustWhenControllerViewWillAppera];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notifation

/**
 用户登录状态变更
 */
- (void)userLoginstatusChanged {
    GetUserInfo.isUnreadMessages == YES ? (self.customerServiceIconName = @"ic_nav_customer_service_prompt") : (self.customerServiceIconName = @"ic_nav_customer_service");
    [self loadNewData];
}

- (void)RefreshHomeBanner {
    if (self.bannerModels.count == 0 || self.bannerModels == nil) {
        return;
    }else {
        [self.headerView scrollToIndex:(int)self.bannerModels.count*100];
    }
}

#pragma mark - init

- (void)initializeDataSource {
    
    self.tagGroups = [@[] mutableCopy];
    self.stroeListDataAry = [@[] mutableCopy];
    self.starDesignerList = [@[] mutableCopy];
    self.fashionArr = [NSMutableArray arrayWithCapacity:6];
    self.animationPullUp = false;
    self.pullUp = NO;
    self.pullDown = NO;
    self.beginAnimationY = 0.0;
    self.endAnimationY = 0.0;
    self.page = 0;
    self.dataCount = 0;
    self.pageLength = 100;
    
    [self loadData];
}

- (void)initializeInterface {
    
    adjustsScrollViewInsets_NO(self.tableView, self);
    
    self.navigationItem.title = @"TailorX";
    
    [self.view addSubview:self.tableView];
    
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.53+20)];
    headerBgView.backgroundColor = RGB(245, 245, 245);
    [headerBgView addSubview:self.headerView];
    self.tableView.tableHeaderView = headerBgView;
    
    [self.view addSubview:self.errorView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityBtn];
    leftItem.tintColor = RGB(138, 138, 138);
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItems = [self customRightNavItems];
}

#pragma mark - events

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshHomeBanner) name:kNSNotificationRefreshHomeBanner object:nil];
    // 用户成功登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationLoginSuccess  object:nil];
    // 退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationLogout object:nil];
    // 未读消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findUnreadMsgCount:) name:kNSNotificationFindUnreadMsgCount object:nil];
    // 未读客服消息通知（Y:有未读消息 N:无未读消息）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findNewServiceMessage:) name:kNSNotificationFindNewServiceMessage object:nil];
}

- (void)respondsToSelectCity {
    TXSelectCityController *vc = [TXSelectCityController new];
    weakSelf(self);
    vc.block = ^ (TXCityModel *model){
        SaveUserInfo(currentCity,  model.name);
        [weakSelf.cityBtn setTitle:model.name forState:UIControlStateNormal];
        [weakSelf upDateButtomFrame:self.cityBtn];
        [weakSelf accordingToTheCityToGetgoldLatitude:model.name];
    };
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;// 可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:vc animated:false];
}

- (void)respondsToCheckAllStotrListBtn {
    TXStoreViewController *vc = [TXStoreViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - methods

- (void)loadData {
    // 请求Banner图
    [TXNetRequest homeRequestMethodWithParams:nil relativeUrl:strHomeFindBannerList completion:^(id responseObject, NSError *error) {
        if (error) {
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                NSArray *dicArr = responseObject[kData];
                self.bannerModels = [TXHomeBannerModel mj_objectArrayWithKeyValuesArray:dicArr];
                NSMutableArray *urls = [@[]mutableCopy];
                if (self.bannerModels.count==0 || !self.bannerModels) {
                    
                }else {
                    for (TXHomeBannerModel *model in self.bannerModels) {
                        [urls addObject:model.banner];
                    }
                }
                self.headerView.imageURLStringsGroup = urls;
            }
        }
    } isLogin:^{
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
    
    // 请求时尚专区数据
    [TXNetRequest homeRequestMethodWithParams:nil relativeUrl:strHomeGetTagGroups completion:^(id responseObject, NSError *error) {
        if (error) {
            if (self.isPullUp || self.isPullDown) {
                [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            }else {
                [self.errorView stopNetViewLoadingFail:YES error:NO];
            }
            [self stopRefreshing];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                NSArray *dicArr = responseObject[kData];
                self.tagGroups = [TXTagGroupModel mj_objectArrayWithKeyValuesArray:dicArr];
                // 获取明星设计师列表
                [self getStarDesignerListData];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    [ShowMessage showMessage:responseObject[kMsg] withCenter:self.view.center];
                }else{
                    [self.errorView stopNetViewLoadingFail:NO error:YES];
                }
            }
            [self stopRefreshing];
        }
    } isLogin:^{
        [self stopRefreshing];
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/**
 * 获取明星设计师列表
 */
- (void)getStarDesignerListData {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.page] forKey:@"page"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.pageLength] forKey:@"pageLength"];
    [dict setValue:GetUserInfo.longitude forKey:@"longitude"];
    [dict setValue:GetUserInfo.latitude forKey:@"latitude"];
    
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeFindStarDesignerList completion:^(id responseObject, NSError *error) {
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
            if ([responseObject[kSuccess] boolValue]) {
                if (self.isPullDown && !self.isPullUp) {
                    [self.starDesignerList removeAllObjects];
                }
                NSArray *dicArr = responseObject[kData][kData];
                self.dataCount = dicArr.count;
                [self.starDesignerList addObjectsFromArray:[TXFindStarDesignerModel mj_objectArrayWithKeyValuesArray:dicArr]];
                NSMutableArray *tempArr = [@[]mutableCopy];
                NSMutableArray *tempNotArr  = [@[]mutableCopy];
                for (TXFindStarDesignerModel *model in self.starDesignerList) {
                    if ([NSString isTextEmpty:model.photo]) {
                        [tempNotArr addObject:model];
                    }else{
                        [tempArr addObject:model];
                    }
                }
                [tempArr addObjectsFromArray:tempNotArr];
                self.starDesignerList = tempArr;
                [self getStoreListInformation];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    //不做处理
                    _page = 0;
                }else {
                    [self.errorView stopNetViewLoadingFail:NO error:YES];
                }
            }
            [self stopRefreshing];
        }
    }isLogin:^{
        [self stopRefreshing];
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/*
 * 获取门店列表信息
 */
- (void)getStoreListInformation {
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:@(_page) forKey:@"page"];
    [dict setValue:@(_pageLength) forKey:@"pageLength"];
    [dict setValue:GetUserInfo.longitude forKey:@"longitude"];
    [dict setValue:GetUserInfo.latitude forKey:@"latitude"];
    
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strUserStoreAllList completion:^(id responseObject, NSError *error) {
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
            if ([responseObject[kSuccess] boolValue]) {
                if (self.isPullDown && !self.isPullUp) {
                    [self.stroeListDataAry removeAllObjects];
                }
                NSArray *dicArr = responseObject[kData][kData];
                self.dataCount = dicArr.count;
                [self.stroeListDataAry addObjectsFromArray:[TXStroeListModel mj_objectArrayWithKeyValuesArray:dicArr]];
                [self.tableView reloadData];
                [self.errorView stopNetViewLoadingFail:NO error:NO];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    //不做处理
                    _page = 0;
                }else {
                    [self.errorView stopNetViewLoadingFail:NO error:YES];
                }
            }
            [self stopRefreshing];
        }
    } isLogin:^{
        [self stopRefreshing];
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)stopRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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

/**
 * 计算文字的宽高
 */
- (CGSize)heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

/**
 * 刷新按钮的frame
 */
- (void)upDateButtomFrame:(UIButton *)sender {
    CGSize size = [self heightForString:sender.titleLabel.text fontSize:16 andWidth:SCREEN_WIDTH/2-30];
    sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, size.width+10, size.height);
    [sender setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [sender setImage:sender.imageView.image forState:UIControlStateNormal];
    [sender horizontalCenterTitleAndImage:5];
}

/**
 * 根据地名获取经纬度
 */
- (void)accordingToTheCityToGetgoldLatitude:(NSString*)addressName {
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:addressName completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSString *longitude = [NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.longitude];
            SaveUserInfo(longitude, longitude);
            NSString *latitude = [NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.latitude];
            SaveUserInfo(latitude, latitude);
            
            [self.starDesignerList removeAllObjects];
            [self.stroeListDataAry removeAllObjects];
            [self getStarDesignerListData];
        }
        else if ([placemarks count] == 0 && error == nil) {
          
        } else if (error != nil) {

        }  
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == TXTabViewCellFashion) {
        return self.tagGroups.count;
    }else {
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TXTabViewCellStore: {
            TXStoreTabCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCellID forIndexPath:indexPath];
            [cell.checkAllBtn addTarget:self action:@selector(respondsToCheckAllStotrListBtn) forControlEvents:UIControlEventTouchUpInside];
            cell.dataSource = self.stroeListDataAry;
            cell.delegate = self;
            return cell;
        }
            break;
        case TXTabViewCellDesigner: {
            TXStarDesignerTabCell *cell = [tableView dequeueReusableCellWithIdentifier:starDesignerCellID forIndexPath:indexPath];
            cell.dataSource = self.starDesignerList;
            cell.delegate = self;
            return cell;
        }
            break;
        case TXTabViewCellFashion: {
            TXFashionTabCell *cell = [tableView dequeueReusableCellWithIdentifier:fashionTabCellID forIndexPath:indexPath];
            cell.model = self.tagGroups[indexPath.row];
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TXTabViewCellFashion ) {
        TXFashionViewController *vc = [TXFashionViewController new];
        vc.infoGroupId = self.tagGroups[indexPath.row].ID;
        vc.naviTitle = self.tagGroups[indexPath.row].name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TXTabViewCellFashion && self.isAnimationPullUp) {
        TXFashionTabCell *fashionCell = (TXFashionTabCell *) cell;
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 3*indexPath.row + 5, 0)];
        scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        scaleAnimation.duration = 0.5;
        [fashionCell.layer addAnimation:scaleAnimation forKey:@"transform"];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginAnimationY = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.endAnimationY = scrollView.contentOffset.y;
    if (self.endAnimationY-self.beginAnimationY > 0) {
        self.animationPullUp = true;
    } else {
        self.animationPullUp = false;
    }
}

#pragma mark - TXStarDesignerTabCellDelegate

- (void)starDesignerTabCell:(TXStarDesignerTabCell *)cell didSelectItemOfIndex:(NSInteger)index {
    TXDesignerDetailController *vc = [TXDesignerDetailController new];
    vc.bEnterStoreDetail = YES;
    vc.designerId = [NSString stringWithFormat:@"%zd",self.starDesignerList[index].designerId];
    vc.isHavaCommitBtn = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchAllDesignerButton {
    TXAllDesignerViewController *vwcAllDesigner = [TXAllDesignerViewController new];
    vwcAllDesigner.isSelect = false;
    [self.navigationController pushViewController:vwcAllDesigner animated:true];
}

#pragma mark -  TXStoreTabCellDelegate

- (void)storeTabCell:(TXStoreTabCell *)cell didSelectItemOfIndex:(NSInteger)index {
    TXStroeListModel *model = self.stroeListDataAry[index];
    if (model.status == 0) {
        
        // 装修中
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"门店装修中，敬请期待"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }else {
        // 营业中
        TXStoreDetailController *storeDetailVc = [[TXStoreDetailController alloc] init];
        storeDetailVc.storeid = [NSString stringWithFormat:@"%ld",(long)model.ID];
        [self.navigationController pushViewController:storeDetailVc animated:YES];
    }
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark CoreLocation delegate

- (void)locate {
    weakSelf(self);
    self.locationManager = [[TXLocationManager alloc] init];
    [self.locationManager locationManagerWithsuccess:^(NSString *cityName) {
        weakSelf.cityBtn.hidden = NO;
        if ([cityName isEqualToString:@"无法定位当前城市"]) {
            [weakSelf.cityBtn setTitle:@" " forState:UIControlStateNormal];
            [weakSelf.cityBtn setImage:[UIImage imageNamed:@"ic_nav_position_home"] forState:UIControlStateNormal];
            [weakSelf upDateButtomFrame:weakSelf.cityBtn];
        }else {
            [weakSelf.cityBtn setTitle:cityName forState:UIControlStateNormal];
            [weakSelf.cityBtn setImage:[UIImage imageNamed:@"ic_nav_arrow_city"] forState:UIControlStateNormal];
            [weakSelf upDateButtomFrame:weakSelf.cityBtn];
        }
    } failure:^(NSError *error) {
        weakSelf.cityBtn.hidden = NO;
        [weakSelf.cityBtn setTitle:@" " forState:UIControlStateNormal];
        [weakSelf.cityBtn setImage:[UIImage imageNamed:@"ic_nav_position_home"] forState:UIControlStateNormal];
        [weakSelf upDateButtomFrame:weakSelf.cityBtn];
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    TXHomeBannerModel *model = self.bannerModels[index];
    // 0：代表input传递的是一个链接 1：代表input传递的是设计师ID
    if (model.type == 1) {
        TXDesignerDetailController *vc = [TXDesignerDetailController new];
        vc.bEnterStoreDetail = YES;
        vc.isHavaCommitBtn = YES;
        vc.designerId = model.input;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.type == 2){
        TXInformationDetailViewController *vc = [TXInformationDetailViewController new];
        vc.informationNo = model.informationNo;
        vc.coverUrl = model.banner;
        vc.coverImgWidth = SCREEN_WIDTH - 20;
        vc.coverImgHeight = SCREEN_WIDTH*0.53;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        TXHomeBannerWebController *vc = [TXHomeBannerWebController new];
        vc.requestUrl = model.input;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Touch Method

/**
 * 点击通知按钮
 */
- (void)touchNotificationBtn {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]){
        [[AppDelegate sharedAppDelegate].tabBarVc.selectedViewController pushViewController:[NSClassFromString(@"TXNotificationViewController") new] animated:YES];
    }
}

/**
 * 点击客服按钮
 */
- (void)touchCustomerServiceBtn {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]){
        // 注册及登录环信用户
        if (GetUserInfo.hxLoginStatus) {
            [self pushMsgVc];
        }else {
            MBProgressHUD *hud = [MBProgressHUD showMessage:@"连接客服" toView:self.view];
            [TXKfLoginManager loginKefuSDKcomplete:^(bool success) {
                SaveUserInfo(hxLoginStatus, success);
                [hud hide:YES afterDelay:0];
                if (success) {
                    [self pushMsgVc];
                }else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ShowMessage showMessage:@"客服连接失败，请稍后再试"];
                    });
                }
            }];
        }
    }
}

- (void)pushMsgVc {
    HDMessageViewController *msgVc = [[HDMessageViewController alloc] initWithConversationChatter:KF_IMId];
    HQueueIdentityInfo *queueInfo = [HQueueIdentityInfo new];
    queueInfo.queueIdentity = KF_QueueInfo;
    msgVc.queueInfo = queueInfo;
    
    msgVc.title = @"TailorX客服";
    
    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
    visitor.name = [NSString stringWithFormat:@"%zd", [TXModelAchivar getUserModel].userId];
    visitor.phone = [TXModelAchivar getUserModel].phone;
    visitor.nickName = [TXModelAchivar getUserModel].nickName;

    msgVc.visitorInfo = visitor;
    
    // 删除聊天记录
    if (![NSString isTextEmpty:GetUserInfo.lastLoginAccount]) {
        if (![GetUserInfo.accountA isEqualToString:GetUserInfo.lastLoginAccount]) {
            [msgVc.conversation deleteAllMessages:nil];
            SaveUserInfo(lastLoginAccount, GetUserInfo.accountA);
        }
    }
    
    [self.navigationController pushViewController:msgVc animated:YES];
}

#pragma mark - Notification

- (void)findUnreadMsgCount:(NSNotification *)notification {
    if ([TXUserModel defaultUser].unreadMsgCount == 0) {
        [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information"] forState:UIControlStateNormal];
    } else {
        [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information_prompt"] forState:UIControlStateNormal];
    }
}

- (void)findNewServiceMessage:(NSNotification *)sender {
    [sender.object boolValue] == YES ? (self.customerServiceIconName = @"ic_nav_customer_service_prompt") : (self.customerServiceIconName = @"ic_nav_customer_service");
}

#pragma mark - setters

- (void)setCustomerServiceIconName:(NSString *)customerServiceIconName {
    _customerServiceIconName = customerServiceIconName;
    [self.navigationItem.rightBarButtonItems[0] setImage:[UIImage imageWithOriginalName:customerServiceIconName]];
}

#pragma mark - getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - kTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:storeCellID bundle:nil] forCellReuseIdentifier:storeCellID];
        [_tableView registerNib:[UINib nibWithNibName:starDesignerCellID bundle:nil] forCellReuseIdentifier:starDesignerCellID];
        [_tableView registerNib:[UINib nibWithNibName:fashionTabCellID bundle:nil] forCellReuseIdentifier:fashionTabCellID];
        [TXCustomTools customHeaderRefreshWithScrollView:_tableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SDCycleScrollView *)headerView {
    if (!_headerView) {
        _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 10, SCREEN_WIDTH,SCREEN_WIDTH*0.53) delegate:self placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        _headerView.autoScrollTimeInterval = 3;
        _headerView.pageDotImage = [UIImage imageNamed:@"ic_main_by_switching_circle.png"];
        _headerView.currentPageDotImage = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_main_by_switching"];
        _headerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _headerView.backgroundColor = RGB(240, 240, 240);
        _headerView.showPageControl = NO;
        _headerView.cellSpace = 10;
        _headerView.infiniteLoop = YES;
        _headerView.boworrWidth = (SCREEN_WIDTH - 40);
        _headerView.imageViewRoundedCorner = 5;
    }
    return _headerView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
}

- (UIButton *)cityBtn {
    if (!_cityBtn) {
        _cityBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _cityBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_cityBtn setImage:[UIImage imageNamed:@"ic_nav_position_home"] forState:UIControlStateNormal];
        [_cityBtn setTitleColor:RGB(138, 138, 138) forState:UIControlStateNormal];
        [_cityBtn addTarget:self action:@selector(respondsToSelectCity) forControlEvents:UIControlEventTouchUpInside];
        _cityBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cityBtn.hidden = YES;
    }
    return _cityBtn;
}

- (NSArray *)customRightNavItems {
    _notificationBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _notificationBtn.tag = 10000;
    _notificationBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([TXUserModel defaultUser].unreadMsgCount == 0) {
        [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information"] forState:UIControlStateNormal];
    } else {
        [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information_prompt"] forState:UIControlStateNormal];
    }
    [_notificationBtn setTitleColor:RGB(138, 138, 138) forState:UIControlStateNormal];
    [_notificationBtn addTarget:self action:@selector(touchNotificationBtn) forControlEvents:UIControlEventTouchUpInside];
    _notificationBtn.frame = CGRectMake(0, 0, 44, 44);
    _notificationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 3, -12);
    UIBarButtonItem *notificationItem = [[UIBarButtonItem alloc]initWithCustomView:_notificationBtn];

    UIBarButtonItem *customerServiceItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithOriginalName:@"ic_nav_customer_service"] style:UIBarButtonItemStylePlain target:self action:@selector(touchCustomerServiceBtn)];
    return @[customerServiceItem, notificationItem];
}

@end

//
//  TXDiscoveViewController.m
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDiscoveViewController.h"
#import "TXDiscoverTopView.h"
#import "TXDiscoverFilterView.h"
#import "TXFindAllTagsModel.h"
#import "AppDelegate.h"
#import "TXFromTransition.h"
#import "TXDesignerDetailController.h"
#import "TXDiscoverDetailCollectionViewController.h"
#import "TXSearchResultViewController.h"

@interface TXDiscoveViewController ()<TXLatestReleaseViewDelegate,TXHeatViewDelegate,TXDiscoverTopViewDelegate,UINavigationControllerDelegate>

/** 顶部视图*/
@property (nonatomic, strong) TXDiscoverTopView *topView;
/** 筛选页面*/
@property (nonatomic, strong) TXDiscoverFilterView *filterView;
/** 筛选数据*/
@property (nonatomic, strong) TXFindAllTagsModel *tagModels;
/** (显示方式 1：最新排序 2：热度优先) */
@property (nonatomic, strong) NSString *showMethd;
/** 右侧视图 */
@property (nonatomic, strong) UIButton *notificationBtn;
/** 右侧视图 */
@property (nonatomic, strong) UIButton *customerServiceBtn;
/** 客服按钮图标名字 */
@property (nonatomic, strong) NSString *customerServiceIconName;
/** 当前偏移量 */
@property (nonatomic, strong) UIView *underLineView;
/** 当前偏移位置 */
@property (nonatomic, assign) float currentOffsetY;
/** 是否为向上滑动 隐藏导航栏 */
@property (nonatomic, assign) BOOL isPullUp;
/** 顶部自定义视图 */
@property (nonatomic, strong) UIView *customTopView;
/** 导航条阴影*/
@property (nonatomic, strong) UIView *shadowView;
/** 导航条文字 */
@property (nonatomic, strong) UILabel *navTitleLabel;

@end

@implementation TXDiscoveViewController {
    CGFloat beginContentY;          //开始滑动的位置
    CGFloat endContentY;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeDataSource];
    
    [self initializeInterface];

    // 未读消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findUnreadMsgCount:) name:kNSNotificationFindUnreadMsgCount object:nil];
    // 未读客服消息通知（Y:有未读消息 N:无未读消息）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findNewServiceMessage:) name:kNSNotificationFindNewServiceMessage object:nil];
    // 用户退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationLogout object:nil];
    // 单击DiscoverItem
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickDiscoverItemSingleTap) name:kNotificationDiscoverItemSingleTap object:nil];
    // 双击DiscoverItem
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickDiscoverItemDoubleTap) name:kNotificationDiscoverItemDoubleTap object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     GetUserInfo.isUnreadMessages == YES ? (self.customerServiceIconName = @"ic_nav_customer_service_prompt") : (self.customerServiceIconName = @"ic_nav_customer_service");
    [TXKVPO setIsInfomation:@"0"];
    [TXKVPO setIsDiscover:@"1"];
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController.delegate) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark - init

- (void)initializeDataSource {
    self.currentOffsetY = 0.0;
    self.showMethd = @"1";
    self.isPullUp = false;
    [self loadData];
}

- (void)initializeInterface {
    [self.view addSubview:self.latestReleaseView];
    weakSelf(self);
    self.latestReleaseView.refreshBlock = ^ () {
        [weakSelf loadData];
    };
    
    self.currenCollectionView = self.latestReleaseView.collectionView;
    
    [self.view addSubview:self.heatView];
    self.heatView.refreshBlock = ^ () {
        [weakSelf loadData];
    };
    
    [self.view addSubview:self.customTopView];
}

#pragma mark - methods

- (void)loadData {
    [TXNetRequest homeRequestMethodWithParams:nil relativeUrl:strDiscoverFindAllTags completion:^(id responseObject, NSError *error) {
        if (error) {
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                TXFindAllTagsModel *tempTagModel = [TXFindAllTagsModel mj_objectWithKeyValues:responseObject[kData]];
                if (self.tagModels == nil) {
                    self.tagModels = tempTagModel;
                }else {
                    // 记录之前的值
                    for (TagInfo *tempTag in tempTagModel.systemTags.sex) {
                        for (TagInfo *tag in self.tagModels.systemTags.sex) {
                            if (tag.isSelected && [tag.tagName isEqualToString:tempTag.tagName]) {
                                tempTag.isSelected = YES;
                                return;
                            }
                        }
                    }
                    for (TagInfo *tempTag in tempTagModel.systemTags.style) {
                        for (TagInfo *tag in self.tagModels.systemTags.style) {
                            if (tag.isSelected && [tag.tagName isEqualToString:tempTag.tagName]) {
                                tempTag.isSelected = YES;
                                return;
                            }
                        }
                    }
                    for (TagInfo *tempTag in tempTagModel.systemTags.season) {
                        for (TagInfo *tag in self.tagModels.systemTags.season) {
                            if (tag.isSelected && [tag.tagName isEqualToString:tempTag.tagName]) {
                                tempTag.isSelected = YES;
                                return;
                            }
                        }
                    }
                    for (TagInfo *tempTag in tempTagModel.commonTags) {
                        for (TagInfo *tag in self.tagModels.commonTags) {
                            if (tag.isSelected && [tag.tagName isEqualToString:tempTag.tagName]) {
                                tempTag.isSelected = YES;
                            }
                        }
                    }
                    self.tagModels = tempTagModel;
                }
                self.filterView.tagModels = self.tagModels;
            }else{
            }
        }
    }isLogin:^{
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - TXDiscoverTopViewDelegate

- (void)touchLatestBtn {
    self.showMethd = @"1";
    [self showLatestReleaseView];
}

- (void)touchHeatBtn {
    self.showMethd = @"2";
    [self showHeatView];
}

- (void)showLatestReleaseView {
    self.latestReleaseView.hidden = NO;
    self.heatView.hidden = YES;
    self.currenCollectionView = self.latestReleaseView.collectionView;
}

- (void)showHeatView {
    self.heatView.hidden = NO;
    self.latestReleaseView.hidden = YES;
    self.currenCollectionView = self.heatView.collectionView;
}

- (void)touchFilterBtn {
    if (self.tagModels == nil) {
        [ShowMessage showMessage:@"未获取到筛选数据，请在当前页面刷新"];
        return;
    }
    [self.filterView showWithSure:^(NSMutableDictionary *tagInfo) {
         
         [self.latestReleaseView.param setValue:@"1" forKey:@"showMethd"];
         [self.latestReleaseView.param setValue:[tagInfo valueForKey:@"sexTagId"] forKey:@"sexTagId"];
         [self.latestReleaseView.param setValue:[tagInfo valueForKey:@"styleTagId"] forKey:@"styleTagId"];
         [self.latestReleaseView.param setValue:[tagInfo valueForKey:@"seasonTagId"] forKey:@"seasonTagId"];
         [self.latestReleaseView.param setValue:[tagInfo valueForKey:@"tags"] forKey:@"tags"];
//         [self.latestReleaseView.errorView showAddedTo:self.latestReleaseView isClearBgc:NO];
         [self.latestReleaseView.collectionView.mj_header beginRefreshing];
         
         [self.heatView.param setValue:@"2" forKey:@"showMethd"];
         [self.heatView.param setValue:[tagInfo valueForKey:@"sexTagId"] forKey:@"sexTagId"];
         [self.heatView.param setValue:[tagInfo valueForKey:@"styleTagId"] forKey:@"styleTagId"];
         [self.heatView.param setValue:[tagInfo valueForKey:@"seasonTagId"] forKey:@"seasonTagId"];
         [self.heatView.param setValue:[tagInfo valueForKey:@"tags"] forKey:@"tags"];
//         [self.heatView.errorView showAddedTo:self.heatView isClearBgc:NO];
         [self.heatView.collectionView.mj_header beginRefreshing];
    }];
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
//    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]){
//        // 注册及登录环信用户
//        if (GetUserInfo.hxLoginStatus) {
//            [self pushMsgVc];
//        }else {
//            MBProgressHUD *hud = [MBProgressHUD showMessage:@"连接客服" toView:self.view];
//            [TXKfLoginManager loginKefuSDKcomplete:^(bool success) {
//                SaveUserInfo(hxLoginStatus, success);
//                [hud hide:YES afterDelay:0];
//                if (success) {
//                    [self pushMsgVc];
//                }else {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [ShowMessage showMessage:@"客服连接失败，请稍后再试"];
//                    });
//                }
//            }];
//        }
//    }
     
     UIView *snapshot = [[AppDelegate sharedAppDelegate].window snapshotViewAfterScreenUpdates:NO];
     UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
     UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
     effe.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
     effe.alpha = 1.0;
     [snapshot addSubview:effe];
     // 处理3.3.5逻辑
     TXSearchResultViewController *vwcSearch = [TXSearchResultViewController new];
     vwcSearch.snapshotView = snapshot;
     [self.navigationController pushViewController:vwcSearch animated:true];
}

- (void)pushMsgVc {
    HDMessageViewController *msgVc = [[HDMessageViewController alloc]initWithConversationChatter:KF_IMId];
    HQueueIdentityInfo *queueInfo = [HQueueIdentityInfo new];
    queueInfo.queueIdentity = KF_QueueInfo;
    msgVc.queueInfo = queueInfo;
    
    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
    visitor.name = [NSString stringWithFormat:@"%zd", [TXModelAchivar getUserModel].userId];
    visitor.phone = [TXModelAchivar getUserModel].phone;
    visitor.nickName = [TXModelAchivar getUserModel].nickName;
     
    msgVc.visitorInfo = visitor;
    
    msgVc.title = @"TailorX客服";
    // 判断本次登录与上次登录的用户是否相同，如果不同则删除聊天记录
    if (![NSString isTextEmpty:GetUserInfo.lastLoginAccount]) {
        if (![GetUserInfo.accountA isEqualToString:GetUserInfo.lastLoginAccount]) {
            [msgVc.conversation deleteAllMessages:nil];
            SaveUserInfo(lastLoginAccount, GetUserInfo.accountA);
        }
    }
    [self.navigationController pushViewController:msgVc animated:YES];
}

#pragma mark - Notification

/**
 用户登录状态变更
 */
- (void)userLoginstatusChanged {
    GetUserInfo.isUnreadMessages == YES ? (self.customerServiceIconName = @"ic_nav_customer_service_prompt") : (self.customerServiceIconName = @"ic_nav_customer_service");
}

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

- (void)clickDiscoverItemSingleTap {
    [self.currenCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)clickDiscoverItemDoubleTap {
    [self.currenCollectionView.mj_header beginRefreshing];
}

#pragma mark - TXLatestReleaseControllerDelegate

- (void)touchHeatDesignerButtonWithDesignerId:(NSString *)designerId {
    if ([NSString isTextEmpty:designerId]) {
        return;
    }
    TXDesignerDetailController *vc = [TXDesignerDetailController new];
    vc.designerId = designerId;
    vc.isHavaCommitBtn = true;
    vc.bEnterStoreDetail = true;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchLatestDesignerButtonWithDesignerId:(NSString *)designerId {
    if ([NSString isTextEmpty:designerId]) {
        return;
    }
    TXDesignerDetailController *vc = [TXDesignerDetailController new];
    vc.designerId = designerId;
    vc.isHavaCommitBtn = true;
    vc.bEnterStoreDetail = true;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)customScrollScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    beginContentY = scrollView.contentOffset.y;
}

- (void)customScrollScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    endContentY = scrollView.contentOffset.y;
    if (endContentY - beginContentY > 60) {
        self.isPullUp = true;
        [self hideNavigationBarAndTopView];
    } else if (beginContentY - endContentY > 60) {
        self.isPullUp = false;
        [self showNavigationBarAndTopView];
    }
}

- (void)scrollLatestScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self customScrollScrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollLatestScrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self customScrollScrollViewWillBeginDragging:scrollView];
}

- (void)scrollHeatScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self customScrollScrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollHeatScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self customScrollScrollViewWillBeginDragging:scrollView];
}


- (void)showNavigationBarAndTopView {
    self.shadowView.hidden = NO;
    self.latestReleaseView.frame = CGRectMake(0, 50 + kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - kTopHeight - kTabBarHeight);
    self.heatView.frame = CGRectMake(0, 50 + kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - kTopHeight - kTabBarHeight);
    [UIView animateWithDuration:0.25 animations:^{
        self.customTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50 + kTopHeight);
        self.navTitleLabel.alpha = 1;
        self.customerServiceBtn.alpha = 1;
        self.notificationBtn.alpha = 1;
    }];
}

- (void)hideNavigationBarAndTopView {
    self.shadowView.hidden = YES;
    self.latestReleaseView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - kTabBarHeight);
    self.heatView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - kTabBarHeight);
    [UIView animateWithDuration:0.25 animations:^{
        self.customTopView.frame = CGRectMake(0, -50, SCREEN_WIDTH, 50 + kTopHeight);
        self.navTitleLabel.alpha = 0;
        self.customerServiceBtn.alpha = 0;
        self.notificationBtn.alpha = 0;
    }];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([fromVC isKindOfClass:[TXDiscoveViewController class]] && [toVC isKindOfClass:[TXDiscoverDetailCollectionViewController class]]) {
        return [[TXFromTransition alloc] initWithTransitionType:TransitionPicture];
    }else {
        return nil;
    }
}


#pragma mark - setters

- (void)setCustomerServiceIconName:(NSString *)customerServiceIconName {
//    _customerServiceIconName = customerServiceIconName;
//    [_customerServiceBtn setImage:[UIImage imageWithOriginalName:customerServiceIconName] forState:UIControlStateNormal];
}

#pragma mark - getters

- (UIView *)customTopView {
    if (!_customTopView) {
        _customTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50 + kTopHeight)];
        _customTopView.backgroundColor = [UIColor whiteColor];
        
        UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight + 49)];
        
        _notificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _notificationBtn.frame = CGRectMake(SCREEN_WIDTH - 94, kTopHeight - 44, 40, 44);
        if ([TXUserModel defaultUser].unreadMsgCount == 0) {
            [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information"] forState:UIControlStateNormal];
        } else {
            [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information_prompt"] forState:UIControlStateNormal];
        }
        _notificationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
         _notificationBtn.hidden = true;
        [_notificationBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [_notificationBtn setBackgroundColor:[UIColor clearColor]];
        [_notificationBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
        [_notificationBtn addTarget:self action:@selector(touchNotificationBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _customerServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _customerServiceBtn.frame = CGRectMake(SCREEN_WIDTH - 47.5, kTopHeight - 44, 40, 44);
        [_customerServiceBtn setImage:[UIImage imageNamed:@"ic_nav_search"] forState:UIControlStateNormal];
        [_customerServiceBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [_customerServiceBtn setBackgroundColor:[UIColor clearColor]];
        [_customerServiceBtn addTarget:self action:@selector(touchCustomerServiceBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopHeight - 32, SCREEN_WIDTH, 20)];
        _navTitleLabel.text = @"Discover";
        _navTitleLabel.textColor = RGB(46, 46, 46);
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:17];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight + 48)];
        self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
        self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
        self.shadowView.layer.shadowOpacity = 0.5;
        self.shadowView.backgroundColor = [UIColor whiteColor];
        [naviView addSubview:self.shadowView];
        
        [naviView addSubview:_navTitleLabel];
        [naviView addSubview:_notificationBtn];
        [naviView addSubview:_customerServiceBtn];
        [_customTopView addSubview:naviView];

        [_customTopView addSubview:self.topView];
//        [_customTopView insertSubview:naviView aboveSubview:self.topView];
    }
    
    return _customTopView;
}

- (TXDiscoverTopView *)topView {
    if (!_topView) {
        _topView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXDiscoverTopView" owner:nil options:nil] lastObject];
        _topView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, 50);
        _topView.delegate = self;
    }
    return _topView;
}

- (TXDiscoverFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[[NSBundle mainBundle] loadNibNamed:@"TXDiscoverFilterView" owner:nil options:nil] lastObject];
    }
    return _filterView;
}

- (TXLatestReleaseViewController *)latestReleaseView {
    if (!_latestReleaseView) {
        _latestReleaseView = [[TXLatestReleaseViewController alloc]initWithFrame:CGRectMake(0, 50 + kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - kTopHeight - kTabBarHeight)];
        _latestReleaseView.delegate = self;
    }
    return _latestReleaseView;
}

- (TXHeatViewController *)heatView {
     if (!_heatView) {
         _heatView = [[TXHeatViewController alloc]initWithFrame:CGRectMake(0, 50 + kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - kTopHeight - kTabBarHeight)];
         _heatView.delegate = self;
         _heatView.hidden = YES;
     }
    return _heatView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

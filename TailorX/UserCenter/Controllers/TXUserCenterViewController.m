//
//  UTLeftMenuViewController.m
//  WQTabBarDemo
//
//  Created by yons on 16/10/31.
//  Copyright © 2016年 yons. All rights reserved.
//

#import "TXUserCenterViewController.h"
#import "AppDelegate.h"
#import "TXUserCenterTableViewCell.h"
#import "TXUserCenterTableHeaderView.h"
#import "TXPersonalInfoViewController.h"
#import "TXFavoriteDesigneViewController.h"
#import "RCExpandHeader.h"

@interface TXUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource, TXUserCenterTableHeaderViewDelegate>

/** TableView */
@property (nonatomic, strong) UITableView *userCenterTableView;
/** cell 内容 */
@property (nonatomic, copy) NSArray *cellContents;
/** 右侧视图 */
@property (nonatomic, strong) UIView *customRightNavView;
/** 右侧视图 */
@property (nonatomic, strong) UIButton *notificationBtn;
/** 右侧视图 */
@property (nonatomic, strong) UIButton *customerBtn;
/** 客服按钮图标名字 */
@property (nonatomic, strong) NSString *customerServiceIconName;

@property (nonatomic, strong) TXUserCenterTableHeaderView *headerView;

@end

@implementation TXUserCenterViewController{
    RCExpandHeader *_header;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加通知
    [self addUserInfoNotification];
    // 设置页面属性
    [self configViewController];
    // 初始化自控制器的标签
    [self setUpArrays];
    // 初始化tableView
    [self setUpContentTableView];
    
    [self setUpRightButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TXKVPO setIsInfomation:@"0"];
    [TXKVPO setIsDiscover:@"0"];
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = true;
    GetUserInfo.isUnreadMessages == YES ? (self.customerServiceIconName = @"ic_nav_customer_service_prompt") : (self.customerServiceIconName = @"ic_nav_customer_service");
    if ([[TXModelAchivar getUserModel] userLoginStatus]) {
        [TXNetRequest findUserUnreadMsgCount];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - NSNotification Method

/**
 添加通知
 */
- (void)addUserInfoNotification {
    // 未读消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findUnreadMsgCount:) name:kNSNotificationFindUnreadMsgCount object:nil];
    // 头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationChangeUserAvatar object:nil];
    // 昵称
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationChangeUserNickName object:nil];
    // 用户成功登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationLoginSuccess object:nil];
    // 退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationLogout object:nil];
    // 未读客服消息通知（Y:有未读消息 N:无未读消息）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findNewServiceMessage:) name:kNSNotificationFindNewServiceMessage object:nil];
}

#pragma mark - Initial Method

/**
 设置页面属性
 */
- (void)configViewController {
    self.view.backgroundColor = RGB(245, 245, 245);
}

/**
 * 初始化自控制器的标签(tableViewcell的内容)
 */
- (void)setUpArrays {
    self.cellContents = @[@[LocalSTR(@"Str_Order_Manager"),
                            LocalSTR(@"Str_Personal_Wallet"),
                            @"关注",
                            LocalSTR(@"Str_Favorite"),
                            LocalSTR(@"Str_Setting")],
                          @[@"ic_main_list_3.2.1",
                            @"ic_main_meney_3.2.1",
                            @"ic_main_follow",
                            @"ic_main_collect_3.2.1",
                            @"ic_main_set_3.2.1"]];
}

/**
 设置明细按钮
 */
- (void)setUpRightButton {
    _notificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _notificationBtn.frame = CGRectMake(SCREEN_WIDTH - 94, kTopHeight - 44, 40, 44);
    if ([TXUserModel defaultUser].unreadMsgCount == 0) {
        [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information"] forState:UIControlStateNormal];
    } else {
        [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information_prompt"] forState:UIControlStateNormal];
    }
    _notificationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_notificationBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [_notificationBtn setBackgroundColor:[UIColor clearColor]];
    [_notificationBtn addTarget:self action:@selector(touchNotificationBtn) forControlEvents:UIControlEventTouchUpInside];
    _notificationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);
    _customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _customerBtn.frame = CGRectMake(SCREEN_WIDTH - 52.5, kTopHeight - 44, 40, 44);
    [_customerBtn setImage:[UIImage imageNamed:@"ic_nav_customer_service"] forState:UIControlStateNormal];
    _customerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_customerBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [_customerBtn setBackgroundColor:[UIColor clearColor]];
    [_customerBtn addTarget:self action:@selector(touchCustomerServiceBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_notificationBtn];
    [self.view addSubview:_customerBtn];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.userCenterTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-kTabBarHeight) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.scrollEnabled = true;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundColor = RGB(245, 245, 245);
        tableView.bounces = true;
        tableView;
    });
    
    _header = [RCExpandHeader expandWithScrollView:self.userCenterTableView expandView:[self tableHeaderView]];
    self.userCenterTableView.tableFooterView = [self tableFooterView];
    [self.view addSubview:self.userCenterTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[self.cellContents firstObject]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXUserCenterTableViewCell *cell = [TXUserCenterTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_None;
    [cell configCellWithIndexPath:indexPath cellArray:self.cellContents];

    return cell;
}

#pragma mark - UITableViewDelegate

/**
 * 在此跳转子控制器
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row != 4) {
        TXNavigationViewController *target = [AppDelegate sharedAppDelegate].tabBarVc.selectedViewController;
        // 登录
        NSLog(@"%@",target);
        if (![TXServiceUtil LoginController:target]) {
            return;
        }
    }
    
    NSArray *controllerArray = @[@"TXOrdersDisplayViewController",
                                 @"TXPersonalWalletViewController",
                                 @"TXFavoriteDesigneViewController",
                                 @"TXFavoriteViewController",
                                 @"TXSettingViewController"];
    
    [[AppDelegate sharedAppDelegate].tabBarVc.selectedViewController pushViewController:[NSClassFromString(controllerArray[indexPath.row]) new] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

#pragma mark - TXUserCenterTableHeaderViewDelegate

/**
 点击用户默认头像
 */
- (void)tapUserAvatarImageView {
    TXNavigationViewController *target = [AppDelegate sharedAppDelegate].tabBarVc.selectedViewController;
    if (![TXServiceUtil LoginController:target]) {
        return;
    } else {
        TXPersonalInfoViewController *vwcPersonal = [TXPersonalInfoViewController new];
        [[AppDelegate sharedAppDelegate].tabBarVc.selectedViewController pushViewController:vwcPersonal animated:YES];
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
    HDMessageViewController *msgVc = [[HDMessageViewController alloc]initWithConversationChatter:KF_IMId];
    msgVc.title = @"TailorX客服";
    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
    visitor.name = [NSString stringWithFormat:@"%zd", [TXModelAchivar getUserModel].userId];
    visitor.phone = [TXModelAchivar getUserModel].phone;
    visitor.nickName = [TXModelAchivar getUserModel].nickName;
    msgVc.visitorInfo = visitor;
    // 判断本次登录与上次登录的用户是否相同，如果不同则删除聊天记录
    if (![NSString isTextEmpty:GetUserInfo.lastLoginAccount]) {
        if (![GetUserInfo.accountA isEqualToString:GetUserInfo.lastLoginAccount]) {
            [msgVc.conversation deleteAllMessages:nil];
            SaveUserInfo(lastLoginAccount, GetUserInfo.accountA);
        }
    }
    [self.navigationController pushViewController:msgVc animated:YES];
}

#pragma mark - setters

- (void)setCustomerServiceIconName:(NSString *)customerServiceIconName {
    _customerServiceIconName = customerServiceIconName;
    [self.customerBtn setImage:[UIImage imageNamed:customerServiceIconName]forState:UIControlStateNormal];
}


#pragma mark - Custom Method

- (UIView *)tableHeaderView {
    _headerView = [TXUserCenterTableHeaderView instanceView];
    [_headerView configHeaderViewWithDictionary:nil];
    _headerView.delegate = self;
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
    return _headerView;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20)];
    footerLabel.text = @"～有一些回忆，需要用设计填满～";
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.font = [UIFont systemFontOfSize:13];
    footerLabel.textColor = RGB(204, 204, 204);
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:footerLabel];
    return footerView;
}

- (void)findNewServiceMessage:(NSNotification *)sender {
    [sender.object boolValue] == YES ? ([self.customerBtn setImage:[UIImage imageNamed:@"ic_nav_customer_service_prompt"] forState:UIControlStateNormal]) : ([self.customerBtn setImage:[UIImage imageNamed:@"ic_nav_customer_service"] forState:UIControlStateNormal]);
}

/**
 修改用户信息通知方法
 
 @param notification
 */
- (void)changeUserInfoNotification:(NSNotification *)notification {
    GetUserInfo.isUnreadMessages == YES ? ([self.customerBtn setImage:[UIImage imageNamed:@"ic_nav_customer_service_prompt"] forState:UIControlStateNormal]) : ([self.customerBtn setImage:[UIImage imageNamed:@"ic_nav_customer_service"] forState:UIControlStateNormal]);
    
    NSDictionary *dicUserInfo = notification.userInfo;
    [_headerView configHeaderViewWithDictionary:dicUserInfo];
}

- (void)findUnreadMsgCount:(NSNotification *)notification {
    if ([TXUserModel defaultUser].unreadMsgCount == 0) {
        [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information"] forState:UIControlStateNormal];
    } else {
        [_notificationBtn setImage:[UIImage imageNamed:@"ic_nav_information_prompt"] forState:UIControlStateNormal];
    }
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

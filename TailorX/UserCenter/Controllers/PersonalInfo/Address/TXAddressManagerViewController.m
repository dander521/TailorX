//
//  TXAddressManagerViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXAddressManagerViewController.h"
#import "TXAddressTableViewCell.h"
#import "TXAddressDetailViewController.h"
#import "TXAddressModel.h"
#import "TXBlankView.h"

@interface TXAddressManagerViewController ()<UITableViewDelegate, UITableViewDataSource, TXAddressTableViewCellDelegate, NetErrorViewDelegate>

@property (nonatomic, strong) UITableView *addressTableView;
/** 地址数组 */
@property (nonatomic, strong) TXAddressCollectionModel *addressCollection;
/** 无数据提示页面 */
@property (nonatomic, strong) TXBlankView *blankView;
/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 是否首次创建地址 */
@property (nonatomic, assign) BOOL isFirstAddAddress;

@end

@implementation TXAddressManagerViewController

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加通知
    [self addUserInfoNotification];
    // 配置控制器
    [self configViewController];
    // 添加导航栏右侧按钮
//    [self addRightBarButtonItem];
    // 初始化tableview
    [self setUpContentTableView];
    // 初始化底部button
//    [self setupBottomButtom];
    // 获取地址列表数据
    [self getAddressDataFromServer];
}

#pragma mark - NSNotification Method

/**
 添加通知
 */
- (void)addUserInfoNotification {
    // 地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserAddressNotification:) name:kNSNotificationChangeUserAddress object:nil];
}

#pragma mark - Net Request

/**
 获取地址列表数据
 */
- (void)getAddressDataFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterGetCustomerLogisticAddress
                                         success:^(id responseObject) {
                                             if ([responseObject[ServerResponse_success] boolValue]) {
                                                 self.addressCollection = [TXAddressCollectionModel mj_objectWithKeyValues:responseObject];
                                                 if (self.addressCollection.data.count == 0) {
                                                     [self showBlankView];
                                                     self.blankView.hidden = false;
                                                     self.isFirstAddAddress = true;
                                                 } else {
                                                     self.blankView.hidden = true;
                                                     self.isFirstAddAddress = false;
                                                 }
                                                 [self.addressTableView reloadData];
                                                 [MBProgressHUD hideHUDForView:self.view];
                                             } else {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             }
                                             
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

/**
 删除地址

 @param address
 */
- (void)deleteAddressWithModel:(TXAddressModel *)address {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:@{@"addressId" : [NSString stringWithFormat:@"%ld", (long)address.idField]}
                                        relativeUrl:strUserCenterDeleteLogisticAddress
                                         success:^(id responseObject) {
                                             if ([responseObject[kSuccess] boolValue]) {
                                                 [self.addressCollection.data removeObject:address];
                                                 if (self.addressCollection.data.count > 0) {
                                                     self.isFirstAddAddress = false;
                                                     TXAddressModel *address = self.addressCollection.data.firstObject;
                                                     [self setDefaultAddressWithModel:address];
                                                 }
                                                 
                                                 if (self.addressCollection.data.count == 0) {
                                                     self.isFirstAddAddress = true;
                                                     [TXModelAchivar updateUserModelWithKey:@"address" value:@"未设置"];
                                                 }
                                                 [MBProgressHUD hideHUDForView:self.view];
                                                 
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserAddress object:address];
                                             } else {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             }
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

/**
 设置默认地址

 @param address
 */
- (void)setDefaultAddressWithModel:(TXAddressModel *)address {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:@{@"addressId" : [NSString stringWithFormat:@"%ld", (long)address.idField]}
                                        relativeUrl:strUserCenterSetDefaultLogisticAddress
                                         success:^(id responseObject) {
                                             if ([responseObject[kSuccess] boolValue]) {
                                                 // 遍历 对象 进行isDefault 更改
                                                 [self touchDefaultButtonWithModel:address];
                                                 [MBProgressHUD hideHUDForView:self.view];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserAddress object:nil];
                                             } else {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             }
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

#pragma mark - Initial

// 空白页
- (void)showBlankView {

    [self.blankView showBlankViewWithImage:@"ic_main_default_position" title:@"还没有添加收货地址" subTitle:@"" buttonTitle:@"新增地址"];
    weakSelf(self);
    [self.blankView setBtnClickedBlock:^(NSInteger buttonTag) {
        TXAddressDetailViewController *addressDetail = [TXAddressDetailViewController new];
        addressDetail.isEdit = false;
        addressDetail.isFirstAddAddress = weakSelf.isFirstAddAddress;
        [weakSelf.navigationController pushViewController:addressDetail animated:true];
    }];
}

/**
 添加导航栏右侧按钮
 */
- (void)addRightBarButtonItem {
    if (self.isEditAddress == true) {
        return;
    }
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(touchRightBarButtonItem:)];
    rightBarBtn.tintColor = RGB(138, 138, 138);
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

/**
 配置控制器
 */
- (void)configViewController {
    self.navigationItem.title = LocalSTR(@"Str_AddressManager");
    self.view.backgroundColor = [UIColor whiteColor];
    self.isFirstAddAddress = false;
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.addressTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.estimatedRowHeight = 122;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView;
    });
    [self.view addSubview:self.addressTableView];
}

/**
 配置底部视图
 */
- (void)setupBottomButtom {
    ThemeButton *bottomButton = [TailorxFactory setBlackThemeBtnWithTitle:@"新增地址"];
    bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT - kTabBarHeight, SCREEN_WIDTH, kTabBarHeight);
    bottomButton.titleLabel.font = FONT(17);
    [bottomButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressCollection.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXAddressTableViewCell *cell = [TXAddressTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.cellType = self.isEditAddress ? TXAddressTypeEdit : TXAddressTypeDefault;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.cellLineType = TXCellSeperateLinePositionType_Single;

    TXAddressModel *address = self.addressCollection.data[indexPath.row];
    [cell configAddressWithModel:address];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (!self.isEditAddress) {
        TXAddressModel *address = self.addressCollection.data[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationSelectUserAddress object:address];
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark - TXAddressTableViewCellDelegate

/**
 *  设置默认地址方法
 */
- (void)selectDefaultAddressButtonWithAddress:(TXAddressModel *)address {
    [self setDefaultAddressWithModel:address];
}

/**
 *  编辑地址方法
 */
- (void)selectEditAddressButtonWithAddress:(TXAddressModel *)address {
    TXAddressDetailViewController *addressDetail = [TXAddressDetailViewController new];
    addressDetail.isEdit = true;
    addressDetail.address = address;
    addressDetail.isFirstAddAddress = self.isFirstAddAddress;
    if (address.isDefault == 1) {
        addressDetail.isFirstAddAddress = true;
    }
    [self.navigationController pushViewController:addressDetail animated:true];
}

/**
 *  删除地址方法
 */
- (void)selectDeleteAddressButtonWithAddress:(TXAddressModel *)address {
    [self deleteAddressWithModel:address];
}

#pragma mark - Custom Method

- (void)addAddress:(id)sender {
    TXAddressDetailViewController *addressDetail = [TXAddressDetailViewController new];
    addressDetail.isEdit = false;
    addressDetail.isFirstAddAddress = self.isFirstAddAddress;
    [self.navigationController pushViewController:addressDetail animated:true];
}

- (void)touchRightBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    TXAddressManagerViewController *vwcManager = [TXAddressManagerViewController new];
    vwcManager.isEditAddress = true;
    [self.navigationController pushViewController:vwcManager animated:true];
}

/**
 遍历 对象 进行isDefault 更改

 @param address
 */
- (void)touchDefaultButtonWithModel:(TXAddressModel *)address {
    for (TXAddressModel *adderessItem in self.addressCollection.data) {
        if (adderessItem == address) {
            adderessItem.isDefault = 1;
        } else {
            adderessItem.isDefault = 0;
        }
    }
}

/**
 修改用户信息通知方法
 
 @param notification
 */
- (void)changeUserAddressNotification:(NSNotification *)notification {
    [self getAddressDataFromServer];
}

#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
- (void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self getAddressDataFromServer];
}


#pragma mark - Lazy

- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - 50)];
        [self.view addSubview:_blankView];
    }
    
    return _blankView;
}

- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:self.view.bounds];
        _netView.delegate = self;
        [self.view addSubview:_netView];
    }
    return _netView;
}

#pragma mark - Custom SeperateLine

// Setup your cell margins:
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, TableViewDefaultOriginX, 0, 0)];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  TXAddressDetailViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXAddressDetailViewController.h"
#import "TXTextViewTableViewCell.h"
#import "TXTextFieldTableViewCell.h"
#import "TXCitySelector.h"
#import "TXAddressManagerViewController.h"

@interface TXAddressDetailViewController ()<UITableViewDataSource, UITableViewDelegate, TXCitySelectorDelegate, TXTextViewTableViewCellDelegate>

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) UIButton *cityButton;

@end

@implementation TXAddressDetailViewController

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置控制器
    [self configViewController];
    // 设置tableview
    [self setUpContentTableView];
    // 设置底部button
    [self setupBottomButton];
}

#pragma mark - Initial

/**
 配置控制器
 */
- (void)configViewController {
    self.navigationItem.title = self.isEdit ? @"编辑地址" : LocalSTR(@"Str_AddAddress");
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.isEdit) {
        self.address = [TXAddressModel new];
    }
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.detailTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.scrollEnabled = true;
        tableView;
    });
    [self.view addSubview:self.detailTableView];
}

/**
 设置底部视图
 */
- (void)setupBottomButton {
    NSString *titleStr = self.isEdit ? LocalSTR(@"Str_Save") : LocalSTR(@"Str_Save");
    ThemeButton *bottomButton = [TailorxFactory setBlackThemeBtnWithTitle:titleStr];
    bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT - kTabBarHeight, SCREEN_WIDTH, 49);
    bottomButton.titleLabel.font = FONT(17);
    [bottomButton addTarget:self action:@selector(touchSaveAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 4) {
        TXTextViewTableViewCell *cellTextView = [TXTextViewTableViewCell cellWithTableView:tableView];
        [cellTextView configTableViewCellWithAddressModel:self.address];
        cellTextView.cellDelegate = self;
        cellTextView.cellLineType = TXCellSeperateLinePositionType_None;
        if (self.isFirstAddAddress) {
            cellTextView.defaultLabel.hidden = true;
            cellTextView.defaultButton.hidden = true;
        }
        cell = cellTextView;
    } else {
        TXTextFieldTableViewCell *cellTextField = [TXTextFieldTableViewCell cellWithTableView:tableView];
        [cellTextField configTableViewCellWithIndexPath:indexPath addressModel:self.address];
        cellTextField.cellLineType = TXCellSeperateLinePositionType_Single;
        cellTextField.cellLineRightMargin = TXCellRightMarginType16;
        if (indexPath.row == 3) {
            [cellTextField addSubview:self.cityButton];
        }
        
        cell = cellTextField;
    }

    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) return 128.0;
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

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

#pragma mark - Custom Method

- (void)touchSaveAddress:(id)sender {
    
    if (self.address.name.length == 0) {
        TXTextFieldTableViewCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.contentTextField becomeFirstResponder];
        [ShowMessage showMessage:@"请填写收货人姓名" withCenter:self.view.center];
        return;
    } else if (![NSString checkUserName:self.address.name]) {
        [ShowMessage showMessage:@"请填写正确的收货人姓名" withCenter:self.view.center];
        return;
    } else if (self.address.telephone.length == 0) {
        TXTextFieldTableViewCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.contentTextField becomeFirstResponder];
        [ShowMessage showMessage:@"请填写联系电话" withCenter:self.view.center];
        return;
    }
    else if (self.address.telephone.length && ![NSString isPhoneNumCorrectPhoneNum:self.address.telephone]) {
        [ShowMessage showMessage:@"手机号码有误,请重新输入"  withCenter:self.view.center];
        return;
    } else if ([self.address.cityName isEqualToString:@""] || self.address.cityName == nil) {
        [ShowMessage showMessage:@"请选择省/市/行政区" withCenter:self.view.center];
        return;
    } else if (self.address.address.length == 0) {
        TXTextViewTableViewCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        [cell.contentTextView becomeFirstResponder];
        [ShowMessage showMessage:@"请填写详细地址" withCenter:self.view.center];
        return;
    }
//    else if (![NSString isTextEmpty:self.address.postcode] && (self.address.postcode.length != 6 || ![self isPureInt:self.address.postcode])) {
//        [ShowMessage showMessage:@"请输入正确的6位邮编" withCenter:self.view.center];
//        return;
//    }
    
    [self.view endEditing:true];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.address.name forKey:@"name"];
    [param setValue:self.address.telephone forKey:@"telephone"];
    [param setValue:self.address.postcode forKey:@"postcode"];
    [param setValue:self.address.provinceName forKey:@"provinceName"];
    [param setValue:self.address.cityName forKey:@"cityName"];
    [param setValue:self.address.districtName forKey:@"districtName"];
    [param setValue:self.address.address forKey:@"address"];
    [param setValue:[NSString stringWithFormat:@"%ld", (long)self.address.isDefault] forKey:@"isDefault"];
    if (self.isFirstAddAddress) {
        [param setValue:[NSString stringWithFormat:@"%d", 1] forKey:@"isDefault"];
    }
    [param setValue:[NSString stringWithFormat:@"%ld", (long)self.address.idField] forKey:@"addressId"];
    if (!self.isEdit) {
        // 添加地址
        [self addAddressWithParam:param];
    } else {
        // 更新地址
        [self updateAddressWithParam:param];
    }
}

/**
 * 判断是否为纯数字
 */
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


- (void)touchSelectCityButton:(id)sender {
    TXCitySelector *citySelector = [TXCitySelector shareManager];
    citySelector.delegate = self;
    [citySelector showCitySelector];
}

#pragma mark - TXCitySelectorDelegate

- (void)touchCitySelectorButtonWithDictionary:(NSDictionary *)param {

    self.address.provinceName = param[@"province"];
    self.address.cityName = param[@"city"];
    self.address.districtName = param[@"zone"];
    
    [self.detailTableView reloadData];
}

#pragma mark - TXTextViewTableViewCellDelegate

- (void)touchDefaultButton:(BOOL)isSelected {
    [self.view endEditing:true];
    self.address.isDefault = isSelected ? 1 : 0;
}

#pragma mark - Lazy

- (UIButton *)cityButton {
    if (!_cityButton) {
        _cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        _cityButton.backgroundColor = [UIColor clearColor];
        [_cityButton addTarget:self action:@selector(touchSelectCityButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cityButton;
}

#pragma mark - Net Request

/**
 添加地址

 @param param
 */
- (void)addAddressWithParam:(NSDictionary *)param {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:param
                                        relativeUrl:strUserCenterAddNewLogisticAddress
                                         success:^(id responseObject) {
                                             [MBProgressHUD hideHUDForView:self.view];
                                             if ([responseObject[kSuccess] boolValue]) {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserAddress object:nil];
                                                 [self.navigationController popViewControllerAnimated:true];
                                             } else {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             }
                                             
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

/**
 更新地址

 @param param
 */
- (void)updateAddressWithParam:(NSDictionary *)param {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:param
                                        relativeUrl:strUserCenterUpdateLogisticAddress
                                         success:^(id responseObject) {
                                             if ([responseObject[kSuccess] boolValue]) {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserAddress object:nil];
                                                 [self.navigationController popViewControllerAnimated:true];
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


#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  TXBodyDataViewController.m
//  TailorX
//
//  Created by RogerChen on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBodyDataViewController.h"
#import "TXSingleComponentPickerView.h"
#import "TXPersonalDataController.h"

typedef void (^ChangeBodyData)(id responseObject, NSError * error);

@interface TXBodyDataViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray <NSString *>*cellTitles;
@property (nonatomic, strong) UITableView *bodyTableView;
/** pickerView */
@property (nonatomic, strong) TXSingleComponentPickerView *pickerViewHeight;
/** pickerView */
@property (nonatomic, strong) TXSingleComponentPickerView *pickerViewWeight;
/** 身高数组 50-251cm */
@property (nonatomic, strong) NSMutableArray *heightArray;
/** 体重数据 25-226kg */
@property (nonatomic, strong) NSMutableArray *weightArray;

@end

@implementation TXBodyDataViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置控制器
    [self configViewController];
    // 模拟数据
    [self mockBodyDataSource];
    // 添加导航栏右侧按钮
    [self addRightBarButtonItem];
    // 添加pickerView通知
    [self addNotificationMethod];
    // 初始化自控制器的标签(tableViewcell的内容)
    [self setUpArrays];
    // 初始化tableView
    [self setUpContentTableView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Mock Data

/**
 * 模拟数据
 */
- (void)mockBodyDataSource {
    _heightArray = [NSMutableArray array];
    _weightArray = [NSMutableArray array];
    
    // 身高起始值：150cm 最高值：200cm
    // 体重起始值：40kg 最高值：100kg
    for (int i = 150; i <= 200; i++) {
        [_heightArray addObject:[NSString stringWithFormat:@"%dcm",i]];
    }
    
    for (int i = 40; i <= 100; i++) {
        [_weightArray addObject:[NSString stringWithFormat:@"%dkg",i]];
    }
}

#pragma mark - Initial

/**
 添加导航栏右侧按钮
 */
- (void)addRightBarButtonItem {
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_measure"] style:UIBarButtonItemStylePlain target:self action:@selector(touchRightBarButtonItem:)];
    rightBar.tintColor = RGB(138, 138, 138);
    self.navigationItem.rightBarButtonItem = rightBar;
}

/**
 设置控制器
 */
- (void)configViewController {
    self.navigationItem.title = @"量体数据";
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 添加pickerView通知
 */
- (void)addNotificationMethod {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationMethod:) name:@"value" object:nil];
}

/**
 * 初始化自控制器的标签(tableViewcell的内容)
 */
- (void)setUpArrays {
    self.cellTitles = @[@"身高", @"体重"];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.bodyTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.scrollEnabled = false;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.bodyTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    TXSeperateLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TXSeperateLineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.cellLineRightMargin = TXCellRightMarginType16;
    cell.accessoryView = [cell setCustomAccessoryView];
    cell.cellLineType = indexPath.row == 0 ? TXCellSeperateLinePositionType_Single : TXCellSeperateLinePositionType_None;
    
    cell.textLabel.font = FONT(15);
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.textLabel.text = _cellTitles[indexPath.row];
    
    cell.detailTextLabel.font = FONT(14);
    cell.detailTextLabel.textColor = RGB(153, 153, 153);
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldcm", (long)[TXModelAchivar getUserModel].height] == nil ? @"未设置" : [NSString stringWithFormat:@"%ldcm", (long)[TXModelAchivar getUserModel].height];
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldkg", (long)[TXModelAchivar getUserModel].weight] == nil ? @"未设置" : [NSString stringWithFormat:@"%ldkg", (long)[TXModelAchivar getUserModel].weight];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegete

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.row == 0) {
        self.pickerViewHeight = [TXSingleComponentPickerView pickerView];
        self.pickerViewHeight.array = _heightArray;
        [self.pickerViewHeight show];
    } else {
        self.pickerViewWeight = [TXSingleComponentPickerView pickerView];
        self.pickerViewWeight.array = _weightArray;
        [self.pickerViewWeight show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Custom Method

- (void)notificationMethod:(NSNotification *)notification
{
    if ((TXSingleComponentPickerView *)notification.object == self.pickerViewHeight) {
        NSLog(@"%@", ((TXSingleComponentPickerView *)notification.object).result);
        NSString *bodyHeight = ((TXSingleComponentPickerView *)notification.object).result;

        [self changeUserBodyData:@{@"operation" : @"0", @"body" : [bodyHeight substringToIndex:bodyHeight.length - 2]} changeData:^(id responseObject, NSError *error) {
            if (!error) {
                if (responseObject[kSuccess]) {
                    NSLog(@"responseObject = %@", responseObject[@"msg"]);
                    [TXModelAchivar updateUserModelWithKey:@"height" value:[bodyHeight substringToIndex:bodyHeight.length - 2]];
                    if (![TXModelAchivar getUserModel].hasBodyData) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserBodyData object:nil];
                        [TXModelAchivar updateUserModelWithKey:@"hasBodyData" value:[NSString stringWithFormat:@"%d", 1]];
                    }
                    [self.bodyTableView reloadData];
                } else {
                    NSLog(@"修改失败");
                }
            } else {
                NSLog(@"请求失败");
            }
        }];
    } else if ((TXSingleComponentPickerView *)notification.object == self.pickerViewWeight) {
        NSString *bodyWeight = ((TXSingleComponentPickerView *)notification.object).result;
        [self changeUserBodyData:@{@"operation" : @"1", @"body" : [bodyWeight substringToIndex:bodyWeight.length - 2]} changeData:^(id responseObject, NSError *error) {
            if (!error) {
                if (responseObject[kSuccess]) {
                    NSLog(@"responseObject = %@", responseObject[@"msg"]);
                    [TXModelAchivar updateUserModelWithKey:@"weight" value:[bodyWeight substringToIndex:bodyWeight.length - 2]];
                    if (![TXModelAchivar getUserModel].hasBodyData) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserBodyData object:nil];
                        [TXModelAchivar updateUserModelWithKey:@"hasBodyData" value:[NSString stringWithFormat:@"%d", 1]];
                    }
                    [self.bodyTableView reloadData];
                } else {
                    NSLog(@"修改失败");
                }
            } else {
                NSLog(@"请求失败");
            }
        }];
    }
}

- (void)touchRightBarButtonItem:(UIBarButtonItem *)rightBar {
    // FIXME: 显示量体数据H5页面
    TXPersonalDataController *vc = [TXPersonalDataController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Net Request

- (void)changeUserBodyData:(NSDictionary *)params changeData:(ChangeBodyData)changeData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:params
                                        relativeUrl:strUserCenterModifyBodydata
                                         success:^(id responseObject) {
                                             changeData(responseObject, nil);
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             [ShowMessage showMessage:kErrorTitle withCenter:self.view.center];
                                             changeData(nil, error);
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

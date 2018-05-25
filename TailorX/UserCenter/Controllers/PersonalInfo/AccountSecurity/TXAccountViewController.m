//
//  TXAccountViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXAccountViewController.h"
#import "TXPhoneBindViewController.h"
#import "TXNameVerifyViewController.h"
#import "TXModifySecretViewController.h"
#import "TXCardTypeModel.h"

@interface TXAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray <NSString *>*cellTitles;
@property (nonatomic, strong) UITableView *accountTableView;
/** 实名认证状态 */
@property (nonatomic, strong) TXCardTypeModel *verifyStatus;
@end

@implementation TXAccountViewController

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    // 设置控制器
    [self configViewController];
    // 初始化自控制器的标签(tableViewcell的内容)
    [self setUpArrays];
    // 初始化tableView
    [self setUpContentTableView];
    
    [self checkRealNameStatus];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyUserRealName) name:kNSNotificationVerifyUserRealName object:nil];
}

- (void)verifyUserRealName {
    [self checkRealNameStatus];
}

#pragma mark - Initial

/**
 设置控制器
 */
- (void)configViewController {
    self.navigationItem.title = LocalSTR(@"Str_AccountSecurity");
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 * 初始化自控制器的标签(tableViewcell的内容)
 */
- (void)setUpArrays {
    self.cellTitles = @[LocalSTR(@"Str_PhoneNo"), LocalSTR(@"Str_NameVerify"), LocalSTR(@"Str_ModifySecret")];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.accountTableView = ({
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
    [self.view addSubview:self.accountTableView];
}

#pragma mark - Net Request

- (void)checkRealNameStatus {
    // ("未提交", 0),("通过", 1),("审核中", 2),("不通过", 3),("已过期",4)
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterGetRealNameAuthStatus success:^(id responseObject) {
                                            self.verifyStatus = [TXCardTypeModel mj_objectWithKeyValues:responseObject[@"data"]];
                                            [self.accountTableView reloadData];
                                        } failure:^(NSError *error) {
                                            [ShowMessage showMessage:error.description withCenter:self.view.center];
                                        } isLogin:^{
                                            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                        }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    TXSeperateLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TXSeperateLineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.accessoryView = [cell setCustomAccessoryView];
    cell.cellLineType = indexPath.row != 2 ? TXCellSeperateLinePositionType_Single : TXCellSeperateLinePositionType_None;
    cell.cellLineRightMargin = TXCellRightMarginType16;
    
    cell.textLabel.text = _cellTitles[indexPath.row];
    cell.textLabel.font = FONT(15);
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.detailTextLabel.font = FONT(14);
    cell.detailTextLabel.textColor = RGB(153, 153, 153);
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString seperateTelephoneString:[TXModelAchivar getUserModel].phone];
    } else if (indexPath.row == 1) {
        if (self.verifyStatus.value != 1) {
            cell.accessoryView = [cell setCustomAccessoryView];
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
        }
        
        switch (self.verifyStatus.value) {
            case 0:
            {
                cell.detailTextLabel.text = @"未认证";
            }
                break;
                
            case 1:
            {
                cell.detailTextLabel.text = @"已认证";
            }
                break;
                
            case 2:
            {
                cell.detailTextLabel.text = @"审核中";
            }
                break;
                
            case 3:
            {
                cell.detailTextLabel.text = @"不通过";
            }
                break;
                
            case 4:
            {
                cell.detailTextLabel.text = @"已过期";
            }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSArray *controllerArray = @[@"TXPhoneBindViewController",
                                 @"TXNameVerifyViewController",
                                 @"TXModifySecretViewController"];
    
    if (self.verifyStatus.value == 1 && indexPath.row == 1) {
        return;
    }
    [self.navigationController pushViewController:[NSClassFromString(controllerArray[indexPath.row]) new] animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
        [cell setPreservesSuperviewLayoutMargins:false];
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

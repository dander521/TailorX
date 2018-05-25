//
//  TXThirdBindViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXThirdBindViewController.h"
#import "TXAlipayBindViewController.h"

@interface TXThirdBindViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray <NSString *>*cellTitles;
@property (nonatomic, strong) UITableView *accountTableView;

@end

@implementation TXThirdBindViewController

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加通知
    [self addNotification];
    // 配置控制器
    [self configViewController];
    // 初始化自控制器的标签
    [self setUpArrays];
    // 初始化tableView
    [self setUpContentTableView];
}

#pragma mark - Notification 

/**
 添加通知
 */
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindAliPaySuccess:) name:kNSNotificationVerifyBindAliPaySuccess object:nil];
}

#pragma mark - Initial

/**
 配置控制器
 */
- (void)configViewController {
    self.navigationItem.title = LocalSTR(@"Str_ThirdAccountBind");
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 * 初始化自控制器的标签(tableViewcell的内容)
 */
- (void)setUpArrays {

    self.cellTitles = @[LocalSTR(@"Str_AlipayBind"), LocalSTR(@"Str_WeChat"), LocalSTR(@"Str_QQ")];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.accountTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    cell.cellLineType = indexPath.row != 2 ? TXCellSeperateLinePositionType_Single : TXCellSeperateLinePositionType_None;
    cell.cellLineRightMargin = TXCellRightMarginType16;
    
    cell.textLabel.text = _cellTitles[indexPath.row];
    cell.textLabel.font = FONT(15);
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.detailTextLabel.font = FONT(14);
    cell.detailTextLabel.textColor = RGB(153, 153, 153);
    
    switch (indexPath.row) {
        case 0:
        {
            // 支付宝
            cell.detailTextLabel.text = [TXModelAchivar getUserModel].payBind ? @"已绑定" : @"未绑定";
            cell.detailTextLabel.textColor = [TXModelAchivar getUserModel].payBind ? RGB(76, 76, 76) : RGB(153, 153, 153);
            cell.accessoryView = [cell setCustomAccessoryView];
        }
            break;
            
        case 1:
        {
            // 微信
            cell.detailTextLabel.text = [TXModelAchivar getUserModel].weixinBind ? @"已绑定" : @"未绑定";
            cell.detailTextLabel.textColor = [TXModelAchivar getUserModel].weixinBind ? RGB(76, 76, 76) : RGB(153, 153, 153);
            if ([TXModelAchivar getUserModel].weixinBind == false) {
                cell.accessoryView = [cell setCustomAccessoryView];
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = nil;
            }
        }
            break;
            
        case 2:
        {
            // 腾讯QQ
            cell.detailTextLabel.text = [TXModelAchivar getUserModel].qqBind ? @"已绑定" : @"未绑定";
            cell.detailTextLabel.textColor = [TXModelAchivar getUserModel].qqBind ? RGB(76, 76, 76) : RGB(153, 153, 153);
            if ([TXModelAchivar getUserModel].qqBind == false) {
                cell.accessoryView = [cell setCustomAccessoryView];
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = nil;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    switch (indexPath.row) {
        case 0:
        {
            // 支付宝
            [self.navigationController pushViewController:[TXAlipayBindViewController new] animated:true];
        }
            break;
            
        case 1:
        {
            // 微信
            if ([TXModelAchivar getUserModel].weixinBind == false) {
                weakSelf(self);
                [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
                    NSString *message = nil;
                    
                    if (error) {
                        message = [NSString stringWithFormat:@"Get info fail:\n%@", error];
                        UMSocialLogInfo(@"Get info fail with error %@",error);
                    }else{
                        if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                            
                            UMSocialUserInfoResponse *resp = result;
                            NSDictionary *headDic = @{
                                                      @"openId":resp.usid,
                                                      @"openType":@"2",
                                                      @"accessToken":resp.accessToken
                                                      };
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [TXNetRequest goToBlindThirdAccountWithParams:headDic success:^(id responseObject) {
                                if ([responseObject[ServerResponse_success] boolValue]) {
                                    [TXModelAchivar updateUserModelWithKey:@"weixinBind" value:@"1"];
                                    [weakSelf.accountTableView reloadData];
                                } else {
                                    [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                }
                                [MBProgressHUD hideHUDForView:self.view];
                            } failure:^(NSError *error) {
                                [ShowMessage showMessage:error.description withCenter:self.view.center];
                                [MBProgressHUD hideHUDForView:self.view];
                            }];
                        }else{
                            message = @"Get info fail";
                        }
                    }
                }];
            }
        }
            break;
            
        case 2:
        {
            // 腾讯QQ
            if ([TXModelAchivar getUserModel].qqBind == false) {
                weakSelf(self);
                [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
                    NSString *message = nil;
                    
                    if (error) {
                        message = [NSString stringWithFormat:@"Get info fail:\n%@", error];
                        UMSocialLogInfo(@"Get info fail with error %@",error);
                    }else{
                        if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                            
                            UMSocialUserInfoResponse *resp = result;
                            NSDictionary *headDic = @{
                                                      @"openId":resp.usid,
                                                      @"openType":@"1",
                                                      @"accessToken":resp.accessToken
                                                      };
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [TXNetRequest goToBlindThirdAccountWithParams:headDic success:^(id responseObject) {
                                if ([responseObject[ServerResponse_success] boolValue]) {
                                    [TXModelAchivar updateUserModelWithKey:@"qqBind" value:@"1"];
                                    [weakSelf.accountTableView reloadData];
                                } else {
                                    [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                }
                                [MBProgressHUD hideHUDForView:self.view];
                            } failure:^(NSError *error) {
                                [ShowMessage showMessage:error.description withCenter:self.view.center];
                                [MBProgressHUD hideHUDForView:self.view];
                            }];
                        }else{
                            message = @"Get info fail";
                        }
                    }
                }];
            }
        }
            break;
            
        default:
            break;
    }
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

#pragma mark - Custom Method

/**
 绑定支付宝成功

 @param notification
 */
- (void)bindAliPaySuccess:(NSNotification *)notification {
    [self.accountTableView reloadData];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

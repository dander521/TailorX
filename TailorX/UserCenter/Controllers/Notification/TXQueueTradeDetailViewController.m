//
//  TXQueueTradeDetailViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXQueueTradeDetailViewController.h"
#import "TXQueueTradeSuccessModel.h"
#import "TXQueueTradeSuccessTableViewCell.h"
#import "TXPersonalInfoTableViewCell.h"

@interface TXQueueTradeDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *queueTableView;

@property (nonatomic, strong) TXQueueTradeSuccessModel *queueTradeSuccessModel;

@end

@implementation TXQueueTradeDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"通知详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化tableView
    [self setUpContentTableView];
    // 网络请求
    [self getDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Net Request

/**
 网络请求
 */
- (void)getDataFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.contentTypeId forKey:@"recordId"];
    [TXNetRequest userCenterRequestMethodWithParams:params
                                        relativeUrl:findRankNumData
                                            success:^(id responseObject) {
                                                if ([responseObject[ServerResponse_success] boolValue]) {
                                                    self.queueTradeSuccessModel = [TXQueueTradeSuccessModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];

                                                    [self.queueTableView reloadData];
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

#pragma mark - Initial Method

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.queueTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.allowsSelection = false;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.queueTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *defaultCell = nil;
    if (indexPath.row == 0) {
        TXQueueTradeSuccessTableViewCell *cell = [TXQueueTradeSuccessTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.queueModel = self.queueTradeSuccessModel;
        defaultCell = cell;
    } else {
        TXPersonalInfoTableViewCell *cell = [TXPersonalInfoTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.cellTitleLabel.font = FONT(14);
        cell.cellDetailLabel.font = FONT(14);
        cell.cellTitleLabel.textColor = RGB(76, 76, 76);
        cell.cellDetailLabel.textColor = RGB(153, 153, 153);
        switch (indexPath.row) {
            case 1: {
                [cell configPersonalInfoCellWithContent:@"卖家" detailContent:self.queueTradeSuccessModel.saleName];
            }
                break;
                
            case 2: {
                NSString *tradeForm = nil;
                if ([self.queueTradeSuccessModel.saleName isEqualToString:[TXModelAchivar getUserModel].nickName]) {
                    tradeForm = @"卖出";
                } else {
                    tradeForm = @"买入";
                }
                [cell configPersonalInfoCellWithContent:@"交换方式" detailContent:tradeForm];
            }
                break;
                
            case 3: {
                [cell configPersonalInfoCellWithContent:@"交易金额" detailContent:[NSString stringWithFormat:@"￥ %.2f", [self.queueTradeSuccessModel.amount floatValue]]];
                cell.cellDetailLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
            }
                break;
                
            case 4: {
                [cell configPersonalInfoCellWithContent:@"交易编号" detailContent:self.queueTradeSuccessModel.tradeNo];
            }
                break;
                
            case 5: {
                [cell configPersonalInfoCellWithContent:@"交易时间" detailContent:self.queueTradeSuccessModel.tradeTime];
            }
                break;

                
            default:
                break;
        }
        
        defaultCell = cell;
    }
    defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 93.0;
    } else {
        return 43.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


@end

//
//  TXCommentNotPassViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCommentNotPassViewController.h"
#import "TXCommentNotPassPhotoCell.h"
#import "TXNotPassContentTableViewCell.h"
#import "TXNotPassReasonTableViewCell.h"
#import "TXCommentNotPassModel.h"

@interface TXCommentNotPassViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *commentDetailTableView;
/** 评论未通过模型 */
@property (nonatomic, strong) TXCommentNotPassModel *commentModel;

@end

@implementation TXCommentNotPassViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"通知详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化tableView
    [self setUpContentTableView];
    // 请求数据
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
    [params setValue:self.contentTypeId forKey:@"commentId"];
    [TXNetRequest userCenterRequestMethodWithParams:params
                                        relativeUrl:findCommentNoPass
                                            success:^(id responseObject) {
                                                if ([responseObject[ServerResponse_success] boolValue]) {
                                                    self.commentModel = [TXCommentNotPassModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
                                                    
                                                    [self.commentDetailTableView reloadData];
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
    self.commentDetailTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.allowsSelection = false;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.commentDetailTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *defaultCell = nil;
    if (indexPath.row == 0) {
        TXCommentNotPassPhotoCell *cell = [TXCommentNotPassPhotoCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.orderDesLabel.text = self.commentModel.infoName;
        [cell.orderImageView sd_small_setImageWithURL:[NSURL URLWithString:self.commentModel.infoCover] imageViewWidth:63 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        defaultCell = cell;
    } else if (indexPath.row == 1) {
        TXNotPassContentTableViewCell *cell = [TXNotPassContentTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.contentLabel.text = self.commentModel.content;
        defaultCell = cell;
    } else {
        TXNotPassReasonTableViewCell *cell = [TXNotPassReasonTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        cell.reasonLabel.text = self.commentModel.reason;
        defaultCell = cell;
    }
    defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 123.0;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


@end

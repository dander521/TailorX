//
//  TXCommentDetailViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCommentDetailViewController.h"
#import "TXCommentDisplayTableViewCell.h"
#import "TXStarRateTableViewCell.h"
#import "MSSBrowseNetworkViewController.h"
#import "TXOrderHeaderView.h"
#import "TXCommentDetailModel.h"

@interface TXCommentDetailViewController ()<UITableViewDelegate, UITableViewDataSource, TXCommentDisplayTableViewCellDelegate>
/** TableView */
@property (nonatomic, strong) UITableView *commentTableView;
/** TableView */
@property (nonatomic, strong) TXCommentDetailModel *commentDetailModel;
@end

@implementation TXCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价详情";
    
    [self setUpContentTableView];
    
    [self getDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDataFromServer {
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.orderId forKey:@"orderNo"];
    // 订单评价详情
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strOrderCommentDetail completion:^(id responseObject, NSError *error) {
        if (error) {
            [ShowMessage showMessage:error.localizedDescription];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        if (responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([responseObject[kSuccess]boolValue]) {
                
                self.commentDetailModel = [TXCommentDetailModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
                
                [self.commentTableView reloadData];
            }
        }
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}


/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.commentTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.01, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.commentTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        TXCommentDisplayTableViewCell *displayCell = [TXCommentDisplayTableViewCell cellWithTableView:tableView];
        displayCell.delegate = self;
        displayCell.detailModel = self.commentDetailModel;
        cell = displayCell;
    } else {
        TXStarRateTableViewCell *rateCell = [TXStarRateTableViewCell cellWithTableView:tableView];
        rateCell.commentStatusLabel.hidden = true;
        rateCell.starView.userInteractionEnabled = NO;
        rateCell.cellLineType = indexPath.row == 2 ? TXCellSeperateLinePositionType_None : TXCellSeperateLinePositionType_Single;
        rateCell.starView.isGrayStarForBlank = false;
        
        if (indexPath.row == 0) {
            rateCell.descriptionLabel.text = @"综合评分";
            rateCell.starView.currentScore = self.commentDetailModel.overallScore;
        } else if (indexPath.row == 1) {
            rateCell.descriptionLabel.text = @"设计师评分";
            rateCell.starView.currentScore = self.commentDetailModel.designerScore;
        } else {
            rateCell.descriptionLabel.text = @"工厂评分";
            rateCell.starView.currentScore = self.commentDetailModel.factoryScore;
        }
        
        cell = rateCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) return 50.0;
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) return 50.0;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        TXOrderHeaderView *headerView = [TXOrderHeaderView instanceView];
        headerView.headerType = TXOrderHeaderTypeDismissImage;
        headerView.storeLabel.font = FONT(13);
        headerView.storeLabel.textColor = RGB(108, 108, 108);
        headerView.storeLabel.text = @"评分";
        return headerView;
    }
    return nil;
}

#pragma mark - TXCommentDisplayTableViewCellDelegate

- (void)tapDisplayImageViewWithIndex:(NSUInteger)index {
    NSLog(@"index = %zd", index);
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    
    TXCommentDisplayTableViewCell *imageCell = [self.commentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    for(int i = 0;i < [self.commentDetailModel.pics count];i++)
    {
        NSString *imagePath = self.commentDetailModel.pics[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imagePath;// 加载网络图片大图地址
        if (i == 0) {
            browseItem.smallImageView = imageCell.firstImageView;
        } else if (i == 1) {
            browseItem.smallImageView = imageCell.secondImageView;
        } else {
            browseItem.smallImageView = imageCell.thirdImageView;
        }
        
        [browseItemArray addObject:browseItem];
    }
    
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    [vwcBrowse showBrowseViewController];
}

@end

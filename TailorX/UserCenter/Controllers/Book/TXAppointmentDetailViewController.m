//
//  TXAppointmentDetailViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAppointmentDetailViewController.h"
#import "TXStoreDetailController.h"
#import "MSSBrowseNetworkViewController.h"
#import "TXAppointmentDetailTableViewCell.h"
#import "TXReferImageTableViewCell.h"
#import "TXAppointmentDetailModel.h"
#import "TXAppointmentHeaderView.h"
#import "UINavigationBar+Awesome.h"
#import "NetErrorView.h"
#import "TXCustomNavView.h"
#import "TXAppointmentTagsTableViewCell.h"
#import "TXAppointmentDesTableViewCell.h"
#import "TXAppointmentDemandTableViewCell.h"

@interface TXAppointmentDetailViewController ()<UITableViewDelegate, UITableViewDataSource,NetErrorViewDelegate, TXReferImageTableViewCellDelegate>

/** 预约详情model */
@property (strong, nonatomic) TXAppointmentDetailModel *appoinmentModel;

@property (nonatomic, strong) UITableView *tableView;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** 头部视图*/
@property (nonatomic, strong) TXAppointmentHeaderView *headerView;
/** 底部视图*/
@property (nonatomic, strong) UIView *bottomView;
/** 用户上传的图片*/
@property (nonatomic, strong) NSMutableArray *pictureList;

@end

@implementation TXAppointmentDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeDataSource];
    
    [self initializeInterface];
}

#pragma mark - init


- (void)initializeInterface {
    
    self.navigationItem.title = @"预约详情";
    
    self.view.backgroundColor = RGB(241, 241, 241);
    
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.errorView];
}

#pragma mark - Net Request

- (void)initializeDataSource {
    self.pictureList = [@[]mutableCopy];
    [self loadData];
}

- (void)loadData {
    weakSelf(self);
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.appointmentNo forKey:@"orderNo"];
    [TXNetRequest userCenterRequestMethodWithParams:params relativeUrl:strOrderDetail success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            weakSelf.appoinmentModel = [TXAppointmentDetailModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
            weakSelf.headerView.appoinmentModel = weakSelf.appoinmentModel;
            if (![NSString isTextEmpty:weakSelf.appoinmentModel.pictures]) {
                NSArray *tempPictureList = [weakSelf.appoinmentModel.pictures componentsSeparatedByString:@";"];
                for (NSString *str in tempPictureList) {
                    if (![NSString isTextEmpty:str]) {
                        [weakSelf.pictureList addObject:str];
                    }
                }
            }
            self.tableView.tableHeaderView = self.headerView;
            [weakSelf.tableView reloadData];
            // 09预约中 10取消预约
            if (self.appoinmentModel.status != 10) {
                // 删除预约
                UIButton *cancelResonBtn = (UIButton*)[self.view viewWithTag:101];
                cancelResonBtn.layer.borderColor = RGB(153, 153, 153).CGColor;
                [cancelResonBtn setTitle:@"取消预约" forState:UIControlStateNormal];
                [cancelResonBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
                
                UIButton *deleteBtn = (UIButton*)[self.view viewWithTag:102];
                deleteBtn.hidden = YES;
            }else {
                // 1 自己取消
                if (self.appoinmentModel.cancelType != 1){
                    UIButton *cancelResonBtn = (UIButton*)[self.view viewWithTag:101];
                    cancelResonBtn.layer.borderColor = RGB(46, 46, 46).CGColor;
                    [cancelResonBtn setTitle:@"取消原因" forState:UIControlStateNormal];
                    [cancelResonBtn setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
                    
                    UIButton *deleteBtn = (UIButton*)[self.view viewWithTag:102];
                    deleteBtn.hidden = NO;
                }else {
                    UIButton *cancelResonBtn = (UIButton*)[self.view viewWithTag:101];
                    cancelResonBtn.layer.borderColor = RGB(153, 153, 153).CGColor;
                    [cancelResonBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    [cancelResonBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
                    
                    UIButton *deleteBtn = (UIButton*)[self.view viewWithTag:102];
                    deleteBtn.hidden = YES;
                }
            }
            [weakSelf.errorView stopNetViewLoadingFail:NO error:NO];
        } else {
            [weakSelf.errorView stopNetViewLoadingFail:NO error:YES];
        }
    } failure:^(NSError *error) {
        [weakSelf.errorView stopNetViewLoadingFail:YES error:NO];
    } isLogin:^{
        [weakSelf.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}

#pragma mark - events

/**
 * 联系门店
 */

- (void)respondsToContactBtn:(UIButton*)sender {
    [sender setAcceptClickInterval:2];
    if ([NSString isTextEmpty:self.appoinmentModel.storePhone]) {
        [ShowMessage showMessage:@"该门店没有留下电话哦！" withCenter:kShowMessageViewFrame];
    }else {
        [UIAlertController showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet Title:nil message:nil actionsMsg:@[@"呼叫门店",self.appoinmentModel.storePhone,@"取消"] buttonActions:^(NSInteger i) {
            if (i==1) {
                NSString *allString = [NSString stringWithFormat:@"telprompt:%@",self.appoinmentModel.storePhone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            }
        } target:self];
    }
}

/**
 * 删除订单
 */

- (void)respondsToDeleteBtn:(UIButton*)sender {
    weakSelf(self);
    if (self.appoinmentModel.status == 10) {
        NSMutableDictionary *dict = [@{} mutableCopy];
        [dict setValue:self.appointmentNo forKey:@"orderNo"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // 删除订单
        [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeDeleteAppointment completion:^(id responseObject, NSError *error) {
            if (error) {
                [ShowMessage showMessage:error.localizedDescription];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                return ;
            }
            if (responseObject) {
                [ShowMessage showMessage:responseObject[kMsg]];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([responseObject[kSuccess]boolValue]) {
                    if (_block) {
                        _block();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }isLogin:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        }];
    }
}

/**
 * 取消原因
 */

- (void)respondsToCancellationResonBtn:(UIButton*)sender {
    // 取消预约
    if (self.appoinmentModel.status != 10) {
        weakSelf(self);
        [UIAlertController showAlertWithTitle:nil msg:@"\n设计师已等候多时，是否取消预约\n" actionsMsg:@[@"我在想想",@"确定取消"] buttonActions:^(NSInteger index) {
            if (index == 1) {
                NSMutableDictionary *dict = [@{} mutableCopy];
                [dict setValue:weakSelf.appointmentNo forKey:@"orderNo"];
                [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeCancelAppointment completion:^(id responseObject, NSError *error) {
                    if (responseObject) {
                        if ([responseObject[kSuccess] boolValue]) {
                            [ShowMessage showMessage:@"取消成功"  withCenter:weakSelf.view.center];
                            if (weakSelf.block) {
                                weakSelf.block();
                            }
                            [UIAlertController showAlertWithTitle:@"\n预约定金已退还到您的账户\n" message:nil buttonAction:^{
                                [weakSelf loadData];
                            } target:self];
                        } else {
                            [ShowMessage showMessage:responseObject[kMsg]  withCenter:weakSelf.view.center];
                        }
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    }else {
                        [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    }
                }isLogin:^{
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                }];
            }
        } target:self];
    }else{
        // 自己取消
        if (self.appoinmentModel.cancelType == 1) {
            [self respondsToDeleteBtn:sender];
        }
        // 取消原因
        else {
            [UIAlertController showAlertWithTitle:@"" msg:[NSString isTextEmpty:self.appoinmentModel.designerCancelReason] ? @"商家未留下取消原因哦！" : self.appoinmentModel.designerCancelReason actionsMsg:@[@"知道了"] buttonActions:^(NSInteger index) {
                
            } target:self];
        }
    }
}

#pragma mark - UITabelViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.pictureList.count > 0 && ![NSString isTextEmpty:self.appoinmentModel.desc]) {
        return 5;
    } else if ((self.pictureList.count == 0 && ![NSString isTextEmpty:self.appoinmentModel.desc]) || (self.pictureList.count > 0 && [NSString isTextEmpty:self.appoinmentModel.desc])) {
        return 4;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *defaultCell = nil;
    defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 所有类型
    if (self.pictureList.count > 0 && ![NSString isTextEmpty:self.appoinmentModel.desc]) {
        if (indexPath.row == 0) {
            defaultCell = [self configDemandTableViewCell];
        } else if (indexPath.row == 1) {
            defaultCell = [self configReferImageViewCellWithModel:self.appoinmentModel];
        } else if (indexPath.row == 2) {
            defaultCell = [self configTagsCellWithModel:self.appoinmentModel];
        } else if (indexPath.row == 3) {
            defaultCell = [self configDesCellWithModel:self.appoinmentModel];
        } else {
            defaultCell = [self configOrderCellWithModel:self.appoinmentModel];
        }
    }
    // 无图 有需求留言
    else if (self.pictureList.count == 0 && ![NSString isTextEmpty:self.appoinmentModel.desc]) {
        if (indexPath.row == 0) {
            defaultCell = [self configDemandTableViewCell];
        } else if (indexPath.row == 1) {
            defaultCell = [self configTagsCellWithModel:self.appoinmentModel];
        } else if (indexPath.row == 2) {
            defaultCell = [self configDesCellWithModel:self.appoinmentModel];
        } else {
            defaultCell = [self configOrderCellWithModel:self.appoinmentModel];
        }
    }
    // 有图 无需求留言
    else if (self.pictureList.count > 0 && [NSString isTextEmpty:self.appoinmentModel.desc]) {
        if (indexPath.row == 0) {
            defaultCell = [self configDemandTableViewCell];
        } else if (indexPath.row == 1) {
            defaultCell = [self configReferImageViewCellWithModel:self.appoinmentModel];
        } else if (indexPath.row == 2) {
            defaultCell = [self configTagsCellWithModel:self.appoinmentModel];
        } else {
            defaultCell = [self configOrderCellWithModel:self.appoinmentModel];
        }
    }
    // 无图 无需求留言
    else {
        if (indexPath.row == 0) {
            defaultCell = [self configDemandTableViewCell];
        } else if (indexPath.row == 1) {
            defaultCell = [self configTagsCellWithModel:self.appoinmentModel];
        } else {
            defaultCell = [self configOrderCellWithModel:self.appoinmentModel];
        }
    }

    return defaultCell;
}


/**
 定制需求cell

 @return
 */
- (TXSeperateLineCell *)configDemandTableViewCell {
    TXAppointmentDemandTableViewCell *cell = [TXAppointmentDemandTableViewCell cellWithTableView:self.tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_None;
    return cell;
}

/**
 图片cell

 @param model 模型
 @return
 */
- (TXSeperateLineCell *)configReferImageViewCellWithModel:(TXAppointmentDetailModel *)model {
    TXReferImageTableViewCell *cell = [TXReferImageTableViewCell cellWithTableView:self.tableView];
    cell.delegate = self;
    cell.appoinmentModel = self.appoinmentModel;
    cell.cellLineType = TXCellSeperateLinePositionType_None;
    return cell;
}


/**
 标签cell

 @param model
 @return
 */
- (TXSeperateLineCell *)configTagsCellWithModel:(TXAppointmentDetailModel *)model {
    TXAppointmentTagsTableViewCell *cell = [TXAppointmentTagsTableViewCell cellWithTableView:self.tableView];
    cell.tagsLabel.text = [model combineUsertags];
    cell.cellLineType = TXCellSeperateLinePositionType_None;
    return cell;
}

/**
 用户留言

 @param model
 @return
 */
- (TXSeperateLineCell *)configDesCellWithModel:(TXAppointmentDetailModel *)model {
    TXAppointmentDesTableViewCell *cell = [TXAppointmentDesTableViewCell cellWithTableView:self.tableView];
    cell.desLabel.text = model.desc;
    cell.cellLineType = TXCellSeperateLinePositionType_None;
    return cell;
}

- (TXSeperateLineCell *)configOrderCellWithModel:(TXAppointmentDetailModel *)model {
    TXAppointmentDetailTableViewCell *cell = [TXAppointmentDetailTableViewCell cellWithTableView:self.tableView];
    cell.model = self.appoinmentModel;
    cell.cellLineType = TXCellSeperateLinePositionType_None;
    return cell;
}


#pragma mark - TXReferImageTableViewCellDelegate

- (void)tapImageViewWithIndex:(NSUInteger)index {
    NSIndexPath *indexPath = nil;
    // 所有类型
    if (self.pictureList.count > 0 && ![NSString isTextEmpty:self.appoinmentModel.desc]) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    // 无图 有需求留言
    else if (self.pictureList.count == 0 && ![NSString isTextEmpty:self.appoinmentModel.desc]) {

    }
    // 有图 无需求留言
    else if (self.pictureList.count > 0 && [NSString isTextEmpty:self.appoinmentModel.desc]) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    // 无图 无需求留言
    else {

    }
    
    TXReferImageTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [self.pictureList count];i++) {
        NSString *imagePath = self.pictureList[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imagePath;// 加载网络图片大图地址
        if (i == 0) {
            browseItem.smallImageView = cell.firstImageView.referImageView;
        } else if (i == 1) {
            browseItem.smallImageView = cell.secondImageView.referImageView;
        } else {
            browseItem.smallImageView = cell.thirdImageView.referImageView;
        }
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    [vwcBrowse showBrowseViewController];
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.01, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight-50) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = false;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.opaque = false;
        _tableView.backgroundView = nil;
        _tableView.bounces = true;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (TXAppointmentHeaderView *)headerView {
    if (!_headerView) {
        _headerView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXAppointmentHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 208);
    }
    return _headerView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-kTopHeight, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowOffset = CGSizeMake(1, 1);
        _bottomView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
        _bottomView.layer.shadowOpacity = 0.5;

        // 联系门店
        UIButton *contactStoreBtn = [UIButton buttonWithTitle:@"联系门店" textColor:RGB(46, 46, 46) font:13 superView:_bottomView];
        contactStoreBtn.layer.borderColor = RGB(46, 46, 46).CGColor;
        contactStoreBtn.layer.cornerRadius = 3;
        contactStoreBtn.layer.borderWidth = 0.6f;
        contactStoreBtn.frame = CGRectMake(SCREEN_WIDTH-72.5-15, 10, 72.5, 30);
        contactStoreBtn.tag = 100;
        [contactStoreBtn addTarget:self action:@selector(respondsToContactBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:contactStoreBtn];

        // 取消原因
        UIButton *cancellationResonBtn = [UIButton buttonWithTitle:@"取消原因" textColor:RGB(153, 153, 153) font:13 superView:_bottomView];
        cancellationResonBtn.layer.borderColor = RGB(46, 46, 46).CGColor;
        cancellationResonBtn.layer.cornerRadius = 3;
        cancellationResonBtn.layer.borderWidth = 0.6f;
        cancellationResonBtn.frame = CGRectMake(SCREEN_WIDTH-72.5*2-15-20, 10, 72.5, 30);
        cancellationResonBtn.tag = 101;
        [cancellationResonBtn addTarget:self action:@selector(respondsToCancellationResonBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancellationResonBtn];
        
        UIButton *deleteBtn = [UIButton buttonWithTitle:@"删除订单" textColor:RGB(153, 153, 153) font:13 superView:_bottomView];
        deleteBtn.layer.borderColor = RGB(153, 153, 153).CGColor;
        deleteBtn.layer.cornerRadius = 3;
        deleteBtn.layer.borderWidth = 0.6f;
        deleteBtn.frame = CGRectMake(SCREEN_WIDTH-72.5*3-15-40, 10, 72.5, 30);
        deleteBtn.tag = 102;
        [deleteBtn addTarget:self action:@selector(respondsToDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:deleteBtn];
        
    }
    return _bottomView;
}

@end

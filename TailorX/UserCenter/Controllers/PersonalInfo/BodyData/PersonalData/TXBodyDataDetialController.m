//
//  TXBodyDataDetialController.m
//  TailorX
//
//  Created by Qian Shen on 11/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBodyDataDetialController.h"

#import "TXBodyDataHederView.h"
#import "TXBodyDataTabCell.h"
#import "TXSingleComponentPickerView.h"
#import "TXBlankView.h"
#import "TXBodyDataHeadModel.h"
#import "TXBodyDataModel.h"

static NSString *cellID = @"TXBodyDataTabCell";

@interface TXBodyDataDetialController ()<UITableViewDelegate,UITableViewDataSource,NetErrorViewDelegate>

/** 列表视图*/
@property (nonatomic, strong) UITableView *tableView;
/** 头部*/
@property (nonatomic, strong) TXBodyDataHederView *hederView;
/** 头部数据*/
@property (nonatomic, strong) NSDictionary *findMyAllBodyDataDict;
/** 提示页面*/
@property (nonatomic, strong) TXBlankView *blankView;
/** 是否需要加载菊花*/
@property (nonatomic, assign) BOOL isAddHud;
/** 第一家门店ID*/
@property (nonatomic, strong) NSString *firstStoreID;
/** 门店名称*/
@property (nonatomic, strong) NSString *storeName;
/** 更新时间*/
@property (nonatomic, strong) NSString *updateDateTime;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray<TXBodyDataModel*> *dataSource;


@end

@implementation TXBodyDataDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
}


#pragma mark - init

/**
 * 初始化数据源
 */
- (void)initializeDataSource {
    
    self.dataSource = [@[]mutableCopy];
    
    [self loadData];
}

- (void)loadData {
    
    [TXNetRequest homeRequestMethodWithParams:nil relativeUrl:strUserCenterFindMyAllBodyDataList completion:^(id responseObject, NSError *error) {
        if (error) {
            [self.errorView stopNetViewLoadingFail:YES error:NO];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                // 刷新头部
                [self updateTabViewOfHederView:[TXBodyDataHeadModel mj_objectWithKeyValues:[responseObject[kData] firstObject]]];
                [self getFindMyBodyDataList];
            }else {
                [self.errorView stopNetViewLoadingFail:NO error:YES];
            }
        }
    }isLogin:^{
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/**
 * 初始化用户界面
 */
- (void)initializeInterface {
    self.navigationItem.title = @"个人数据";
    self.tableView.tableHeaderView = self.hederView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.errorView];
}

/**
 * 查询用户的身体数据
 */
- (void)getFindMyBodyDataList {
    
    [TXNetRequest homeRequestMethodWithParams:nil relativeUrl:strUserCenterFindMyBodyDataList completion:^(id responseObject, NSError *error) {
        if (error) {
            [self.errorView stopNetViewLoadingFail:YES error:NO];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                if ([responseObject[kData] count] <= 0) {
                    [self.view addSubview:self.blankView];
                    [self.blankView createBlankViewWithImage:@"ic_main_specific_data"
                                                       title:@"还未有相关量体数据"];
                }else {
                    [self.blankView removeFromSuperview];
                }
                self.dataSource = [TXBodyDataModel mj_objectArrayWithKeyValuesArray:responseObject[kData]];
                [self.tableView reloadData];
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                
            }else {
                [self.errorView stopNetViewLoadingFail:NO error:YES];
            }
        }
    }isLogin:^{
        [self.errorView stopNetViewLoadingFail:YES error:NO];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)updateTabViewOfHederView:(TXBodyDataHeadModel *)model {
    
    [self.hederView.userPhotoImgView sd_small_setImageWithURL:[NSURL URLWithString:model.designerPhoto] imageViewWidth:44 placeholderImage:kDefaultUeserHeadImg];
    
    self.hederView.userNameLabel.text = model.designerName;
    self.hederView.storeNameLabel.text = model.storeName;
    self.hederView.updateDateLabel.text = model.updateDate;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXBodyDataTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}


#pragma mark - setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}

- (TXBodyDataHederView *)hederView {
    if(!_hederView) {
        _hederView = [[NSBundle mainBundle] loadNibNamed:@"TXBodyDataHederView" owner:nil options:nil].lastObject;
        _hederView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    }
    return _hederView;
}

- (TXBlankView *)blankView {
    if (!_blankView) {
        _blankView = [[TXBlankView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- kTopHeight)];
        _blankView.backgroundColor = [UIColor whiteColor];
    }
    return _blankView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
}

@end

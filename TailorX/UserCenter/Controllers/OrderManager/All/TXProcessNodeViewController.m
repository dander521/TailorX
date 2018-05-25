//
//  TXProcessNodeViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/6/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProcessNodeViewController.h"
#import "TXLogisticsDetailViewController.h"
#import "TXProgressNodeModel.h"
#import "TXProgressNodeTabCell.h"
#import "NetErrorView.h"
#import "MSSBrowseModel.h"
#import "MSSBrowseNetworkViewController.h"

@interface TXProcessNodeViewController ()<UITableViewDataSource,TYAttributedLabelDelegate,NetErrorViewDelegate, TTXProgressNodeTabCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;

@property (nonatomic, strong) NSMutableArray<TXProgressNodeModel*> *dataSource;

@end

@implementation TXProcessNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    
    [self initializeInterface];
 
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}

#pragma mark - init

- (void)initializeDataSource {
    self.dataSource = [@[]mutableCopy];

    [self loadData];
}

- (void)initializeInterface {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"定制进度";
    
    [self.view addSubview:self.tableView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headView;
    
    [self.view addSubview:self.errorView];
    
}

- (void)loadData {
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.orderNo forKey:@"orderNo"];
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeFindProcessNodeDetail completion:^(id responseObject, NSError *error) {
        if (error) {
            [self.errorView stopNetViewLoadingFail:YES error:NO];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                NSArray *dicArr = responseObject[kData];
                self.dataSource = [TXProgressNodeModel mj_objectArrayWithKeyValuesArray:dicArr];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXProgressNodeTabCell *cell = [TXProgressNodeTabCell cellWithTableView:tableView];
    cell.contentLabel.delegate = self;
    cell.delegate = self;
    cell.isFirst = indexPath.row==0 ? YES : NO;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point {
    TXLogisticsDetailViewController *vc = [TXLogisticsDetailViewController new];
    vc.orderId = self.orderNo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - TTXProgressNodeTabCellDelegate

- (void)tapImageViewWithIndex:(NSUInteger)index photoArray:(NSArray *)photoArray cell:(TXProgressNodeTabCell *)cell {
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [photoArray count];i++) {
        NSString *imagePath = photoArray[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imagePath;// 加载网络图片大图地址
        
        if (i == 0) {
            browseItem.smallImageView = cell.firstImageView;
        } else if (i == 1) {
            browseItem.smallImageView = cell.secondImageView;
        } else {
            browseItem.smallImageView = cell.thirdImageView;
        }
        
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    [vwcBrowse showBrowseViewController];
}

#pragma mark - getters

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) style:UITableViewStylePlain];
        if (_isInsert) {
            _tableView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight);
        }
        [_tableView registerNib:[UINib nibWithNibName:@"TXProgressNodeTabCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
}

@end

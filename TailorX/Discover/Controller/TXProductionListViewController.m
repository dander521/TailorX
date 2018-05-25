//
//  TXProductionListViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductionListViewController.h"
#import "XRWaterfallLayout.h"
#import "TXProductListCollectionViewCell.h"
#import "TXBlankView.h"
#import "TXProductListModel.h"
#import "TXProductDetailViewController.h"

static NSString *cellID = @"TXProductListCollectionViewCell";

@interface TXProductionListViewController ()<XRWaterfallLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NetErrorViewDelegate>

/** 自定义布局 */
@property (nonatomic, strong) XRWaterfallLayout *waterfall;
/** 模糊查询发现列表数组 */
@property (nonatomic, strong) NSMutableArray<TXProductListModel*> *productListArray;
/** 筛选参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/** 初始化页码*/
@property (nonatomic, assign) NSInteger page;
/** 每一页的总条数*/
@property (nonatomic, assign) NSInteger dataCount;
/** 每页条数*/
@property (nonatomic, assign) NSInteger pageLength;
/** 空页面*/
@property (nonatomic, strong) TXBlankView *blankView;
/** 列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** 上拉刷新*/
@property (nonatomic, assign, getter=isPullUp) BOOL pullUp;
/** 下拉加载*/
@property (nonatomic, assign, getter=isPullDown) BOOL pullDown;

@end

@implementation TXProductionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"成交作品";
    self.view.backgroundColor = [UIColor whiteColor];
    adjustsScrollViewInsets_NO(self.collectionView, self);
    [self initializeDataSource];
    [self initializeInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)initializeDataSource {
    
    self.param = [NSMutableDictionary new];
    self.productListArray = [NSMutableArray new];
    self.page = 0;
    self.pullUp = false;
    self.pullDown = false;
    self.pageLength = 10;
    self.dataCount = 0;
    
    [self loadData];
}

- (void)initializeInterface {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.errorView];
}

#pragma mark - Net Request

- (void)loadData {
    [self.param setValue:@(_page) forKey:@"page"];
    [self.param setValue:@(_pageLength) forKey:@"pageLength"];
    [self.param setValue:self.pictureId forKey:@"pictureId"];
    [self.param setValue:self.designerId forKey:@"designerId"];
    weakSelf(self);
    [TXNetRequest homeRequestMethodWithParams:self.param relativeUrl:strFindRecommendDesignerWorkList completion:^(id responseObject, NSError *error) {
        if (error) {
            if (self.isPullUp || self.isPullDown) {
                if (self.isPullUp) {
                    _page -= 1;
                }
                [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            }else {
                [self.errorView stopNetViewLoadingFail:YES error:NO];
            }
            [self stopRefreshing];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                if (self.isPullDown && !self.isPullUp) {
                    [self.productListArray removeAllObjects];
                }
                
                TXProductListCollectionModel *collectionModel = [TXProductListCollectionModel mj_objectWithKeyValues:responseObject];
                
                self.dataCount = collectionModel.data.count;
                self.dataCount == 0 && self.productListArray.count == 0 ? [weakSelf showBlankView] : [weakSelf removeBlankView];
                [self.productListArray addObjectsFromArray:collectionModel.data];
                // 设置模型indexPath 用于返回确定位置
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                [UIView performWithoutAnimation:^{
                    [self.collectionView reloadData];
                }];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    [ShowMessage showMessage:responseObject[kMsg]];
                }else{
                    [self.errorView stopNetViewLoadingFail:NO error:YES];
                }
            }
            [self stopRefreshing];
        }
    }isLogin:^{
        [self stopRefreshing];
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)loadNewData {
    _page = 0;
    self.pullDown = YES;
    self.pullUp = NO;
    
    [self loadData];
}

- (void)loadMoreData {
    _page += 1;
    self.pullUp = YES;
    self.pullDown = NO;
    if (self.dataCount < self.pageLength) {
        [self stopRefreshing];
        [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

#pragma mark - XRWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    TXProductListModel *model = self.productListArray[indexPath.row];
    CGFloat imgHeight = model.headPicHeight == 0 ? 3000 : model.headPicHeight;
    CGFloat imgWidth = model.headPicWidth == 0 ? 2000 :model.headPicWidth;
    return imgHeight / imgWidth * width + 75 + 32;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXProductListModel *model = self.productListArray[indexPath.row];
    TXProductListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXProductListModel *model = self.productListArray[indexPath.row];
    TXProductDetailViewController *vwcDetail = [TXProductDetailViewController new];
    vwcDetail.workId = model.ID;
    [self.navigationController pushViewController:vwcDetail animated:true];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 处理最新发布无感加载逻辑，自动加载数据判断条件 最后一个section的数据-3 等于当前row
    if (indexPath.row == self.productListArray.count - 3) {
        [self loadMoreData];
    }
}

#pragma mark - Custom Method

- (void)stopRefreshing {
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
}

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

- (void)removeBlankView {
    [self.blankView removeFromSuperview];
}

#pragma mark - gettes

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.waterfall = [[XRWaterfallLayout alloc]init];
        self.waterfall.delegate = self;
        if (self.isCollection) {
            _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) collectionViewLayout:self.waterfall];
        } else {
            _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) collectionViewLayout:self.waterfall];
        }
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = false;
        [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        [TXCustomTools customHeaderRefreshWithScrollView:self.collectionView refreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.collectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _collectionView;
}


- (NetErrorView *)errorView {
    if (!_errorView) {
        if (self.isCollection) {
            _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        } else {
            _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        }
        _errorView.delegate = self;
    }
    return _errorView;
}

- (TXBlankView *)blankView {
    if (!_blankView) {
        if (self.isCollection) {
            _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
            [_blankView createBlankViewWithImage:@"ic_main_default_noproduct" title:@"设计师暂无成交作品"];
        } else {
            _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
            [_blankView createBlankViewWithImage:@"ic_main_screening_not" title:@"暂无成交作品内容"];
        }
        
    }
    return _blankView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end

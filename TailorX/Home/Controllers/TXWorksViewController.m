//
//  TXWorksViewController.m
//  TailorX
//
//  Created by Qian Shen on 6/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXWorksViewController.h"
#import "TXDesignerProductionListModel.h"
#import "TXArthorInfoItemCell.h"
#import "NetErrorView.h"
#import "MSSBrowseNetworkViewController.h"

static NSString *cellID = @"TXArthorInfoItemCell";

@interface TXWorksViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,NetErrorViewDelegate>

/** 列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray<TXDesignerProductionListModel*> *dataSource;
/** 上拉刷新*/
@property (nonatomic, assign, getter=isPullUp) BOOL pullUp;
/** 下拉加载*/
@property (nonatomic, assign, getter=isPullDown) BOOL pullDown;
/** 初始化页码*/
@property (nonatomic, assign) NSInteger page;
/** 每一页的总条数*/
@property (nonatomic, assign) NSInteger dataCount;
/** 每页条数*/
@property (nonatomic, assign) NSInteger pageLength;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** 空页面*/
@property (nonatomic, strong) TXBlankView *blankView;

@end

@implementation TXWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsScrollViewInsets_NO(self.collectionView, self);
    [self initializeDataSource];
    
    [self initializeInterface];
}

#pragma mark - init 


- (void)initializeDataSource {
    self.dataSource = [@[]mutableCopy];
    self.pullUp = NO;
    self.pullDown = NO;
    self.page = 0;
    self.pageLength = 10;
    self.dataCount = 0;
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.designerId forKey:@"id"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.page] forKey:@"page"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.pageLength] forKey:@"pageLength"];
    weakSelf(self);
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeGetDesignerProductionList completion:^(id responseObject, NSError *error) {
         if (error) {
             if (self.isPullUp || self.isPullDown) {
                 [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
                 if (self.isPullUp) {
                     _page -= 1;
                 }
             }else {
                 [self.errorView stopNetViewLoadingFail:YES error:NO];
             }
             [self stopRefreshing];
             return;
         }
         if (responseObject) {
             if ([responseObject[kSuccess] boolValue]) {
                 NSArray *dicArr = responseObject[kData][kData];
                 if (self.isPullDown && !self.isPullUp) {
                     [self.dataSource removeAllObjects];
                 }
                 self.dataCount = dicArr.count;
                 self.dataCount == 0 && self.dataSource.count == 0 ? [weakSelf showBlankView] : [weakSelf removeBlankView];
                 [self.dataSource addObjectsFromArray:[TXDesignerProductionListModel mj_objectArrayWithKeyValuesArray:dicArr]];
                 [self.errorView stopNetViewLoadingFail:NO error:NO];
                 [self.collectionView reloadData];
             }else{
                 if (self.isPullUp || self.isPullDown) {
                     //不做处理
                 }else {
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

- (void)stopRefreshing {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
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
        [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

- (void)initializeInterface {
    self.navigationItem.title = @"作品";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if (self.isCollection) {
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) collectionViewLayout:flowLayout];
    } else {
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) collectionViewLayout:flowLayout];
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //设置最小行距
    flowLayout.minimumLineSpacing = 8;
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 8;
    //设置组边界（格子的四周边界）
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
    //设置格子大小
    CGFloat h = LayoutH(216);
    CGFloat w = (SCREEN_WIDTH - 32 - 10) / 2.0;
    flowLayout.itemSize = CGSizeMake(w, h);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    [TXCustomTools customHeaderRefreshWithScrollView:self.collectionView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.errorView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXArthorInfoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [self.dataSource count];i++) {
        TXArthorInfoItemCell *cell = (TXArthorInfoItemCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.smallImageView = cell.coverImgView;
        browseItem.bigImageUrl = self.dataSource[i].productionImg;// 加载网络图片大图地址
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray
                                                                                            currentIndex:indexPath.item];
    [vwcBrowse showBrowseViewController];
}

#pragma mark - Custom Method

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

- (void)removeBlankView {
    [self.blankView removeFromSuperview];
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - getters

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
            [_blankView createBlankViewWithImage:@"ic_main_default_noproduct" title:@"设计师暂无设计作品"];
        } else {
            _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
            [_blankView createBlankViewWithImage:@"ic_main_screening_not" title:@"暂无设计作品内容"];
        }
    }
    return _blankView;
}

@end

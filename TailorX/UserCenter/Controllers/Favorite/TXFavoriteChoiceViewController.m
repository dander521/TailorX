//
//  TXFavoriteChoiceViewController.m
//  TailorX
//
//  Created by 温强 on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFavoriteChoiceViewController.h"
// M
#import "TXFavoriteChoiceModel.h"
#import "TXFindPictureModel.h"
// V
#import "TXBlankView.h"
#import "NetErrorView.h"
#import "XRWaterfallLayout.h"
// T
#import "TXRequestUtil.h"
#import "TXFavoriteDataTool.h"
// C
#import "TXHomeViewController.h"
#import "TXInformationDetailViewController.h"
#import "AppDelegate.h"
#import "TXFromTransition.h"
#import "TXFavoriteViewController.h"
#import "TXDiscoverDetailCollectionViewController.h"


@interface TXFavoriteChoiceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,NetErrorViewDelegate,XRWaterfallLayoutDelegate,TXWaterfallColCellDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NetErrorView *netErrorView;
@property (nonatomic, strong) TXBlankView *blankView;
@property (nonatomic, strong) NSMutableArray *favoriteChoiceDataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, assign) BOOL isPullUp;
@property (nonatomic, assign) BOOL isPullDown;
/** 自定义布局 */
@property (nonatomic, strong) XRWaterfallLayout *waterfall;
/** 当前控制器*/
@property (nonatomic, strong) UIViewController *currentVc;


@end

@implementation TXFavoriteChoiceViewController


- (instancetype)initWithFrame:(CGRect)frame viewType:(TXWaterfallColCellType)type {
    if (self = [super initWithFrame:frame]) {
        _viewType = type;
        _page = 0;
        _pageLength = 10;
        _dataCount = 0;
        self.backgroundColor = RGB(247, 247, 247);
        // 初始化集合视图
        [self setUpmainCollectionView];
        // 数据加载
        [self.netErrorView showAddedTo:self isClearBgc:NO];
        [self loadData];
        // 推荐图片
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kNSNotificationFavoriteDiscoverDetailChanged  object:nil];
    }
    return self;
}

#pragma mark - load Data
/**
 详情页收藏操作通知触发的刷新
 */
- (void)reloadData {
    _page = 0;
    _isPullUp = NO;
    _isPullDown = YES;
    _dataCount = 0;
    [self.favoriteChoiceDataArray removeAllObjects];
    [self loadData];
    if (!self.favoriteChoiceDataArray.count) {
        [self.mainCollectionView reloadData];
    }
}

- (void)setModleIndexPathWithSourceArray:(NSArray<TXFindPictureListModel*> *)sourceArray {
    if (!sourceArray || sourceArray.count == 0) {
        return;
    }
    
    for (int i = 0; i < sourceArray.count; i++) {
        TXFindPictureListModel *model = sourceArray[i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        model.indexPath = indexPath;
    }
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:@(_page) forKey:@"page"];
    [param setValue:@(_pageLength) forKey:@"pageLength"];
    
    NSString *requestStr = self.viewType == TXWaterfallColCellTypeInformation ? strUserCenterfindFavoriteInfo : strUserCenterfindFavoritePicture;
    
    [TXNetRequest userCenterRequestMethodWithParams:param
                                       relativeUrl:requestStr
                                           success:^(id responseObject) {
                                           if ([responseObject[@"success"] boolValue]) { // 返回正确
                                               NSArray *dataAry = [NSArray new];
                                               if (self.viewType == TXWaterfallColCellTypeInformation) {
                                                   dataAry = [TXFavoriteDataTool getFavoriteChoiceListArrayWith:responseObject];
                                               } else {
                                                   dataAry = [TXFindPictureListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
                                                   [self setModleIndexPathWithSourceArray:dataAry];
                                               }
                                               [self.netErrorView stopNetViewLoadingFail:NO error:NO];
                                               self.dataCount = dataAry.count;
                                               // 请求回来列表数量为0
                                               if (self.dataCount ==0 && !self.favoriteChoiceDataArray.count ) {
                                                   // 显示空白页
                                                   [self showBlankView];
                                                   
                                               } else {
                                                   // 移除空白页
                                                   [self.blankView removeFromSuperview];
                                                   // 普通加载或下拉刷新
                                                   if (!self.isPullUp) {
                                                       [self.favoriteChoiceDataArray removeAllObjects];
                                                       [self.favoriteChoiceDataArray addObjectsFromArray:dataAry];
                                                   }
                                                   // 上拉加载更多
                                                   else {
                                                       [self.favoriteChoiceDataArray addObjectsFromArray:dataAry];
                                                   }
                                                   [self.mainCollectionView reloadData];
                                               }
                                               
                                           } else {// 返回失败
                                               
                                               //  有返回 但错误  netErrorView 的Bool 参数
                                               [self checkNetStaus];
                                               [self.netErrorView stopNetViewLoadingFail:NO error:YES];
                                           }
                                           [self.mainCollectionView.mj_header endRefreshing];
                                           [self.mainCollectionView.mj_footer endRefreshing];
                                       } failure:^(NSError *error) {
                                           [self checkNetStaus];
                                           [self.netErrorView stopNetViewLoadingFail:YES error:NO];
                                           [self.mainCollectionView.mj_header endRefreshing];
                                           [self.mainCollectionView.mj_footer endRefreshing];
                                       } isLogin:^{
                                           [self.mainCollectionView.mj_header endRefreshing];
                                           [self.mainCollectionView.mj_footer endRefreshing];
                                           [self.netErrorView stopNetViewLoadingFail:NO error:YES];
                                           [TXServiceUtil loginViewControllerWithTarget:self.currentVc.navigationController];
                                       }];
}

- (void)checkNetStaus {
    
    if (_isPullDown || _isPullUp) {
        [ShowMessage showMessage:kErrorTitle];
    }
    if (_isPullUp) {
        _page -= 1;
    }
    _isPullUp = NO;
    _isPullDown = NO;
    
}

- (void)loadNewData {
    _page = 0;
    _isPullUp = NO;
    _isPullDown = YES;
    _dataCount = 0;

    [self loadData];
    [self.mainCollectionView.mj_footer endRefreshing];
    [self.mainCollectionView.mj_footer setState:MJRefreshStateIdle];
}
- (void)loadMoreData {
    _page += 1;
    _isPullUp = YES;
    _isPullDown = NO;
    if (_dataCount < _pageLength) {
        [self.mainCollectionView.mj_footer endRefreshing];
        [self.mainCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

#pragma mark - UI

- (void)showBlankView {
    [self addSubview:self.blankView];
}

- (void)setUpmainCollectionView {
    self.waterfall =[[XRWaterfallLayout alloc] init];
    self.waterfall.delegate = self;
    // 主集合视图

    self.mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT - kTopHeight - 60) collectionViewLayout:self.waterfall];
    
    self.mainCollectionView.backgroundColor = RGB(247, 247, 247);
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"TXWaterfallColCell" bundle:nil] forCellWithReuseIdentifier:@"TXWaterfallColCell"];
    
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    
    [self addSubview:self.mainCollectionView];
    
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
    self.mainCollectionView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [TXCustomTools customHeaderRefreshWithScrollView:self.mainCollectionView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainCollectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - XRWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    if (self.viewType == TXWaterfallColCellTypeInformation) {
        TXFavoriteChoiceModel *model = self.favoriteChoiceDataArray[indexPath.row];
        CGFloat imgHeight = model.height == 0 ? 3000 : model.height - 40;
        CGFloat imgWidth = model.width == 0 ? 2000 :model.width;
        return imgHeight / imgWidth * width + 100;
    } else {
        TXFindPictureListModel *model = self.favoriteChoiceDataArray[indexPath.row];
        CGFloat imgHeight = model.height == 0 ? 3000 : model.height - 40;
        CGFloat imgWidth = model.width == 0 ? 2000 :model.width;
        return imgHeight / imgWidth * width + 75 + 32;
    }
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

//垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

#pragma mark - collectionView delegate/datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoriteChoiceDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXWaterfallColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXWaterfallColCell" forIndexPath:indexPath];
    if (self.viewType == TXWaterfallColCellTypeInformation) {
        TXInformationListModel *model = self.favoriteChoiceDataArray[indexPath.item];
        model.isLiked = 1;
        cell.infomationModel = model;
    } else {
        TXFindPictureListModel *model = self.favoriteChoiceDataArray[indexPath.item];
        model.favorite = true;
        cell.pictureListModel = model;
    }
    
    cell.cellType = self.viewType;
    cell.delegate = self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewType == TXWaterfallColCellTypeInformation) {
        TXInformationListModel *model = self.favoriteChoiceDataArray[indexPath.item];
        TXWaterfallColCell *cell = (TXWaterfallColCell*)[collectionView cellForItemAtIndexPath:indexPath];
        TXInformationDetailViewController *informationDetailVc = [[TXInformationDetailViewController alloc] init];
        informationDetailVc.coverUrl = model.coverUrl;
        informationDetailVc.coverImgWidth = model.width;
        informationDetailVc.coverImgHeight = model.height;
        informationDetailVc.informationNo = model.informationNo;
        informationDetailVc.isFavorited = model.isLiked;
        informationDetailVc.currenIndexPath = indexPath;
        informationDetailVc.shareBlock = ^{
            model.shareCount += 1;
            if (model.shareCount >= 1000) {
                cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%0.1fk",model.shareCount/1000.0];
            }else {
                cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%@",@(model.shareCount)];
            }
        };
        weakSelf(self);
        informationDetailVc.favoriteChangedBlock = ^(BOOL isLiked) {
            [weakSelf reloadData];
            [(TXFavoriteViewController *)self.currentVc cancelNavigationControllerDelegate];
        };
        [self.currentVc.navigationController pushViewController:informationDetailVc animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            [cell.contentView layoutIfNeeded];
            [cell layoutIfNeeded];
            [collectionView layoutIfNeeded];
        });
    } else {
        TXFindPictureListModel *model = self.favoriteChoiceDataArray[indexPath.item];

        TXWaterfallColCell *cell = (TXWaterfallColCell*)[collectionView cellForItemAtIndexPath:indexPath];
        TXDiscoverDetailCollectionViewController *vwcDiscover = [TXDiscoverDetailCollectionViewController new];
        vwcDiscover.model = model;
        vwcDiscover.isHeat = false;
        // 处理传入id 1000 避免其他页面响应
        vwcDiscover.fromSelectedId = 1000;
        vwcDiscover.currenIndex = 0;
        vwcDiscover.pictureDetailArray = [NSMutableArray arrayWithArray:@[model]];
        weakSelf(self);
        vwcDiscover.favoriteBlock = ^(BOOL isFavorite) {
            [weakSelf reloadData];
            [(TXFavoriteViewController *)self.currentVc cancelNavigationControllerDelegate];
        };
        vwcDiscover.shareBlock = ^{
            if (model.shareCount >= 1000) {
                cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%0.1fk",model.shareCount/1000.0];
            }else {
                cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%@",@(model.shareCount)];
            }
        };
        [self.currentVc.navigationController pushViewController:vwcDiscover animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            [cell.contentView layoutIfNeeded];
            [cell layoutIfNeeded];
            [collectionView layoutIfNeeded];
        });
    }
}

#pragma mark - TXWaterfallColCellDelegate

- (void)waterfallColCell:(TXWaterfallColCell *)waterfallColCell clickLikedBtn:(UIButton *)sender ofInformationModel:(TXInformationListModel *)model {
    NSString *requestStr = self.viewType == TXWaterfallColCellTypeInformation ? strInformationDeleteFavoriteInfo : strUserCenterAddOrCancelFavoritePicture;
    NSDictionary *params = self.viewType == TXWaterfallColCellTypeInformation ? @{@"infoNos":model.informationNo} : @{@"pictureId" : model.ID};
    // 取消收藏
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [TXNetRequest informationRequestMethodWithParams:params relativeUrl:requestStr completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            if ([responseObject[@"success"] boolValue]) {
                model.isLiked = 0;
                model.popularity > 0 ? (model.popularity -= 1) : (model.popularity = 0);
                [sender setImage:[UIImage imageNamed:@"ic_main_big"] forState:UIControlStateNormal];
                
                if (model.popularity >= 1000) {
                    waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",model.popularity/1000.0];
                }else {
                    waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%@",@(model.popularity)];
                }
                [ShowMessage showMessage:@"已取消收藏" withCenter:kShowMessageViewFrame];
                
                if (self.viewType == TXWaterfallColCellTypeDiscover) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationFavoriteInformationChanged object:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationInformationState object:nil];
                }
                
                if ([self.favoriteChoiceDataArray containsObject:model]) {
                    [self.favoriteChoiceDataArray removeObject:model];
                }
                
                [self.mainCollectionView reloadData];
                
                if (self.favoriteChoiceDataArray.count == 0) {
                    [self showBlankView];
                }

                [MBProgressHUD hideHUDForView:self];
            } else {
                [ShowMessage showMessage:@"取消收藏失败" withCenter:kShowMessageViewFrame];
                [MBProgressHUD hideHUDForView:self];
            }
        } else {
            [ShowMessage showMessage:error.description withCenter:kShowMessageViewFrame];
            [MBProgressHUD hideHUDForView:self];
        }
    }isLogin:^{
        [MBProgressHUD hideHUDForView:self];
        [TXServiceUtil loginViewControllerWithTarget:self.currentVc.navigationController];
    }];
}


#pragma mark - netErrorView delegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    self.dataCount = 0;
    [self loadData];
}

#pragma mark - lazy

- (NSMutableArray *)favoriteChoiceDataArray {
    
    if (nil == _favoriteChoiceDataArray) {
        _favoriteChoiceDataArray = [NSMutableArray array];
    }
    
    return _favoriteChoiceDataArray;
}

- (TXBlankView *)blankView {
    
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - 60)];
        if (self.viewType == TXWaterfallColCellTypeDiscover) {
            [_blankView createBlankViewWithImage:@"ic_main_default_collect" title:@"还未收藏精选图"];
        } else {
            [_blankView createBlankViewWithImage:@"ic_main_default_collect" title:@"还未收藏时尚资讯"];
        }
    }
    return _blankView;
}

- (NetErrorView *)netErrorView {
    if (_netErrorView == nil) {
        _netErrorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight-60)];
        _netErrorView.delegate = self;
    }
    return _netErrorView;
}

- (UIViewController *)currentVc {
    if (!_currentVc) {
        _currentVc = (UIViewController*)self.nextResponder.nextResponder.nextResponder;
    }
    return _currentVc;
}

- (void)dealloc {
    
}

@end

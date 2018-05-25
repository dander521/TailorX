//
//  TXLatestReleaseView.m
//  TailorX
//
//  Created by Qian Shen on 5/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXLatestReleaseViewController.h"

#import "XRWaterfallLayout.h"
#import "TXFindPictureModel.h"
#import "TXWaterfallColCell.h"
#import "TXBlankView.h"
#import "TXFromTransition.h"
#import "TXDiscoveViewController.h"
#import "TXDiscoverDetailCollectionViewController.h"

static NSString *cellID = @"TXWaterfallColCell";


@interface TXLatestReleaseViewController ()<XRWaterfallLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NetErrorViewDelegate,TXWaterfallColCellDelegate,UIScrollViewDelegate>

/** 自定义布局 */
@property (nonatomic, strong) XRWaterfallLayout *waterfall;
/** 模糊查询发现列表数组 */
@property (nonatomic, strong) NSMutableArray<TXFindPictureModel*> *pictureList;
/** 用于详情页滚动数组*/
@property (nonatomic, strong) NSMutableArray<TXFindPictureListModel*> *pictureDetailArray;
/** 返回顶部的按钮*/
@property (nonatomic, strong) UIButton *returnTopBtn;
/** 保存之前的偏移量*/
@property (nonatomic, assign) CGFloat oldOffset;
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
/** 空页面*/
@property (nonatomic, strong) TXBlankView *blankView;
/** cell的当前下标*/
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** 当前控制器*/
@property (nonatomic, strong) UIViewController *currentVc;
/** 上拉*/
@property (nonatomic, assign, getter=isAnimationPullUp) BOOL animationPullUp;
/** 动画开始位置*/
@property (nonatomic, assign) CGFloat beginAnimationY;
/** 动画结束位置*/
@property (nonatomic, assign) CGFloat endAnimationY;

@end

@implementation TXLatestReleaseViewController


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeDataSource];
        
        [self initializeInterface];
        
        // 用户退出登录
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationLogout object:nil];
        // 用户成功登录
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationLoginSuccess  object:nil];
        // 收藏发现图片
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationFavoriteInformationChanged  object:nil];
        // 推荐图片
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationFavoriteDiscoverDetailChanged  object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPanToEnd:) name:kNotificationDiscoverItemPanLatest object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userScrollItem:) name:kNotificationDiscoverItemScrollLatest object:nil];
    }
    return self;
}

#pragma mark - init 

- (void)initializeDataSource {
    
    self.param = [@{}mutableCopy];
    self.pictureList = [@[]mutableCopy];
    self.pictureDetailArray = [NSMutableArray new];
    self.pullUp = NO;
    self.pullDown = NO;
    self.page = 0;
    self.pageLength = 15;
    self.dataCount = 0;
    
    [self loadData];
}

- (void)initializeInterface {
    
    [self addSubview:self.collectionView];
    self.clipsToBounds = YES;
    
    [self addSubview:self.returnTopBtn];
    [self.returnTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    
    [self addSubview:self.errorView];
    
}

#pragma mark - methods

// 设置模型indexPath 用于返回确定位置
- (void)setModleIndexPathWithSourceArray:(NSArray<TXFindPictureModel*> *)sourceArray {
    if (!sourceArray || sourceArray.count == 0) {
        return;
    }
    
    [self.pictureDetailArray removeAllObjects];
    
    for (int i = 0; i < sourceArray.count; i++) {
        TXFindPictureModel *pictureModel = sourceArray[i];
        for (int j = 0; j < pictureModel.data.count; j++) {
            TXFindPictureListModel *pictureListModel = pictureModel.data[j];
            pictureListModel.indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [self.pictureDetailArray addObject:pictureListModel];
        }
    }
}

- (void)loadData {
    [self.param setValue:@(_page) forKey:@"page"];
    [self.param setValue:@(_pageLength) forKey:@"pageLength"];
    [self.param setValue:@"1" forKey:@"showMethd"];
    weakSelf(self);
    [TXNetRequest homeRequestMethodWithParams:self.param relativeUrl:strDiscoverFindPictureList completion:^(id responseObject, NSError *error) {
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
                NSArray *dicArr = responseObject[kData][kData];
                if (self.isPullDown && !self.isPullUp) {
                    [self.pictureList removeAllObjects];
                }
                NSMutableArray<TXFindPictureModel*> *tempArr = [@[]mutableCopy];
                tempArr = [TXFindPictureModel mj_objectArrayWithKeyValuesArray:dicArr];
                NSInteger tempCount = 0;
                for (TXFindPictureModel *tempModel in tempArr) {
                    // 分页加载
                    tempCount += tempModel.data.count;
                }
                self.dataCount = tempCount;
                self.dataCount == 0 && self.pictureList.count == 0 ? [weakSelf showBlankView] : [weakSelf removeBlankView];
                if (self.pictureList.count == 0) {
                    [self.pictureList addObjectsFromArray:tempArr];
                }else {
                    NSMutableArray *sameModels = [@[]mutableCopy];
                    for (TXFindPictureModel *tempModel in tempArr) {
                        for (TXFindPictureModel *model in self.pictureList) {
                            if ([model.publishTime isEqualToString:tempModel.publishTime]) {
                                [model.data addObjectsFromArray:tempModel.data];
                                [sameModels addObject:tempModel];
                            }
                        }
                    }
                    [tempArr removeObjectsInArray:sameModels];
                    [self.pictureList addObjectsFromArray:tempArr];
                }
                // 排序
                self.pictureList = [self orderArrayWithArray:self.pictureList];
                
                // 设置模型indexPath 用于返回确定位置
                [self setModleIndexPathWithSourceArray:self.pictureList];
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                [UIView performWithoutAnimation:^{
                    [self.collectionView reloadData];
                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDiscoverAutoLoadDataSuccess object:nil userInfo:nil];
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
        [TXServiceUtil loginViewControllerWithTarget:self.currentVc.navigationController];
    }];
}

- (void)loadNewData {
    
    NSLog(@"+---------- loadNewData");
    
    if (self.refreshBlock) {
        self.refreshBlock();
    }
    _page = 0;
    self.pullDown = YES;
    self.pullUp = NO;
    
    [self loadData];
    
}
- (void)loadMoreData {
    NSLog(@"+---------- loadMoreData");
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

- (NSMutableArray *)orderArrayWithArray:(NSMutableArray *)array {
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(TXFindPictureModel *obj1, TXFindPictureModel *obj2) {
        return [obj2.publishTime compare:obj1.publishTime]; //升序
    }];
    
    return [NSMutableArray arrayWithArray:result];
}

- (void)stopRefreshing {
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
}

- (void)showBlankView {
    [self addSubview:self.blankView];
}

- (void)removeBlankView {
    [self.blankView removeFromSuperview];
}

#pragma mark - XRWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    TXFindPictureListModel *model = self.pictureList[indexPath.section].data[indexPath.row];
    CGFloat imgHeight = model.height == 0 ? 3000 : model.height;
    CGFloat imgWidth = model.width == 0 ? 2000 :model.width;
    return imgHeight / imgWidth * width + 75 + 32;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 41);
    }else {
        return CGSizeMake(SCREEN_WIDTH, 31);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.pictureList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.pictureList.count == 0) {
        collectionView.userInteractionEnabled = NO;
    }else {
        collectionView.userInteractionEnabled = YES;
    }
    return self.pictureList[section].data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXWaterfallColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.pictureListModel = self.pictureList[indexPath.section].data[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //判断当前设置视图的位置（头部或者）
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"H" forIndexPath:indexPath];
        for (UIView *subView in headerView.subviews) {
            [subView removeFromSuperview];
        }
        UILabel *sectionTitleLable = [UILabel labelWithFont:15 textColor:RGB(153, 153, 153) superView:headerView alignment:NSTextAlignmentCenter];
        if (indexPath.section == 0) {
            sectionTitleLable.frame = CGRectMake(0, 10, SCREEN_WIDTH, 36);
        }else {
            sectionTitleLable.frame = CGRectMake(0, 0, SCREEN_WIDTH, 31);
        }
        sectionTitleLable.text = [NSString toMonthString:self.pictureList[indexPath.section].publishTime];
        return headerView;
    }else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"F" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectZero];
        lable.backgroundColor = [UIColor blackColor];
        [footerView addSubview:lable];
        return footerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXDiscoverDetailCollectionViewController *vwcDiscover = [TXDiscoverDetailCollectionViewController new];
    TXFindPictureListModel *model = self.pictureList[indexPath.section].data[indexPath.row];
    TXWaterfallColCell *cell = (TXWaterfallColCell*)[collectionView cellForItemAtIndexPath:indexPath];
    vwcDiscover.model = model;
    vwcDiscover.isHeat = false;
    vwcDiscover.fromSelectedId = 0;
    vwcDiscover.pictureDetailArray = self.pictureDetailArray;
    vwcDiscover.currenIndex = [self.pictureDetailArray indexOfObject:model];
    vwcDiscover.shareBlock = ^ () {
        if (model.shareCount >= 1000) {
            cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%0.1fk",model.shareCount/1000.0];
        }else {
            cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%@",@(model.shareCount)];
        }
    };
    
    vwcDiscover.favoriteBlock = ^ (BOOL isFavorite) {
        model.favorite = isFavorite;
        if (model.favoriteCount >= 1000) {
            cell.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",model.favoriteCount/1000.0];
        }else {
            cell.popularityLabel.text = [NSString stringWithFormat:@"%@",@(model.favoriteCount)];
        }
        if (model.isFavorite == false && model.favorite == false ) {
            [cell.likedBtn setImage:[UIImage imageNamed:@"ic_main_big"] forState:UIControlStateNormal];
        } else {
            [cell.likedBtn setImage:[UIImage imageNamed:@"ic_main_big-1"] forState:UIControlStateNormal];
        }
    };
    [self.currentVc.navigationController pushViewController:vwcDiscover animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [cell.contentView layoutIfNeeded];
        [cell layoutIfNeeded];
        [collectionView layoutIfNeeded];
    });
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isAnimationPullUp) {
        // 处理最新发布无感加载逻辑，自动加载数据判断条件 最后一个section的数据-3 等于当前row
        if (indexPath.row == self.pictureList.lastObject.data.count - 3) {
            [self loadMoreData];
        }
    }
}

#pragma mark - TXWaterfallColCellDelegate

- (void)waterfallColCell:(TXWaterfallColCell *)waterfallColCell clickLikedBtn:(UIButton *)sender ofPictureListModelModel:(TXFindPictureListModel *)model {
    // 取消收藏
    if (model.favorite == YES) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [TXNetRequest informationRequestMethodWithParams:@{@"pictureId":model.ID} relativeUrl:strUserCenterAddOrCancelFavoritePicture completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    model.favorite = false;
                    model.favoriteCount > 0 ? (model.favoriteCount -= 1) : (model.favoriteCount = 0);
                    [sender setImage:[UIImage imageNamed:@"ic_main_big"] forState:UIControlStateNormal];
                    if (model.favoriteCount >= 1000) {
                        waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",model.favoriteCount/1000.0];
                    }else {
                        waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%@",@(model.favoriteCount)];
                    }
                    [ShowMessage showMessage:@"已取消收藏" withCenter:kShowMessageViewFrame];
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
    // 增加收藏
    else {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [TXNetRequest informationRequestMethodWithParams:@{@"pictureId":model.ID} relativeUrl:strUserCenterAddOrCancelFavoritePicture completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    model.favorite = YES;
                    model.favoriteCount += 1;
                    [sender setImage:[UIImage imageNamed:@"ic_main_big-1"] forState:UIControlStateNormal];
                    if (model.favoriteCount >= 1000) {
                        waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",model.favoriteCount/1000.0];
                    }else {
                        waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%@",@(model.favoriteCount)];
                    }
                    [ShowMessage showMessage:@"收藏成功" withCenter:kShowMessageViewFrame];
                    [MBProgressHUD hideHUDForView:self];
                } else {
                    [ShowMessage showMessage:@"收藏失败" withCenter:kShowMessageViewFrame];
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
}

- (void)waterfallColCell:(TXWaterfallColCell*)waterfallColCell clickDesignerBtn:(UIButton*)sender ofPictureListModelModel:(TXFindPictureListModel*)model {
    if ([self.delegate respondsToSelector:@selector(touchLatestDesignerButtonWithDesignerId:)]) {
        [self.delegate touchLatestDesignerButtonWithDesignerId:model.designerId];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [scrollView showScrollToTopViewWithOldOffset:self.oldOffset currentOffset:scrollView.contentOffset.y headerViewHeight:0 returnTopBtn:self.returnTopBtn];
    self.oldOffset = scrollView.contentOffset.y;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.delegate respondsToSelector:@selector(scrollLatestScrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollLatestScrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
    self.endAnimationY = scrollView.contentOffset.y;
    if (self.endAnimationY-self.beginAnimationY > 0) {
        self.animationPullUp = true;
    } else {
        self.animationPullUp = false;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollLatestScrollViewWillBeginDragging:)]) {
        [self.delegate scrollLatestScrollViewWillBeginDragging:scrollView];
    }
    self.beginAnimationY = scrollView.contentOffset.y;
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
}

#pragma mark - Notification

/**
 用户登录状态变更
 */
- (void)userLoginstatusChanged {
    [self loadNewData];
}

- (void)userPanToEnd:(NSNotification *)notification {
    // 非第一次加载的详情页 禁止加载主页数据
    if ([notification.userInfo[@"from"] integerValue] > 0) {
        return;
    }
    _page += 1;
    self.pullUp = YES;
    self.pullDown = NO;
    if (self.dataCount < self.pageLength) {
        [self stopRefreshing];
        [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self loadData];
    }
}

- (void)userScrollItem:(NSNotification *)notification {
    // 非第一次加载的详情页 禁止加载主页数据
    if ([notification.userInfo[@"from"] integerValue] > 0) {
        return;
    }
    
    TXFindPictureListModel *model = notification.object;
    // 解决collectionView不滚动问题
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:model.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:true];
}

#pragma mark - gettes

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.waterfall = [[XRWaterfallLayout alloc]init];
        self.waterfall.delegate = self;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114) collectionViewLayout:self.waterfall];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = false;
        [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"H"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"F"];
        [TXCustomTools customHeaderRefreshWithScrollView:self.collectionView refreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.collectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _collectionView;
}

- (UIButton *)returnTopBtn {
    if (!_returnTopBtn) {
        _returnTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnTopBtn.hidden = YES;
        [_returnTopBtn setImage:[UIImage imageNamed:@"ic_main_stick_top_3.2.0"] forState:UIControlStateNormal];
    }
    return _returnTopBtn;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, SCREEN_HEIGHT-113+50)];
        _errorView.delegate = self;
    }
    return _errorView;
}

- (TXBlankView *)blankView {
    if (!_blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, SCREEN_HEIGHT-113+50)];
        [_blankView createBlankViewWithImage:@"ic_main_screening_not" title:@"无相关筛选内容"];
    }
    return _blankView;
}

- (UIViewController *)currentVc {
    if (!_currentVc) {
        _currentVc = (UIViewController*)self.nextResponder.nextResponder;
    }
    return _currentVc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

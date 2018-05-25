//
//  TXDiscoverDetailCollectionViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDiscoverDetailCollectionViewCell.h"
#import "XRWaterfallLayout.h"
#import "TXWaterfallColCell.h"

#import "TXFindPictureDetailModel.h"
#import "TXInfomationHeaderTabCell.h"
#import "UIView+SFrame.h"
#import "ReachabilityUtil.h"
#import "TXDesignerDetailController.h"
#import "TXToTransition.h"
#import "TXFromTransition.h"
#import "TXDiscoveViewController.h"
#import "TXFavoriteViewController.h"
#import "MSSBrowseNetworkViewController.h"
#import "MSSBrowseModel.h"
#import "YTFAnimationManager.h"
#import "TXDiscoverDetailFooterCollectionReusableView.h"
#import "TXDiscoverDetailCollectionViewController.h"
#import "TXProductionListViewController.h"

#import "TXCacheRecommendPictureModel.h"

static NSString *cellID = @"TXWaterfallColCell";
static NSString *discoverDetailReusableViewID = @"TXDiscoverDetailReusableView";
static NSString *discoverDetailReusableFooterViewID = @"TXDiscoverDetailFooterCollectionReusableView";
#define collectionImg [UIImage imageNamed:@"ic_nav_press_collection_3.2.1"]
#define notCollectionImg [UIImage imageNamed:@"ic_nav_default_collection_3.2.1"]

@interface TXDiscoverDetailCollectionViewCell ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,XRWaterfallLayoutDelegate,TXDiscoverDetailReusableViewDelegate,TXWaterfallColCellDelegate, NetErrorViewDelegate>

/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 瀑布流布局*/
@property (nonatomic, strong) XRWaterfallLayout *waterfall;
/** 推荐图片*/
@property (nonatomic, strong) NSMutableArray *recommendPictureList;
/** 上拉加载*/
@property (nonatomic, assign, getter=isPullUp) BOOL pullUp;
/** 下拉刷新*/
@property (nonatomic, assign, getter=isPullDown) BOOL pullDown;
/** 初始化页码*/
@property (nonatomic, assign) NSInteger page;
/** 每一页的总条数*/
@property (nonatomic, assign) NSInteger dataCount;
/** 每页条数*/
@property (nonatomic, assign) NSInteger pageLength;
/** 发现详情*/
@property (nonatomic, strong) TXFindPictureDetailModel *pictureDetailModel;
/** 头部视图的高度*/
@property (nonatomic, assign) CGFloat discoverDetailReusableViewHeigth;
/** 首图高度*/
@property (nonatomic, assign) CGFloat coverImgHeight;
/** 上拉*/
@property (nonatomic, assign, getter=isAnimationPullUp) BOOL animationPullUp;
/** 动画开始位置*/
@property (nonatomic, assign) CGFloat beginAnimationY;
/** 动画结束位置*/
@property (nonatomic, assign) CGFloat endAnimationY;

/** 缓存模型 */
@property (nonatomic, strong) TXCacheRecommendPictureModel *cacheModel;

@end

@implementation TXDiscoverDetailCollectionViewCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        // 接收登录成功的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuceess:) name:kNSNotificationLoginSuccess  object:nil];
        // 页面动效通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPanToEnd:) name:kNotificationDiscoverDetailItemPan object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userScrollItem:) name:kNotificationDiscoverDetailItemScroll object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void)initializeDataSource {
    self.recommendPictureList = [@[]mutableCopy];
    
    self.cacheModel = [((TXDiscoverDetailCollectionViewController *)self.superViewController).cacheDictionary valueForKey:self.model.ID];
    if (!self.cacheModel) {
        self.cacheModel = [TXCacheRecommendPictureModel new];
    }
    
    self.discoverDetailReusableViewHeigth = 0;
    self.toSelectedId = self.fromSelectedId + 1;
    self.pullUp = NO;
    self.pullDown = NO;
    self.page = 0;
    self.dataCount = 0;
    self.pageLength = 15;
}

- (void)setModel:(TXFindPictureListModel *)model {
    _model = model;
    [self initializeDataSource];
    [self initializeInterface];
    [self loadData];
}

- (void)initializeInterface {
    [self addSubview:self.collectionView];
}

- (void)loadData {
    // 加载发现详情
    self.pictureDetailModel = [self.model transformListModelToDetailModel];
    self.discoverDetailReusableViewHeigth = [self getDiscoverDetailHeadViewHeight];
    self.collectionView.contentOffset = CGPointMake(0, 0);
    
    if (self.cacheModel.recommendList && self.cacheModel.recommendList.count > 0) {
        self.recommendPictureList = self.cacheModel.recommendList;
        if (self.cacheModel.isLoad && self.cacheModel.isEnd) {
            [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
        } else {
            [self.collectionView.mj_footer setState:MJRefreshStateIdle];
        }
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadData];
        }];
    } else {
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadData];
        }];
        [self getDiscoverGetRecommendPictureList];
    }
}

/**
 设置模型indexPath 用于返回确定位置
 
 @param sourceArray
 */
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

- (void)getDiscoverGetRecommendPictureList {
    if ([NSString isTextEmpty:self.model.ID]) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.model.ID forKey:@"id"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.page] forKey:@"page"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.pageLength] forKey:@"pageLength"];
    [TXNetRequest informationRequestMethodWithParams:dict relativeUrl:strDiscoverGetRecommendPictureList completion:^(id responseObject, NSError *error) {
        
        if (error) {
            if (self.isPullUp || self.isPullDown) {
                if (self.isPullUp) {
                    _page -= 1;
                }
            }
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            [self.netView stopNetViewLoadingFail:true error:false];
            [self stopRefreshing];
            return;
        }
        if (responseObject) {
            self.cacheModel.isLoad = true;
            if ([responseObject[kSuccess] boolValue]) {

                [self.netView stopNetViewLoadingFail:false error:false];
                if (self.isPullDown && !self.isPullUp) {
                    [self.recommendPictureList removeAllObjects];
                }
                NSArray *dicArr = responseObject[kData][kData];
                self.dataCount = dicArr.count;
                [self.recommendPictureList addObjectsFromArray:[TXFindPictureListModel mj_objectArrayWithKeyValuesArray:dicArr]];
                [self setModleIndexPathWithSourceArray:self.recommendPictureList];

                self.cacheModel.recommendList = self.recommendPictureList;
                
                [((TXDiscoverDetailCollectionViewController *)self.superViewController).cacheDictionary setValue:self.cacheModel forKey:self.model.ID];
                [UIView performWithoutAnimation:^{
                    [self.collectionView reloadData];
                }];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    //不做处理
                    _page = 0;
                }
                [ShowMessage showMessage:responseObject[kMsg] withCenter:self.center];
                [self.netView stopNetViewLoadingFail:false error:true];
            }
            [self stopRefreshing];
        }
    }isLogin:^{
        [self stopRefreshing];
        [self.netView stopNetViewLoadingFail:false error:true];
        [TXServiceUtil loginViewControllerWithTarget:self.superViewController.navigationController];
    }];
}

- (void)stopRefreshing {
    [self.collectionView.mj_footer endRefreshing];
}

- (void)loadMoreData {
    self.pullUp = YES;
    self.pullDown = NO;
    _page += 1;
    if (self.dataCount < self.pageLength) {
        if (_page >= 1) {
            [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
            self.cacheModel.isEnd = true;
        }
    }else {
        [self getDiscoverGetRecommendPictureList];
    }
}

#pragma mark - methods

- (CGFloat)getDiscoverDetailHeadViewHeight {
    // 头图高度
    CGFloat height = self.pictureDetailModel.height == 0 ? 248 : self.pictureDetailModel.height;
    CGFloat width = self.pictureDetailModel.width == 0 ? SCREEN_WIDTH : self.pictureDetailModel.width;
    
    CGFloat coverImgViewHeight = 16 + (height / width * SCREEN_WIDTH);
    // 发现描述高度
    CGFloat descLabelHeight = 11 + [self heightForString:[NSString isTextEmpty:self.pictureDetailModel.desc] ? @"" : self.pictureDetailModel.desc Spacing:5 fontSize:[UIFont systemFontOfSize:17 weight:2] andWidth:SCREEN_WIDTH - 32].height;
    // 标签高度
    CGFloat tagsLabelHeight = 0;
    NSArray<TagsCommonInfo*> *tagInfos = [TagsCommonInfo mj_objectArrayWithKeyValuesArray:self.pictureDetailModel.tagsCommon];
    if (tagInfos.count == 0) {
        TagsCommonInfo *tag = [TagsCommonInfo new];
        tag.tagName = @"暂无标签";
        tagInfos = @[tag];
    }
    CGFloat maxWidth = SCREEN_WIDTH - 93;
    float btnW = 0;
    int count = 0;
    UIView *tagBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    for (int i = 0; i < tagInfos.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        CGFloat labelWidth = [self heightForString:tagInfos[i].tagName fontSize:12 andWidth:maxWidth].width + 20;
        label.width = labelWidth;
        label.height = 22;
        if (i == 0) {
            label.x = 0;
            btnW += CGRectGetMaxX(label.frame);
        }
        else{
            btnW += CGRectGetMaxX(label.frame) + 10;
            if (btnW > maxWidth) {
                count++;
                label.x = 0;
                btnW = CGRectGetMaxX(label.frame);
            }
            else{
                label.x += btnW - label.width;
            }
        }
        label.y += count * (label.height + 10) + 10;
        label.text = tagInfos[i].tagName;
        [tagBgView addSubview:label];
        if (i == tagInfos.count - 1) {
            tagsLabelHeight = 3 + CGRectGetMaxY(label.frame);
        }
    }
    // 收藏按钮的高度
    CGFloat productHeight = 105;
    // 推荐文字高度
    CGFloat recommendLabelHeight = 60;
    CGFloat workCountHeight = self.pictureDetailModel.recommendDesignerWorkCount > 0 ? 0 : -70;
    return coverImgViewHeight + descLabelHeight + tagsLabelHeight + productHeight + recommendLabelHeight +  workCountHeight;
}

/**
 * 计算文字的宽高
 */
- (CGSize)heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

/**
 * 计算带有行间距的文字宽高
 */
- (CGSize)heightForString:(NSString *)value Spacing:(CGFloat)spacing fontSize:(UIFont*)fontSize andWidth:(CGFloat)width {
    NSMutableAttributedString *coreText = [[NSMutableAttributedString alloc] initWithString:value];
    // 设置字体
    [coreText addAttribute:NSFontAttributeName value:fontSize range:NSMakeRange(0, coreText.length)];
    // 自动获取coreText所占CGSize 注意：获取前必须设置所有字体大小
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [coreText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [coreText length])];
    CGSize labelSize = [coreText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return labelSize;
}

#pragma mark - event


#pragma mark - XRWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    TXFindPictureListModel *model = self.recommendPictureList[indexPath.row];
    CGFloat imgHeight = model.height == 0 ? 3000 : model.height;
    CGFloat imgWidth = model.width == 0? 2000 :model.width;
    return imgHeight / imgWidth * width + 75 + 32;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recommendPictureList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXWaterfallColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.pictureListModel = self.recommendPictureList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH,self.discoverDetailReusableViewHeigth);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if (self.recommendPictureList.count > 0) {
//        return CGSizeMake(SCREEN_WIDTH, 0);
//    } else {
//        return CGSizeMake(SCREEN_WIDTH,300);
//    }
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //判断当前设置视图的位置（头部或者）
    if (kind == UICollectionElementKindSectionHeader) {
        self.reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:discoverDetailReusableViewID forIndexPath:indexPath];
        self.reusableHeaderView.pictureDetailModel = self.pictureDetailModel;
        self.reusableHeaderView.delegate = self;
        self.reusableHeaderView.isHasProductData = self.pictureDetailModel.recommendDesignerWorkCount > 0 ? true : false;
        self.reusableHeaderView.isHasRecommendData = self.recommendPictureList.count > 0 ? true : false;
        return self.reusableHeaderView;
    }
//    else if (kind == UICollectionElementKindSectionFooter)  {
//        TXDiscoverDetailFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:discoverDetailReusableFooterViewID forIndexPath:indexPath];
//        return footerView;
//    }
    else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"F" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXDiscoverDetailCollectionViewController *vwcDiscover = [TXDiscoverDetailCollectionViewController new];
    TXFindPictureListModel *model = self.recommendPictureList[indexPath.row];
    TXWaterfallColCell *cell = (TXWaterfallColCell*)[collectionView cellForItemAtIndexPath:indexPath];
    vwcDiscover.model = model;
    vwcDiscover.isHeat = false;
    vwcDiscover.fromSelectedId = self.toSelectedId;
    vwcDiscover.pictureDetailArray = self.recommendPictureList;
    vwcDiscover.currenIndex = [self.recommendPictureList indexOfObject:model];
    vwcDiscover.shareBlock = ^ () {
        model.shareCount += 1;
        if (model.shareCount >= 1000) {
            cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%0.1fk",model.shareCount/1000.0];
        }else {
            cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%@",@(model.shareCount)];
        }
    };

    vwcDiscover.favoriteBlock = ^ (BOOL isFavorite) {
        model.favorite = isFavorite;
        if (isFavorite == true) {
            model.favoriteCount += 1;
        }else {
            model.favoriteCount > 0 ? (model.favoriteCount -= 1) : (model.favoriteCount = 0);
        }
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
    [self.superViewController.navigationController pushViewController:vwcDiscover animated:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [cell.contentView layoutIfNeeded];
        [cell layoutIfNeeded];
        [collectionView layoutIfNeeded];
    });
}

// 实现无感加载
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isAnimationPullUp) {
        if (indexPath.row == self.recommendPictureList.count - 4) {
            [self loadMoreData];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginAnimationY = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    self.endAnimationY = scrollView.contentOffset.y;
    if (self.endAnimationY-self.beginAnimationY > 0) {
        self.animationPullUp = true;
    } else {
        self.animationPullUp = false;
    }
}


#pragma mark - TXWaterfallColCellDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(scrollView.contentOffset.y <= -70) {
        [self respondsToBackBtn:nil];
    }
}

- (void)respondsToBackBtn:(UIButton*)sender {
    ((TXDiscoverDetailCollectionViewController *)self.superViewController).headerView.hidden = NO;
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
    self.collectionView.hidden = YES;
    [self.superViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TXDiscoverDetailReusableViewDelegate

- (void)touchDealProductListBtn {
    TXProductionListViewController *vwcProList = [TXProductionListViewController new];
    vwcProList.pictureId = self.pictureDetailModel.ID;
    [self.superViewController.navigationController pushViewController:vwcProList animated:true];
}

- (void)discoverDetailReusableView:(TXDiscoverDetailReusableView *)headView clickHeadImgView:(UIImageView *)imgView {
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
    browseItem.bigImageUrl = self.model.imgUrl;// 加载网络图片大图地址
    browseItem.smallImageView = imgView;
    [browseItemArray addObject:browseItem];
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:0];
    [vwcBrowse showBrowseViewController];
}

#pragma mark - notify

- (void)userLoginSuceess:(NSNotification *)notification {
    [self initializeDataSource];
}

- (void)userPanToEnd:(NSNotification *)notification {
    // 非当前详情页下一级页面 禁止加载主页数据
    if ([notification.userInfo[@"from"] integerValue] != self.toSelectedId) {
        return;
    }

    _page += 1;
    self.pullUp = YES;
    self.pullDown = NO;
    if (self.dataCount < self.pageLength) {
        [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self getDiscoverGetRecommendPictureList];
    }
}

- (void)userScrollItem:(NSNotification *)notification {
    // 非当前详情页下一级页面 禁止加载主页数据
    if ([notification.userInfo[@"from"] integerValue] != self.toSelectedId) {
        return;
    }

    TXFindPictureListModel *model = notification.object;
    // 解决collectionView不滚动问题
    [self.collectionView layoutIfNeeded];
    if (model.indexPath.row + 1 > self.recommendPictureList.count) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:model.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:false];
}

#pragma mark - getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.waterfall = [[XRWaterfallLayout alloc]init];
        self.waterfall.delegate = self;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) collectionViewLayout:self.waterfall];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:discoverDetailReusableViewID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:discoverDetailReusableViewID];
//        [_collectionView registerNib:[UINib nibWithNibName:discoverDetailReusableFooterViewID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:discoverDetailReusableFooterViewID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"F"];
        _collectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _collectionView.mj_footer.automaticallyHidden = true;
    }
    return _collectionView;
}

/**
 网络错误页
 
 @return
 */
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _netView.delegate = self;
    }
    return _netView;
}

#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
- (void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
}

@end

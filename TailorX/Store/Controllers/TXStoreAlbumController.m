//
//  TXWorksViewController.m
//  TailorX
//
//  Created by Qian Shen on 6/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStoreAlbumController.h"
#import "MSSBrowseNetworkViewController.h"
#import "TXArthorInfoItemCell.h"
#import "XRWaterfallLayout.h"

static NSString *cellID = @"TXArthorInfoItemCell";

@interface TXStoreAlbumController ()<UICollectionViewDelegate,UICollectionViewDataSource,XRWaterfallLayoutDelegate>

/** 列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 布局*/
@property (nonatomic, strong) XRWaterfallLayout *waterfall;


@end

@implementation TXStoreAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeInterface];
}

#pragma mark - init


- (void)initializeInterface {
    self.navigationItem.title = @"门店相册";
    self.waterfall = [[XRWaterfallLayout alloc]init];
    self.waterfall.delegate = self;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) collectionViewLayout:self.waterfall];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [TXCustomTools customHeaderRefreshWithScrollView:self.collectionView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = 300;
    self.collectionView.bounces = YES;
    [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:self.collectionView];
    
}

- (void)loadNewData {
    [self.collectionView.mj_header endRefreshing];
}


#pragma mark - XRWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    TXPicturesModel *model = self.dataSource[indexPath.row];
    CGFloat imgHeight = model.height == 0 ? 300 : model.height;
    CGFloat imgWidth = model.width == 0 ? 200 :model.width;
    return imgHeight / imgWidth * width;
}

/**
 * 行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

/**
 * 垂直间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXArthorInfoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.pictureModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [self.dataSource count];i++) {
        TXArthorInfoItemCell *cell = (TXArthorInfoItemCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.smallImageView = cell.coverImgView;
        browseItem.bigImageUrl = self.dataSource[i].pictureUrl;// 加载网络图片大图地址
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray
                                                                                                   currentIndex:indexPath.item];
    [vwcBrowse showBrowseViewController];
}


@end

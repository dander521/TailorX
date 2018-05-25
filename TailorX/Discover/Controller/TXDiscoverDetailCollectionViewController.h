//
//  TXDiscoverDetailCollectionViewController.h
//  TailorX
//
//  Created by 程荣刚 on 2017/11/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFindPictureModel.h"
#import "TXInfomationHeadView.h"

typedef void (^ShareBlock)();
typedef void (^FavoriteBlock)(BOOL isFavorite);

@interface TXDiscoverDetailCollectionViewController : UIViewController<UINavigationControllerDelegate>

/** 数据*/
@property (nonatomic, strong) TXFindPictureListModel *model;
/** 分享回调*/
@property (nonatomic, copy) ShareBlock shareBlock;
/** 收藏回调*/
@property (nonatomic, copy) FavoriteBlock favoriteBlock;
/** 列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 首图*/
@property (nonatomic, strong) TXInfomationHeadView *headerView;
/** 用于详情页滚动数组*/
@property (nonatomic, strong) NSMutableArray<TXFindPictureListModel*> *pictureDetailArray;
/** 区分最新发布和最热 */
@property (nonatomic, assign) BOOL isHeat;
/** 用来区分发现详情点击推荐跳转发现详情的controller 避免通知多次响应影响动画效果 */
/** 上一controller传递的Id */
@property (nonatomic, assign) NSInteger fromSelectedId;
/** 传递的当前页面Id */
@property (nonatomic, assign) NSInteger toSelectedId;
/** 当前滑动位置在循环数组pictureDetailArray中索引*/
@property (nonatomic, assign) NSInteger currenIndex;

/** 缓存字典 根据模型id - TXCacheRecommendPictureModel 进行数据缓存 */
@property (nonatomic, strong) NSMutableDictionary *cacheDictionary;

@end

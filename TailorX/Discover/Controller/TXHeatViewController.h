//
//  TXHeatView.h
//  TailorX
//
//  Created by Qian Shen on 5/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)();

typedef void (^TotalSizeBlock)(NSInteger size);

typedef NS_ENUM(NSInteger, TXHeatViewType) {
    TXHeatViewTypeDiscover,
    TXHeatViewTypeSearch
};

@protocol TXHeatViewDelegate <NSObject>

- (void)scrollHeatScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

- (void)scrollHeatScrollViewWillBeginDragging:(UIScrollView *)scrollView;

/**
 点击发现页面设计师按钮
 
 @param designerId
 */
- (void)touchHeatDesignerButtonWithDesignerId:(NSString *)designerId;

@end

@interface TXHeatViewController : UIView

-(instancetype)initWithFrame:(CGRect)frame heatType:(TXHeatViewType)heatType;

@property (nonatomic, strong) NSString *keyString;

@property (nonatomic, assign) TXHeatViewType heatType;
/** 列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 下拉刷新 */
@property (nonatomic, copy) RefreshBlock refreshBlock;
@property (nonatomic, copy) TotalSizeBlock sizeBlock;
/** 筛选参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;

@property (nonatomic, assign) id <TXHeatViewDelegate> delegate;

@end

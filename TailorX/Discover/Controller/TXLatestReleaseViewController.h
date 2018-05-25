//
//  TXLatestReleaseView.h
//  TailorX
//
//  Created by Qian Shen on 5/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)();

@protocol TXLatestReleaseViewDelegate <NSObject>

- (void)scrollLatestScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

- (void)scrollLatestScrollViewWillBeginDragging:(UIScrollView *)scrollView;

/**
 点击发现页面设计师按钮

 @param designerId 
 */
- (void)touchLatestDesignerButtonWithDesignerId:(NSString *)designerId;

@end

@interface TXLatestReleaseViewController : UIView

/** 下拉刷新 */
@property (nonatomic, copy) RefreshBlock refreshBlock;
/** 列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 筛选参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** description */
@property (nonatomic, assign) id <TXLatestReleaseViewDelegate> delegate;

@end

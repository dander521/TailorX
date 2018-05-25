//
//  MSSBrowseBaseViewController.h
//  MSSBrowse
//
//  Created by 于威 on 16/4/26.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSBrowseCollectionViewCell.h"
#import "MSSBrowseModel.h"

typedef void(^MSSBrowseControllerDismissBlock)(NSIndexPath *);

typedef void(^MSSBrowseControllerDeletePictureBlock)(NSInteger);

@interface MSSBrowseBaseViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate>

@property (nonatomic,assign)BOOL isEqualRatio;// 大小图是否等比（默认为等比）

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)BOOL isFirstOpen;
@property (nonatomic,assign)CGFloat screenWidth;
@property (nonatomic,assign)CGFloat screenHeight;
/** 是否需要弹窗出现删除图片*/
@property (nonatomic, assign) BOOL isDelete;


- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex;
- (void)showBrowseViewController;

// 子类重写此方法
- (void)loadBrowseImageWithBrowseItem:(MSSBrowseModel *)browseItem Cell:(MSSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect;
- (void)showBrowseRemindViewWithText:(NSString *)text;
// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view;


/** 退出图片浏览器后用于回传index的block */
@property (copy, nonatomic) MSSBrowseControllerDismissBlock dismissBlock;
/** 删除图片时回调*/
@property (nonatomic, copy) MSSBrowseControllerDeletePictureBlock deleteBlock;




@end

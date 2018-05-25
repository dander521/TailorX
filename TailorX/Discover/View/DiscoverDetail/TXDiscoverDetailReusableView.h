//
//  TXDiscoverDetailReusableView.h
//  TailorX
//
//  Created by Qian Shen on 18/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFindPictureDetailModel.h"

@class TXDiscoverDetailReusableView;

@protocol TXDiscoverDetailReusableViewDelegate <NSObject>

@optional

- (void)touchDealProductListBtn;

- (void)discoverDetailReusableView:(TXDiscoverDetailReusableView*)headView clickHeadImgView:(UIImageView*)imgView;

@end

@interface TXDiscoverDetailReusableView : UICollectionReusableView

/** 封面图*/
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
/** 发现详情*/
@property (nonatomic, strong) TXFindPictureDetailModel *pictureDetailModel;
/** 代理*/
@property (nonatomic, assign) id <TXDiscoverDetailReusableViewDelegate> delegate;

/** 是否有推荐内容 */
@property (nonatomic, assign) BOOL isHasRecommendData;
/** 是否有推荐内容 */
@property (nonatomic, assign) BOOL isHasProductData;

@end

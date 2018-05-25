//
//  TXHomePageCullingModel.h
//  TailorX
//
//  Created by Qian Shen on 1/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHomePageCullingModel : NSObject

/** 图片url*/
@property (nonatomic, strong) NSString  *infoPic;
/** 图片id*/
@property (nonatomic, assign) NSInteger infoId;
/** 最小价格*/
@property (nonatomic, assign) NSInteger minPrice;
/** 最大价格*/
@property (nonatomic, assign) NSInteger maxPrice;
/** 名字*/
@property (nonatomic, strong) NSString  *name;
/** 图片宽度*/
@property (nonatomic, assign) CGFloat height;
/** 图片高度*/
@property (nonatomic, assign) CGFloat width;
/** 是否收藏 (0未收藏，1已收藏)*/
@property (nonatomic, assign) NSInteger isLiked;
/** 浏览量*/
@property (nonatomic, assign) NSInteger amountOfReading;
/** 收藏量*/
@property (nonatomic, assign) NSInteger popularity;

@property (nonatomic, strong) NSString *informationNo;

@end

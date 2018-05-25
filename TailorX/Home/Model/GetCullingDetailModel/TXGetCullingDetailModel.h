//
//  TXGetCullingDetailModel.h
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXGetCullingDetailModel : NSObject

/** 精选图1*/
@property (nonatomic, strong) NSString *cullingPic1;
/** 精选图2*/
@property (nonatomic, strong) NSString *cullingPic2;
/** 精选图3*/
@property (nonatomic, strong) NSString *cullingPic3;
/** 精选图4*/
@property (nonatomic, strong) NSString *cullingPic4;
/** 精选图5*/
@property (nonatomic, strong) NSString *cullingPic5;
/** 精选图6*/
@property (nonatomic, strong) NSString *cullingPic6;
/** 精选图ID*/
@property (nonatomic, assign) NSInteger ID;
/** 是否被收藏，0未收藏，1已收藏*/
@property (nonatomic, assign) NSInteger isLiked;
/** 描述*/
@property (nonatomic, strong) NSString *picDescribe;

@end

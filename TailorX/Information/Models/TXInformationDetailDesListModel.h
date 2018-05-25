//
//  TXInformationDetailDesListModel.h
//  TailorX
//
//  Created by 温强 on 2017/4/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXInformationDetailDesListModel : NSObject

/** 文字描述*/
@property (nonatomic, strong) NSString *des;
/** 描述图片地址*/
@property (nonatomic, strong) NSString *infoPic;
/** 顺序*/
@property (nonatomic, assign) NSInteger order;
/** 资讯ID*/
@property (nonatomic, assign) NSInteger ID;
/** 最小价格*/
@property (nonatomic, copy)   NSString *minPrice;
/** 最大价格*/
@property (nonatomic, copy)   NSString *maxPrice;
/** 图片高*/
@property (nonatomic, assign) CGFloat height;
/** 图片宽*/
@property (nonatomic, assign) CGFloat width;
/** 是否加载*/
@property (nonatomic, assign) BOOL isLoad;

@end

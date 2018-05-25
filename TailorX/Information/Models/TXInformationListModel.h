//
//  TXInformationListModel.h
//  TailorX
//
//  Created by 温强 on 2017/4/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXInformationListModel : NSObject

/** 封面图url*/
@property (nonatomic, strong) NSString * coverUrl;
/** 设计师名字*/
@property (nonatomic, strong) NSString * designerName;
/** 设计师头像*/
@property (nonatomic, strong) NSString * designerPhoto;
/** 资讯ID*/
@property (nonatomic, strong) NSString * ID;
/** 是否收藏（0未收藏，1已收藏*/
@property (nonatomic, assign) NSInteger isLiked;
/** 价格上限*/
@property (nonatomic, assign) NSInteger maxPrice;
/** 价格下限*/
@property (nonatomic, assign) NSInteger minPrice;
/** 资讯名称*/
@property (nonatomic, strong) NSString * name;
/** 人气*/
@property (nonatomic, assign) NSInteger popularity;
/** 设计师评分*/
@property (nonatomic, assign) NSInteger score;
/** 门店名称*/
@property (nonatomic, strong) NSString * storeName;
/** 更新时间*/
@property (nonatomic, assign) NSInteger updateDate;
/** 阅读量*/
@property (nonatomic, assign) NSInteger amountOfReading;
/** 资讯编号*/
@property (nonatomic, strong) NSString *informationNo;
/** 分享量*/
@property (nonatomic, assign) NSInteger shareCount;
/** 图片宽度*/
@property (nonatomic, assign) CGFloat height;
/** 图片高度*/
@property (nonatomic, assign) CGFloat width;
/** 设计师擅长风格*/
@property (nonatomic, strong) NSString *goodStyle;

@end

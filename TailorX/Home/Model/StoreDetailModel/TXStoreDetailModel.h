//
//  TXStoreDetailModel.h
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXStoreDetailModel : NSObject

/** 门店地址*/
@property (nonatomic, strong) NSString *address;
/** 门店封面图*/
@property (nonatomic, strong) NSString *coverImage;
/** 没用*/
@property (nonatomic, strong) NSString *createDateStr;
/** 门店id*/
@property (nonatomic, assign) NSInteger ID;
/** 店名*/
@property (nonatomic, strong) NSString *name;
/** 最新录入设计师的头像*/
@property (nonatomic, strong) NSArray *nDesignerPhotoList;
/** 门店电话*/
@property (nonatomic, strong) NSString *phone;
/** 门店星级*/
@property (nonatomic, assign) NSInteger score;
/** 门店状态 0：建设中 1：运营中）*/
@property (nonatomic, assign) NSInteger status;
/** 门店的订单数*/
@property (nonatomic, assign) NSInteger totalOrderCount;
/** banner图*/
@property (nonatomic, strong) NSArray *imageArray;
/** 门店介绍*/
@property (nonatomic, strong) NSString *introduce;
/** 门店营业时间*/
@property (nonatomic, strong) NSString *workTime;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

/** 门店图片*/
@property (nonatomic, strong) NSArray *pictures;
/** 门店是否与当前位置同城*/
@property (nonatomic, assign) BOOL isSameCity;

@end

@interface TXPicturesModel : NSObject

/** 图片ID*/
@property (nonatomic, strong) NSString *ID;
/** 门店ID*/
@property (nonatomic, strong) NSString *storeId;
/** 图片URL*/
@property (nonatomic, strong) NSString *pictureUrl;
/** 图片高*/
@property (nonatomic, assign) CGFloat height;
/** 图片宽*/
@property (nonatomic, assign) CGFloat width;

@end

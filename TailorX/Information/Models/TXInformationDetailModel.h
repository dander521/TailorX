//
//  TXInformationDetailModel.h
//  TailorX
//
//  Created by 温强 on 2017/4/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXInfomationDetailHeadInfoModel.h"

@interface TXInformationDetailModel : NSObject

@property (nonatomic, strong) NSArray  *commonList;
@property (nonatomic, strong) NSArray  *desList;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *createDateStr;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger designerId;
@property (nonatomic, strong) NSString *designerName;
@property (nonatomic, strong) NSString *designerPhoto;
@property (nonatomic, assign) NSInteger feedbackCount;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString  *informationNo;
@property (nonatomic, assign) NSInteger isLiked;
@property (nonatomic, assign) NSInteger maxPrice;
@property (nonatomic, assign) NSInteger minPrice;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *phone;
@property (nonatomic, assign) NSInteger popularity;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, strong) NSString  *tatusStr;
@property (nonatomic, strong) NSArray   *systemList;
@property (nonatomic, assign) BOOL favoriteDesigner;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSString  *designerIntroduction;
@property (nonatomic, strong) NSString  *tags;

// 头部字段
@property(nonatomic, strong)NSString    *headInfoPic;
@property(nonatomic, assign)NSInteger   headIsFirst;
@property(nonatomic, assign)NSInteger   headInfoId;
@property(nonatomic, assign)NSInteger   headID;
@property(nonatomic, assign)NSInteger   headCreateDate;

@end

//desList：描述列表； description：文字描述； infoPic：描述图片地址； order：顺序； designerName：设计师名称； designerPhoto：设计师头像； goodStyle：品类； id：资讯ID； isLiked：是否收藏（0未收藏，1已收藏）； maxPrice：价格上限； minPrice：价格下限； name：资讯名称； headPic：咨询详情头图； infoPic:咨询详情头图路径； infoPic：图片地址； isFirst：是否为封面（0否，1是）； popularity：人气； score：设计师评分；

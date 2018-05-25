//
//  TXProductDetailModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/11/9.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TagsInfo;
@class RulesInfo;

@interface TXProductDetailModel : NSObject

/** 是否有客户信息 1：没有 */
@property (nonatomic, strong) NSString *sourceType;

/*****************************作品信息***************************************/

/** 作品描述 */
@property (nonatomic, strong) NSString *title;
/** 作品价格 */
@property (nonatomic, strong) NSString *price;
/** 系统标签 */
@property (nonatomic, strong) NSArray <TagsInfo *>*systemTags;
/** 普通标签 */
@property (nonatomic, strong) NSArray <TagsInfo *>*commonTags;

/*****************************设计师***************************************/

/** 设计师头像 */
@property (nonatomic, strong) NSString *designerPhoto;
/** 设计师名称 */
@property (nonatomic, strong) NSString *designerName;
/** 设计师描述 */
@property (nonatomic, strong) NSString *designerIntroduction;
/** 设计师id */
@property (nonatomic, strong) NSString *designerId;

/******************************参考图**************************************/

/** 参考图 ;号连接 */
@property (nonatomic, strong) NSString *referencePictures;

/*******************************设计稿*************************************/

/** 设计稿 ,号连接 */
@property (nonatomic, strong) NSString *designUrl;

/*******************************设计尺寸*************************************/

/*******************************客户信息**************************************/

/** 用户头像 */
@property (nonatomic, strong) NSString *customerPhoto;
/** 用户名 */
@property (nonatomic, strong) NSString *customerName;
/** 定制时间 */
@property (nonatomic, strong) NSString *createDateStr;
/** 客户量体尺寸 */
@property (nonatomic, strong) NSArray <RulesInfo *>*customerBodyList;

/*******************************评价**************************************/
/** 评价内容 */
@property (nonatomic, strong) NSString *customerEvaluate;
/** 综合评分 */
@property (nonatomic, strong) NSString *overallScore;
/** 设计师评分 */
@property (nonatomic, strong) NSString *designerScore;
/** 工厂评分 */
@property (nonatomic, strong) NSString *factoryScore;
/** 买家秀图片 */
@property (nonatomic, strong) NSArray *customerUpLoadPics;

/** 图片尺寸 */
@property (nonatomic, strong) NSDictionary *picturesSize;

@end

@interface TagsInfo : NSObject

@property (nonatomic, assign) NSInteger author;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger delFlag;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) NSInteger type;

@end

@interface RulesInfo : NSObject

@property (nonatomic, strong) NSString *labelName;
@property (nonatomic, strong) NSString *createDateStr;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *updateDateStr;

@property (nonatomic, assign) NSInteger labelId;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger updateDate;
@property (nonatomic, assign) NSInteger createDate;
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, assign) NSInteger orderWorkNo;


@end


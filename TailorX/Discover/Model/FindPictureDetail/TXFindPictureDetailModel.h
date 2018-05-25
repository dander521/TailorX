//
//  TXFindPictureDetailModel.h
//  TailorX
//
//  Created by Qian Shen on 21/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXFindPictureDetailModel : NSObject

@property (nonatomic, strong) NSString  *desc;
@property (nonatomic, strong) NSString *designerId;
@property (nonatomic, strong) NSString  *designerName;
@property (nonatomic, strong) NSString  *designerPhoto;
@property (nonatomic, assign) BOOL favorite;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, strong) NSString  *ID;
@property (nonatomic, strong) NSString  *imgUrl;
@property (nonatomic, assign) NSInteger publishTime;
@property (nonatomic, assign) NSInteger shareCount;
//@property (nonatomic, strong) NSString *tags;
/** 图片宽度*/
@property (nonatomic, assign) CGFloat height;
/** 图片高度*/
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL favoriteDesigner;

/*************************数据返回格式不统一 需要转换*******************************/
@property (nonatomic, strong) NSString *designerIntroduction;
@property (nonatomic, strong) NSString *introduction;

@property (nonatomic, strong) NSString *productionPictures;
@property (nonatomic, strong) NSArray *designerProduction;

@property (nonatomic, strong) NSArray *tagsCommon;
@property (nonatomic, strong) NSString *tagName;
/*************************数据返回格式不统一 需要转换*******************************/

/** 成交作品数量 */
@property (nonatomic, assign) NSInteger recommendDesignerWorkCount;

@end

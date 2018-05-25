//
//  TXFindPictureModel.h
//  TailorX
//
//  Created by Qian Shen on 21/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXFindPictureDetailModel.h"

@interface TXFindPictureListModel : NSObject

@property (nonatomic, strong) NSString  *desc;
// 收藏发现 desc 字段为 name
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) BOOL favorite;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, strong) NSString  *ID;
@property (nonatomic, strong) NSString  *imgUrl;
@property (nonatomic, strong) NSString  *coverUrl; //imgUrl nil
@property (nonatomic, assign) NSInteger publishTime;
@property (nonatomic, assign) NSInteger shareCount;
/** 图片宽度*/
@property (nonatomic, assign) CGFloat height;
/** 图片高度*/
@property (nonatomic, assign) CGFloat width;
/** 用于页面返回确认位置 */
@property (nonatomic, strong) NSIndexPath *indexPath;

// 推荐图片详情
@property (nonatomic, strong) NSString *descriptionField;
@property (nonatomic, strong) NSString *designerName;
@property (nonatomic, strong) NSString *designerId;
@property (nonatomic, strong) NSString *designerPhoto;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *goodStyle;
@property (nonatomic, strong) NSString *tagId;
@property (nonatomic, strong) NSObject *tagList;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSObject *tagNameList;
@property (nonatomic, strong) NSObject *tagType;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSArray *designerProduction;
@property (nonatomic, strong) NSArray *tagsCommon;
@property (nonatomic, strong) NSString *designerIntroduction;
@property (nonatomic, strong) NSString *productionPictures;
@property (nonatomic, assign) BOOL favoriteDesigner;
/** 成交作品数量 */
@property (nonatomic, assign) NSInteger recommendDesignerWorkCount;


- (TXFindPictureDetailModel *)transformListModelToDetailModel;


@end

@interface TXFindPictureModel : NSObject

@property (nonatomic, strong) NSMutableArray<TXFindPictureListModel*> *data;
@property (nonatomic, strong) NSString *publishTime;

@end



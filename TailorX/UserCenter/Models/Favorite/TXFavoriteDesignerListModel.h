//
//  TXFavoriteDesignerListModel.h
//  TailorX
//
//  Created by 温强 on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXFavoriteDesignerListModel : NSObject
@property (nonatomic, strong) NSString * goodStyle;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) BOOL like;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * photo;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSArray * styleArray;
@property (nonatomic, assign) NSInteger work;
/** 距离*/
@property (nonatomic, assign) CGFloat distance;
/** 门店名称*/
@property (nonatomic, strong) NSString *storeName;
/** 作品*/
@property (nonatomic, strong) NSString *productionPictures;
/** 简介*/
@property (nonatomic, strong) NSString *introduction;

@end

//designerId：设计师ID； name：设计师名称； photo：设计师头像； score：设计师评分； goodStyle：擅长风格； like：是否被收藏； work：是否工作中；

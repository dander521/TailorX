//
//  TXFavoriteDataTool.h
//  TailorX
//
//  Created by 温强 on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXFavoriteDataTool : NSObject

// 解析个人收藏精选图模型数组
+ (NSArray *)getFavoriteChoiceListArrayWith:(id)data;

// 解析个人收藏设计师模型数组
+ (NSArray *)getFavoriteDesignerListArrayWith:(id)data;

@end

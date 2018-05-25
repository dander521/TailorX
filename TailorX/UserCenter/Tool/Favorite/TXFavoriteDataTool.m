//
//  TXFavoriteDataTool.m
//  TailorX
//
//  Created by 温强 on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFavoriteDataTool.h"
#import "TXInformationListModel.h"
#import "TXFavoriteDesignerListModel.h"

@implementation TXFavoriteDataTool
// 解析个人收藏精选图模型数组
+ (NSArray *)getFavoriteChoiceListArrayWith:(id)data {
    
    NSArray *listDicArray = data[@"data"][@"data"];
    NSArray *listModelArray = [TXInformationListModel mj_objectArrayWithKeyValuesArray:listDicArray];
    return [listModelArray copy];
}

// 解析个人收藏设计师模型数组
+ (NSArray *)getFavoriteDesignerListArrayWith:(id)data {
    
    NSArray *listDicArray = data[@"data"][@"data"];
    NSArray *listModelArray = [TXFavoriteDesignerListModel mj_objectArrayWithKeyValuesArray:listDicArray];
    return [listModelArray copy];
}

@end

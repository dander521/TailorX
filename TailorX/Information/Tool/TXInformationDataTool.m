//
//  TXInformationDataTool.m
//  TailorX
//
//  Created by 温强 on 2017/4/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInformationDataTool.h"

@implementation TXInformationDataTool

+ (NSArray *)getInformationListModelAryFromData:(id)data {
    NSArray *listDicArray = data[@"data"][@"data"];
    NSArray *listModelArray = [TXInformationListModel mj_objectArrayWithKeyValuesArray:listDicArray];
    return [listModelArray copy];
}

+ (NSArray *)getAllStoreNameListFromData:(id)data {
    NSArray *listDicArray = data[@"data"];
    NSArray *listModelArray = [TXInformationStroeNameList mj_objectArrayWithKeyValuesArray:listDicArray];
    return [listModelArray copy];
}

+ (TXInformationDetailModel *)getInformationDetailModelFromData:(id)data{
    
    NSDictionary *modelDic = data[@"data"];
    TXInformationDetailModel *model = [TXInformationDetailModel mj_objectWithKeyValues:modelDic];
    return model;
}

+ (NSArray *)getInformationCommentDataAryFrom:(id)data {
    NSArray *listDicArray = data[@"data"][@"data"];
    NSArray *listModelArray = [TXInformationCommetModel mj_objectArrayWithKeyValuesArray:listDicArray];
    return [listModelArray copy];
}

@end

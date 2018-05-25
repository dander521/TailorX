//
//  TXStroeDataTool.m
//  TailorX
//
//  Created by 温强 on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStroeDataTool.h"
#import "TXStroeListModel.h"

@implementation TXStroeDataTool

+ (NSArray *)getStroeListModelArrayWithData:(id)data {
    NSArray *listDicArray = data[@"data"][@"data"];
    NSArray *listModelArray = [TXStroeListModel mj_objectArrayWithKeyValuesArray:listDicArray];
    return [listModelArray copy];
}

@end

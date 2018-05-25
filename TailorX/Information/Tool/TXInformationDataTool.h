//
//  TXInformationDataTool.h
//  TailorX
//
//  Created by 温强 on 2017/4/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXInformationListModel.h"
#import "TXInformationStroeNameList.h"
#import "TXInformationDetailModel.h"
#import "TXInformationCommetModel.h"
#import "TXInfomationDetailHeadInfoModel.h"

@interface TXInformationDataTool : NSObject

/**
 * 获取查询后的资讯数组
 */
+ (NSArray *)getInformationListModelAryFromData:(id)data;

/**
 * 获取所有门店名字
 */
+ (NSArray *)getAllStoreNameListFromData:(id)data;

/**
 * 获取资讯详情
 */
+ (TXInformationDetailModel *)getInformationDetailModelFromData:(id)data;

/**
 * 获取评论列表
 */
+ (NSArray *)getInformationCommentDataAryFrom:(id)data;

@end

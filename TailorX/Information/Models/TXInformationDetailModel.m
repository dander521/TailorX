//
//  TXInformationDetailModel.m
//  TailorX
//
//  Created by 温强 on 2017/4/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInformationDetailModel.h"
#import "TXInformationDetailDesListModel.h"
#import "TXInfomationHeaderTabCell.h"

@implementation TXInformationDetailModel

MJExtensionCodingImplementation
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id",
             @"desc" : @"description",
             @"headInfoPic" : @"headPic.infoPic",
             @"headIsFirst" : @"headPic.isFirst",
             @"headInfoId" : @"headPic.infoId",
             @"headID" : @"headPic.id",
             @"headCreateDate" : @"headPic.createDate"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{@"desList":@"TXInformationDetailDesListModel",
             @"commonList":@"TagsCommonInfo"};
}



@end

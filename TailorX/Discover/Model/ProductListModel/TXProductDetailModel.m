//
//  TXProductDetailModel.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/9.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductDetailModel.h"

@implementation TXProductDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"systemTags" : @"TagsInfo",
             @"commonTags" : @"TagsInfo",
             @"customerBodyList" : @"RulesInfo"
             };
}

@end


@implementation TagsInfo : NSObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end


@implementation RulesInfo : NSObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end


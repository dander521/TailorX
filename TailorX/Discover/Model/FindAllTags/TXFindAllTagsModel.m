//
//  TXFindAllTagsModel.m
//  TailorX
//
//  Created by Qian Shen on 18/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFindAllTagsModel.h"

@implementation SystemTag

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"season":@"TagInfo",
             @"sex":@"TagInfo",
             @"style":@"TagInfo"
             };
}

@end

@implementation TagInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end


@implementation TXFindAllTagsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"commonTags" : @"TagInfo"};
}

@end

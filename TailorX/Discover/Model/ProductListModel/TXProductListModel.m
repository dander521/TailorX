//
//  TXProductListModel.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductListModel.h"

@implementation TXProductListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end

@implementation TXProductListCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : @"TXProductListModel"};
}

@end

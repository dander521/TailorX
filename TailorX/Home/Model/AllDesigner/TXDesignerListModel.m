//
//  TXDesignerListModel.m
//  TailorX
//
//  Created by 程荣刚 on 2017/8/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignerListModel.h"

@implementation TXDesignerListModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end

@implementation TXAllDesignerListModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [TXDesignerListModel class]};
}

@end

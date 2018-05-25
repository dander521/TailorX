//
//  TXTagGroupModel.m
//  TailorX
//
//  Created by Qian Shen on 21/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTagGroupModel.h"

@implementation TXTagGroupModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id",
             @"desc": @"description"};
}

@end

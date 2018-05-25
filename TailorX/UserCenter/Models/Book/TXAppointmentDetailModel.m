//
//  TXAppointmentDetailModel.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAppointmentDetailModel.h"

@implementation TXAppointmentDetailModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID" : @"id",
             @"desc":@"description"};
}

/**
 * 合并用户标签
 */
- (NSString *)combineUsertags {
    NSMutableArray *temArray = [NSMutableArray new];
    if (self.tagStrs && self.tagStrs.count > 0) {
        for (int i = 0; i<self.tagStrs.count; i++) {
            if (![NSString isTextEmpty:self.tagStrs[i]]) {
                [temArray addObject:self.tagStrs[i]];
            }
        }
    }
    if (temArray.count == 0) {
        return @"暂无标签";
    } else {
        return [temArray componentsJoinedByString:@"、"];
    }
}

@end

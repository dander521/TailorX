//
//  TXQueueNoModel.m
//  TailorX
//
//  Created by liuyanming on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXQueueNoModel.h"

@implementation TXQueueNoModel

MJCodingImplementation

@end

@implementation TXQueueNoList

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"queueNos" : @"data",
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"queueNos" : [TXQueueNoModel class],
             };
}

MJCodingImplementation

@end

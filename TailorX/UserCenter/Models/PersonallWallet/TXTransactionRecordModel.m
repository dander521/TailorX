//
//  TXTransactionRecordModel.m
//  TailorX
//
//  Created by liuyanming on 2017/4/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTransactionRecordModel.h"

@implementation TXTransactionRecordModel
MJCodingImplementation
@end


@implementation TXTransactionRecordModelList

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : [TXTransactionRecordModel class],
             };
}


MJCodingImplementation

@end

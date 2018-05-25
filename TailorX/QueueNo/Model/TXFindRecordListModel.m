//
//  TXFindRecordListModel.m
//  TailorX
//
//  Created by liuyanming on 2017/4/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFindRecordListModel.h"

@implementation TXFindRecordModel

MJCodingImplementation

@end

@implementation TXFindRecordListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : [TXFindRecordModel class],
             };
}

MJCodingImplementation

@end



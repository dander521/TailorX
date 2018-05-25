//
//  TXCardType.m
//  TailorX
//
//  Created by RogerChen on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCardTypeModel.h"

@implementation TXCardTypeModel

MJCodingImplementation

@end

@implementation TXCardTypeCollectionModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [TXCardTypeModel class]};
}

@end

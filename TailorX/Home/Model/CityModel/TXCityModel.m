//
//  TXCityModel.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCityModel.h"

@implementation TXCityModel

MJCodingImplementation

@end

@implementation TXCityCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [TXCityModel class]};
}

MJCodingImplementation

@end

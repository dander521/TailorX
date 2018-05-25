//
//  TXAddress.m
//  TailorX
//
//  Created by RogerChen on 2017/4/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAddressModel.h"

@implementation TXAddressModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"idField" : @"id",};
}

- (NSString *)combineUserAddress {
    if ([[self isNull:self.provinceName] containsString:@"北京"] ||
        [[self isNull:self.provinceName] containsString:@"天津"] ||
        [[self isNull:self.provinceName] containsString:@"重庆"] ||
        [[self isNull:self.provinceName] containsString:@"上海"]) {
        return [NSString stringWithFormat:@"%@%@%@", [self isNull:self.provinceName], [self isNull:self.districtName], [self isNull:self.address]];
    }
    return [NSString stringWithFormat:@"%@%@%@%@", [self isNull:self.provinceName], [self isNull:self.cityName], [self isNull:self.districtName], [self isNull:self.address]];
}

- (NSString *)isNull:(NSString *)string {
    if (string == nil) {
        return @"";
    }
    return string;
}

@end

@implementation TXAddressCollectionModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [TXAddressModel class]};
}

@end

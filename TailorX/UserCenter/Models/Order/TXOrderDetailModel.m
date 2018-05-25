//
//  TXOrderDetail.m
//  TailorX
//
//  Created by RogerChen on 2017/4/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXOrderDetailModel.h"

@implementation TXOrderDetailModel

MJCodingImplementation

/**
 * 将详情模型转化为订单模型
 */
- (TXOrderModel *)convertOrderDetailModelToOrderModel {
    TXOrderModel *order = [TXOrderModel new];
    order.designerName = self.designerName;
    order.orderName = self.orderName;
    order.orderNo = self.orderNo;
    order.categoryName = self.categoryName;
    order.totalAmount = self.totalAmount;
    order.discountPrice = self.discountPrice;
    order.discount = self.discount;
    order.totalListPrice = self.totalListPrice;
    order.orderRankNo = self.sortNo;
    order.styleUrl = self.styleUrl;
    order.status = @"13"; // 联系门店
    order.tagStrs = self.tagStrs;
    
    return order;
}

- (NSString *)combineOrderCategory {
    if ([NSString isTextEmpty:self.secondCategoryName]) {
        return [NSString stringWithFormat:@"%@", self.firstCategoryName];
    }
    if ([NSString isTextEmpty:self.thirdCategoryName]) {
        return [NSString stringWithFormat:@"%@-%@", self.firstCategoryName, self.secondCategoryName];
    }
    return [NSString stringWithFormat:@"%@-%@-%@", self.firstCategoryName, self.secondCategoryName, self.thirdCategoryName];
}

- (NSString *)combineUserAddress {
    if ([[self isNull:self.deliveryAddress.provinceName] containsString:@"北京"] ||
        [[self isNull:self.deliveryAddress.provinceName] containsString:@"天津"] ||
        [[self isNull:self.deliveryAddress.provinceName] containsString:@"重庆"] ||
        [[self isNull:self.deliveryAddress.provinceName] containsString:@"上海"]) {
        return [NSString stringWithFormat:@"%@%@%@", [self isNull:self.deliveryAddress.provinceName], [self isNull:self.deliveryAddress.districtName], [self isNull:self.deliveryAddress.address]];
    }
    return [NSString stringWithFormat:@"%@%@%@%@", [self isNull:self.deliveryAddress.provinceName], [self isNull:self.deliveryAddress.cityName], [self isNull:self.deliveryAddress.districtName], [self isNull:self.deliveryAddress.address]];
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

- (NSString *)isNull:(NSString *)string {
    if (string == nil) {
        return @"";
    }
    return string;
}


@end

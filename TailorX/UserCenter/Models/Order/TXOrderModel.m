//
//  TXOrder.m
//  TailorX
//
//  Created by RogerChen on 24/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXOrderModel.h"

@implementation TXOrderModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"orderId" : @"id"};
}

@end

@implementation TXOrderHeaderModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"order" : [TXOrderModel class]};
}

@end

@implementation TXAllOrderModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [TXOrderHeaderModel class]};
}


@end

@implementation TXAllServerOrdersModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [TXOrderModel class]};
}

/**
 转换服务器order为headerOrder
 
 @param serverOrder
 @return
 */
- (NSMutableArray <TXOrderHeaderModel *>*)converAllOrdersToAllModelWithServerOrder:(TXAllServerOrdersModel *)serverOrder {
    NSMutableArray *storeIdArray = [NSMutableArray new];
    NSMutableArray *headerArray = [NSMutableArray new];
    for (TXOrderModel *order in serverOrder.data) {
        if (![storeIdArray containsObject:[NSString stringWithFormat:@"%ld", (long)order.storeId]]) {
            [storeIdArray addObject:[NSString stringWithFormat:@"%ld", (long)order.storeId]];
            TXOrderHeaderModel *header = [TXOrderHeaderModel new];
            header.order = [NSMutableArray new];
            header.storeId = order.storeId;
            header.storeName = order.storeName;
            [headerArray addObject:header];
        }
        
        for (TXOrderHeaderModel *header in headerArray) {
            if (header.storeId == order.storeId) {
                [header.order addObject:order];
            }
        }
    }
    
    return headerArray;
}


/**
 处理数据源
 
 @param orderHeaderArray
 */
- (void)addMoreDataWithServerOrder:(TXAllServerOrdersModel *)serverOrder allOrderModel:(TXAllOrderModel *)allOrdersModel {
    if (serverOrder.data.count == 0) {
        return;
    }
    
    NSMutableArray *orderHeaderArray = [self converAllOrdersToAllModelWithServerOrder:serverOrder];
    
    BOOL isExsit = false;
    
    if (allOrdersModel.data.count == 0) {
        allOrdersModel.data = orderHeaderArray;
    } else {
        for (TXOrderHeaderModel *moreHeader in orderHeaderArray) {
            for (TXOrderHeaderModel *header in allOrdersModel.data) {
                if (header.storeId == moreHeader.storeId) {
                    isExsit = true;
                    [header.order addObjectsFromArray:moreHeader.order];
                    break;
                }
            }
            if (isExsit == false) {
                [allOrdersModel.data addObject:moreHeader];
            }
        }
    }
}


@end

//
//  TXPayOrder.h
//  TailorX
//
//  Created by RogerChen on 2017/4/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXPayOrderModel : NSObject

/** 实付款 */
@property (nonatomic, assign) NSInteger totalAmount;
/** 排号 */
@property (nonatomic, strong) NSString *orderRankNo;
/** 支付方式(1:支付宝 2:余额)  */
@property (nonatomic, assign) NSInteger payMethod;
/** 排号id */
@property (nonatomic, strong) NSString *rankNumberId;

@end

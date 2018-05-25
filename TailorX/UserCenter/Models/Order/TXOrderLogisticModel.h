//
//  TXOrderLogistic.h
//  TailorX
//
//  Created by RogerChen on 2017/4/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXOrderLogisticModel : NSObject

/**  */
@property (nonatomic, strong) NSString *com;
/** 快递名称  */
@property (nonatomic, strong) NSString *company;
/**  */
@property (nonatomic, strong) NSArray *data;
/**  */
@property (nonatomic, assign) BOOL ischeck;
/** 订单编号 */
@property (nonatomic, strong) NSString *no;
/**  */
@property (nonatomic, strong) NSString *updatetime;
/** 收货人 */
@property (nonatomic, strong) NSString *customerName;
/** 收货地址 */
@property (nonatomic, strong) NSString *address;
/** 收货人联系方式 */
@property (nonatomic, strong) NSString *telephone;
/** 下单时间 */
@property (nonatomic, strong) NSString *createDateStr;
/** 支付方式 */
@property (nonatomic, assign) NSUInteger payMethod;

@end

@interface TXOrderLogisticContentModel : NSObject

/** 时间节点对应的物流信息 */
@property (nonatomic, strong) NSString *context;
/** 时间节点 */
@property (nonatomic, strong) NSString *time;

@end

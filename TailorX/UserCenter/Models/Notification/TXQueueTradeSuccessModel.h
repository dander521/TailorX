//
//  TXQueueTradeSuccessModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXQueueTradeSuccessModel : NSObject

/** 交易金额 */
@property (nonatomic, strong) NSString *amount;
/** 买方姓名 */
@property (nonatomic, strong) NSString *buyName;
/** 交易时间 */
@property (nonatomic, strong) NSString *tradeTime;
/** 卖方姓名 */
@property (nonatomic, strong) NSString *saleName;
/** 买方排号 */
@property (nonatomic, strong) NSString *sortNoBuy;
/** 卖方排号 */
@property (nonatomic, strong) NSString *sortNoSale;
/** 交易编号 */
@property (nonatomic, strong) NSString *tradeNo;

@end

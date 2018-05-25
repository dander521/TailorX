//
//  TXWalletParams.h
//  
//
//  Created by liuyanming on 2017/4/5.
//
//

#import <Foundation/Foundation.h>

@interface TXWalletParams : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;

//amount	string	是	充值金额
//rechargeMethod	int	否	充值方式（1:支付宝）
@property (nonatomic, assign) NSInteger rechargeMethod;
@property (nonatomic, strong) NSString *amount;

//022（余额明细）023（收益明细）
@property (copy, nonatomic) NSString *accountType;

+ (instancetype)param;

@end

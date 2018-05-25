//
//  TXQueueNoRequestParams.h
//  TailorX
//
//  Created by liuyanming on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXQueueNoRequestParams : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;

//saleStatus	int	否	出让状态，默认-1全部，0未出让，1出让中，2交易中
@property (nonatomic, assign) NSInteger saleStatus;

//rankId	string	是	排号主键ID
//amount	float	是	价格，取消出让时随便传一个值
//opType	int	是	操作类型：0出让，1取消出让

@property (nonatomic, copy) NSString *rankId;
@property (nonatomic, assign) float amount;
@property (nonatomic, assign) NSInteger opType;


//sellUserId	int	是	售卖排号者userId
//amount	float	是	交易金额
//accountType	int	是	支付类型（0：余额支付，3：支付宝支付）
//rankTradeId	int	是	支付的排号交易记录主键
//buyRankId	string	是	买方排号ID

@property (nonatomic, assign) NSInteger sellUserId;
@property (nonatomic, assign) NSInteger accountType;
@property (nonatomic, assign) NSInteger rankTradeId;

@property (nonatomic, strong) NSString *buyRankId;

+ (instancetype)param;

@end

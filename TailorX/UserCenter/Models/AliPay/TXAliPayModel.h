//
//  TXAliPay.h
//  TailorX
//
//  Created by RogerChen on 2017/4/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXAliPayModel : NSObject

/** 支付宝名称 */
@property (nonatomic, strong) NSString *alipay;
/** 支付宝真是姓名 */
@property (nonatomic, strong) NSString *alipayName;
/** 手机号绑定状态 */
@property (nonatomic, assign) NSInteger mobileBindStatus;
/** 支付宝绑定时间 */
@property (nonatomic, assign) NSInteger payBindDate;
/** 支付宝绑定状态 */
@property (nonatomic, assign) NSInteger payBindStatus;
/** 实名认证状态 */
@property (nonatomic, assign) NSInteger realAuthStatus;
/** 用户名 */
@property (nonatomic, strong) NSString *username;

@end

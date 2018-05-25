//
//  TXCustomSuccessInfoModel.h
//  TailorX
//
//  Created by Qian Shen on 7/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCustomSuccessInfoModel : NSObject

/** 订单号*/
@property (nonatomic, strong) NSString *appointmentNo;
/** 设计师名字*/
@property (nonatomic, strong) NSString *designerName;
/** 门店名字*/
@property (nonatomic, strong) NSString *storeName;
/** 定金*/
@property (nonatomic, strong) NSString *depositStr;
/** 时尚标签*/
@property (nonatomic, strong) NSString *tags;
/** 预约类型*/
@property (nonatomic, assign) BOOL customType; // 0 预约设计师 1 门店定制

@end

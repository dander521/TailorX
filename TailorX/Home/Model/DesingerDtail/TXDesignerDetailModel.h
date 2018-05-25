//
//  TXDesignerDetailModel.h
//  TailorX
//
//  Created by Qian Shen on 7/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXDesignerDetailModel : NSObject

/** 订单成交量(如果没有则返回-1)*/
@property (nonatomic, assign) NSInteger amount;
/** 评价数(如果没有评价数则返回-1)*/
@property (nonatomic, assign) NSInteger commentAmount;
/** 交易成功总金额(如果没有该字段值。则返回-1)*/
@property (nonatomic, strong) NSString *dealAmount;
/** 设计师ID*/
@property (nonatomic, assign) NSInteger ID;
/** 设计师描述*/
@property (nonatomic, strong) NSString *introduction;
/** 是否收藏了该设计师(1:已收藏 ，0:未收藏)*/
@property (nonatomic, assign) NSInteger isliked;
/** 设计师名*/
@property (nonatomic, strong) NSString *name;
/** 设计师电话*/
@property (nonatomic, strong) NSString *phone;
/** 设计师头像*/
@property (nonatomic, strong) NSString *photo;
/** 设计师星级*/
@property (nonatomic, assign) NSInteger score;
/** 设计师所属门店地址*/
@property (nonatomic, strong) NSString *storeAddress;
/** 门店电话*/
@property (nonatomic, strong) NSString *storePhone;
/** 设计师地址*/
@property (nonatomic, strong) NSString *designerAddress;
/** 效率(一天x件)如果没有该字段值，则返回-1*/
@property (nonatomic, assign) NSInteger max_design;
/** 设计师QQ*/
@property (nonatomic, strong) NSString *qq;
/** 设计师所属门店Id*/
@property (nonatomic, strong) NSString *storeId;
/** [设计师拥有的设计风格]*/
@property (nonatomic, strong) NSArray *styleArray;
/** 设计师微信号*/
@property (nonatomic, strong) NSString *weChat;
/** 设计师是否在工作中 (1:工作中，0:未工作中)*/
@property (nonatomic, assign) NSInteger work;
/** 店名*/
@property (nonatomic, strong) NSString *storeName;
/** 预约设计师的次数*/
@property (nonatomic, assign) NSInteger usedCount;

@end

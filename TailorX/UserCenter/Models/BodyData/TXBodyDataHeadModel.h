//
//  TXBodyDataHeadModel.h
//  TailorX
//
//  Created by Qian Shen on 5/7/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXBodyDataHeadModel : NSObject

/** 在最新更新时间*/
@property (nonatomic, strong) NSString *updateDate;
/** 设计师头像*/
@property (nonatomic, strong) NSString *designerPhoto;
/** 门店名称*/
@property (nonatomic, strong) NSString *storeName;
/** 设计师姓名*/
@property (nonatomic, strong) NSString *designerName;
/** 设计师ID*/
@property (nonatomic, assign) NSInteger designerId;

@end

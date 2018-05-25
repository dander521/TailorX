//
//  TXGetStoreDesignerListModel.h
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXGetStoreDesignerListModel : NSObject

/** 设计师ID*/
@property (nonatomic, assign) NSInteger designerId;
/** 设计师作品图*/
@property (nonatomic, strong) NSArray *designerProductions;
/** 设计师的专业*/
@property (nonatomic, strong) NSString *designerSpecialty;
/** 设计师名*/
@property (nonatomic, strong) NSString *name;
/** 设计师订单数*/
@property (nonatomic, assign) NSInteger orderCount;
/** photo*/
@property (nonatomic, strong) NSString *photo;
/** 设计师星级*/
@property (nonatomic, assign) NSInteger score;
/** work：是否工作中（ 0：未工作 1：工作中）*/
@property (nonatomic, assign) NSInteger work;
/** 设计师风格*/
@property (nonatomic, strong) NSString *goodStyle;

@end

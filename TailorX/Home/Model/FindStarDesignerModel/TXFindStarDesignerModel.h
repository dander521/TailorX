//
//  TXFindStarDesignerModel.h
//  TailorX
//
//  Created by Qian Shen on 1/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXDesignerProductionModel.h"

@interface TXFindStarDesignerModel : NSObject

/** 设计师ID*/
@property (nonatomic, assign) NSInteger designerId;
/** [{id:作品ID,productionImg:作品URL图片}]*/
@property (nonatomic, strong) NSArray *designerProductions;
/** 设计师名字*/
@property (nonatomic, strong) NSString *name;
/** 成交量*/
@property (nonatomic, assign) NSInteger orderCount;
/** 设计师头像*/
@property (nonatomic, strong) NSString *photo;
/** 设计师星级*/
@property (nonatomic, assign) NSInteger score;
/** [设计师风格]*/
@property (nonatomic, strong) NSArray *styleArray;

@property (nonatomic, strong) NSString *designerSpecialty;

@end

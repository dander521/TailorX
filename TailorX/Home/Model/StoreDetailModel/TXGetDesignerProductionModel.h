//
//  TXGetDesignerProductionModel.h
//  TailorX
//
//  Created by Qian Shen on 10/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXGetDesignerProductionModel : NSObject

/** 设计师作品URL*/
@property (nonatomic, strong) NSString *productionImg;
/** 设计师作品名字*/
@property (nonatomic, strong) NSString *productionName;
/** 设计师designerId*/
@property (nonatomic, assign) NSInteger designerId;

@end

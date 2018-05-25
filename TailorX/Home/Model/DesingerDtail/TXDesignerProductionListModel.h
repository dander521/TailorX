//
//  TXDesignerProductionListModel.h
//  TailorX
//
//  Created by Qian Shen on 7/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXDesignerProductionListModel : NSObject

/** 作品ID*/
@property (nonatomic, assign) NSInteger ID;
/** 作品图片URL*/
@property (nonatomic, strong) NSString *productionImg;

@end

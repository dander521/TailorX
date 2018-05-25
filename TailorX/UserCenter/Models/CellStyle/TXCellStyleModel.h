//
//  TXCellStyleModel.h
//  TailorX
//
//  Created by 温强 on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCellStyleModel : NSObject
@property (nonatomic, copy) NSString *cellType;
+ (NSMutableArray *)createCellModels:(NSArray *)cellTypes;
@end

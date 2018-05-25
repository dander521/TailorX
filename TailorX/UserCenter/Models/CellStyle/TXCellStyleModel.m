//
//  TXCellStyleModel.m
//  TailorX
//
//  Created by 温强 on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCellStyleModel.h"

@implementation TXCellStyleModel
+ (NSMutableArray *)createCellModels:(NSArray *)cellTypes {
    
    NSMutableArray *cellModels = [NSMutableArray arrayWithCapacity:cellTypes.count];
    for (int i = 0; i < cellTypes.count; i++) {
        NSMutableArray *ary = [NSMutableArray array];
        NSArray *rowAry = cellTypes[i];
        for (int j = 0 ; j < rowAry.count; j++ ) {
            TXCellStyleModel *cellStyleModel = [[TXCellStyleModel alloc] init];
            cellStyleModel.cellType = rowAry[j];
            [ary addObject:cellStyleModel];
        }
        [cellModels addObject:ary];
    }
    return [cellModels copy] ;
}
@end

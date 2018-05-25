//
//  TXGetStoreDesignerListModel.m
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXGetStoreDesignerListModel.h"
#import "TXGetDesignerProductionModel.h"

@implementation TXGetStoreDesignerListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"designerProductions":@"TXGetDesignerProductionModel"
             };
}

@end

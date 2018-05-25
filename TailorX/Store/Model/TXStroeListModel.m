//
//  TXstroeListModel.m
//  TailorX
//
//  Created by 温强 on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStroeListModel.h"

@implementation TXStroeListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID" : @"id",
             @"designerPhotoList" : @"newDesignerPhotoList"};
}

- (TXStoreDetailModel *)converListModelToDetailModel {
    TXStoreDetailModel *model = [TXStoreDetailModel new];
    model.isSameCity = self.isSameCity;
    model.ID = self.ID;
    model.address = self.address;
    model.name = self.name;
    model.workTime = self.workTime;
    return model;
}
@end

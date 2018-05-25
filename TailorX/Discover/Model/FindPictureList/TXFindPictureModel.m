//
//  TXFindPictureModel.m
//  TailorX
//
//  Created by Qian Shen on 21/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//


#import "TXFindPictureModel.h"

@implementation TXFindPictureModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data":@"TXFindPictureListModel"
             };
}



@end

@implementation TXFindPictureListModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id",
             @"desc": @"description"};
}

- (TXFindPictureDetailModel *)transformListModelToDetailModel {
    TXFindPictureDetailModel *detailModel = [TXFindPictureDetailModel new];
    
    detailModel.desc = [NSString isTextEmpty:self.desc] ? self.name : self.desc;
    detailModel.designerId = self.designerId;
    detailModel.designerName = self.designerName;
    detailModel.designerPhoto = self.designerPhoto;
    detailModel.favoriteCount = self.favoriteCount;
    detailModel.ID = self.ID;
    detailModel.imgUrl = self.imgUrl;
    detailModel.publishTime = self.publishTime;
    detailModel.shareCount = self.shareCount;
    detailModel.tagsCommon = self.tagsCommon;
    detailModel.designerIntroduction = self.designerIntroduction;
    detailModel.productionPictures = self.productionPictures;
    detailModel.height = self.height;
    detailModel.width = self.width;
    detailModel.favoriteDesigner = self.favoriteDesigner;
    detailModel.favorite = self.favorite;
    
    detailModel.tagName = self.tagName;
    detailModel.introduction = self.introduction;
    detailModel.designerProduction = self.designerProduction;
    
    detailModel.recommendDesignerWorkCount = self.recommendDesignerWorkCount;
    
    return detailModel;
}

- (void)setTagName:(NSString *)tagName {
    _tagName = tagName;
    if (![NSString isTextEmpty:tagName]) {
        self.tagsCommon = [tagName componentsSeparatedByString:@","];
    }
}

@end



//
//  TXFindPictureDetailModel.m
//  TailorX
//
//  Created by Qian Shen on 21/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFindPictureDetailModel.h"
#import "TXInfomationHeaderTabCell.h"

@implementation TXFindPictureDetailModel

MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id",
             @"desc": @"description"};
}

- (void)setIntroduction:(NSString *)introduction {
    _introduction = introduction;
    if (![NSString isTextEmpty:introduction]) {
        self.designerIntroduction = introduction;
    }
}

- (void)setTagName:(NSString *)tagName {
    _tagName = tagName;
    if (![NSString isTextEmpty:tagName]) {
        NSArray *arrayTags = [tagName componentsSeparatedByString:@","];
        NSMutableArray *temArray = [NSMutableArray new];
        for (NSString *tagName in arrayTags) {
            TagsCommonInfo *tagInfo = [TagsCommonInfo new];
            tagInfo.tagName = tagName;
            [temArray addObject:tagInfo];
        }
        self.tagsCommon = temArray;
    }
}

- (void)setDesignerProduction:(NSArray *)designerProduction {
    _designerProduction = designerProduction;
    if (designerProduction.count > 0) {
        self.productionPictures = [designerProduction componentsJoinedByString:@";"];
    }
}



@end

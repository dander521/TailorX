//
//  TXFindStoreListModel.m
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFindStoreListModel.h"

@implementation TXFindStoreListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id",
             @"nDesignerPhotoList" : @"newDesignerPhotoList"};
}

@end

//
//  TXStoreDetailModel.m
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStoreDetailModel.h"

@implementation TXStoreDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nDesignerPhotoList" : @"newDesignerPhotoList",
             @"ID":@"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"nDesignerPhotoList":@"",
             @"pictures" : @"TXPicturesModel"
             };
}

@end

@implementation TXPicturesModel : NSObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"
             };
}



@end

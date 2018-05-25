//
//  TXFavoriteChoiceModel.h
//  TailorX
//
//  Created by 温强 on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXFavoriteChoiceModel : NSObject

@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *descriptionStr;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger minPrice;
@property (nonatomic, assign) NSInteger maxPrice;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSString *informationNo;
@end

//coverUrl：图片地址； id：资讯ID；

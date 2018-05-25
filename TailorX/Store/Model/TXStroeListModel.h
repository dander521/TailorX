//
//  TXstroeListModel.h
//  TailorX
//
//  Created by 温强 on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXStoreDetailModel.h"

@interface TXStroeListModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * coverImage;
@property (nonatomic, assign) NSInteger designerCount;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray * designerPhotoList;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger status; //门店状态
/** <#description#> */
@property (nonatomic, assign) BOOL isSameCity;
@property (nonatomic, strong) NSString *workTime;
@property (nonatomic, assign) NSInteger totalOrderCount;

- (TXStoreDetailModel *)converListModelToDetailModel;

@end
//address:门店地址;coverImage:门店图片；designerCount：该门店设计师数量；id：门店Id；name:门店名 newDesignerPhotoList：门店最新设计师图片；score：门店的星级。

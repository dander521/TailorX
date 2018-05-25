//
//  TXFindStoreListModel.h
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXFindStoreListModel : NSObject

/** 门店地址*/
@property (nonatomic, strong) NSString *address;
/** 门店图片*/
@property (nonatomic, strong) NSString *coverImage;
/** 该门店设计师数量*/
@property (nonatomic, assign) NSInteger designerCount;
/** 门店Id*/
@property (nonatomic, assign) NSInteger ID;
/** 门店名*/
@property (nonatomic, strong) NSString *name;
/** 门店最新设计师图片*/
@property (nonatomic, strong) NSArray *nDesignerPhotoList;
/** 门店的星级*/
@property (nonatomic, assign) NSInteger score;
/** 门店的状态*/
@property (nonatomic, assign) NSInteger status;
/** 门店距离*/
@property (nonatomic, assign) NSInteger distance;

@end

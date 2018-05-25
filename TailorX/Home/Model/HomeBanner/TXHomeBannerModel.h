//
//  TXHomeBannerModel.h
//  TailorX
//
//  Created by Qian Shen on 1/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHomeBannerModel : NSObject

@property (nonatomic, strong) NSString *banner;
/** bannerID*/
@property (nonatomic, assign) NSInteger ID;
/** 设计师ID或者一个链接*/
@property (nonatomic, strong) NSString *input;
/** type: 0：（ 代表input传递的是一个链接） 1：（代表input传递的是设计师ID）*/
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSString *informationNo;

@end

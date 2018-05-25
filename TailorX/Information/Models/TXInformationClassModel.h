//
//  TXInformationClassModel.h
//  TailorX
//
//  Created by Qian Shen on 10/7/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXInformationClassModel : NSObject

/** 资讯图片路劲*/
@property (nonatomic, strong)NSString *infoPicUrl;
/** 资讯ID*/
@property (nonatomic, assign)NSInteger infoPicID;
/** 资讯ID*/
@property (nonatomic, strong) NSString *informationNo;
/** 发现ID*/
@property (nonatomic, strong) NSString *pictureID;
/** 标签*/
@property (nonatomic, strong) NSString *tags;

singleton_interface(TXInformationClassModel)

@end

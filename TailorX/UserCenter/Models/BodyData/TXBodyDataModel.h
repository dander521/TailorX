//
//  TXBodyDataModel.h
//  TailorX
//
//  Created by Qian Shen on 5/7/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXBodyDataModel : NSObject

/** 值*/
@property (nonatomic, strong) NSString *value;
/** 名称*/
@property (nonatomic, strong) NSString *labelName;

/***************** 参考图片使用 *****************/

/** 图片路径*/
@property (nonatomic, strong) NSString *pictureUrl;
/** 图片ID*/
@property (nonatomic, assign) NSInteger ID;
/** 图片类型*/
@property (nonatomic, assign) NSInteger type;
/** 图片*/
@property (nonatomic, strong) UIImage *image;
/** 是否上传成功*/
@property (nonatomic, assign) BOOL isLoadError;

@end

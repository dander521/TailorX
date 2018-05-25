//
//  TXRePictureTabCell.h
//  TailorX
//
//  Created by Qian Shen on 5/7/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBodyDataModel.h"
@class TXRePictureTabCell;

@protocol TXRePictureTabCellDelegate <NSObject>

/** 单击图片*/
- (void)rePictureTabCell:(TXRePictureTabCell*)rePictureTabCell clickImgViewOfIndex:(NSInteger)index;
/** 长按图片*/
- (void)rePictureTabCell:(TXRePictureTabCell*)rePictureTabCell longClickImgViewOfIndex:(NSInteger)index;
/** 失败时单击图片*/
- (void)rePictureTabCell:(TXRePictureTabCell*)rePictureTabCell clickErrorImgViewOfIndex:(NSInteger)index;

@end

@interface TXRePictureTabCell : UITableViewCell

/** 模型*/
@property (nonatomic, strong) NSArray<TXBodyDataModel*> *models;
/** 代理*/
@property (nonatomic, weak)  id<TXRePictureTabCellDelegate> delegate;

@end

//
//  TXDesignerHeaderCell.h
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXDesignerDetailModel.h"

@class TXDesignerHeaderCell;


@protocol TXDesignerHeaderCellDelegate <NSObject>

@optional

/**
 * 点击头像
 */
- (void)designerHeaderCell:(TXDesignerHeaderCell*)designerHeaderCell clickHeadImgBtn:(UIButton *)btn;

@end

@interface TXDesignerHeaderCell : UITableViewCell

/** 模型*/
@property (nonatomic, strong) TXDesignerDetailModel *model;

/** 代理*/
@property (nonatomic, weak) id<TXDesignerHeaderCellDelegate> delegate;

/** 简介的顶部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ttopConstraint;

/** 设计师头像*/
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;


@end

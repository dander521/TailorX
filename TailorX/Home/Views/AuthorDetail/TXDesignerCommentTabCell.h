//
//  TXDesignerCommentTabCell.h
//  TailorX
//
//  Created by Qian Shen on 20/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXDesignerCommentListModel.h"

@class TXDesignerCommentTabCell;

@protocol TXDesignerCommentTabCellDelegate <NSObject>

- (void)designerCommentTabCell:(TXDesignerCommentTabCell*)designerCommentTabCell didSelectOfSection:(NSInteger)section ofIndex:(NSInteger)index;

@end

@interface TXDesignerCommentTabCell : UITableViewCell

/** 模型数据*/
@property (nonatomic, strong) TXDesignerCommentListModel *model;

/** 图片在第几行*/
@property (nonatomic, assign) NSInteger section;

/** 底部分割线*/
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/** 图片数组*/
@property (nonatomic, strong) NSMutableArray *pictures;

/** 代理*/
@property (nonatomic, weak) id<TXDesignerCommentTabCellDelegate> delegate;

/** 评论内容*/
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *firstImageView;

@property (nonatomic, strong) UIImageView *secondImageView;

@property (nonatomic, strong) UIImageView *thirdImageView;


@end

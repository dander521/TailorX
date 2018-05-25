//
//  TXCommentDisplayTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCommentDetailModel.h"

@protocol TXCommentDisplayTableViewCellDelegate <NSObject>

- (void)tapDisplayImageViewWithIndex:(NSUInteger)index;

@end

@interface TXCommentDisplayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
/** 评论模型 */
@property (nonatomic, strong) TXCommentDetailModel *detailModel;
/** 代理 */
@property (nonatomic, assign) id <TXCommentDisplayTableViewCellDelegate> delegate;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

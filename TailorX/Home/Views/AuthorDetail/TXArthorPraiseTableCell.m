//
//  TXArthorPraiseTableCell.m
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXArthorPraiseTableCell.h"

@interface TXArthorPraiseTableCell ()

/** 评论人头像*/
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
/** 评论人名字*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 创建时间*/
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
/** 评论内容*/
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation TXArthorPraiseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(TXDesignerCommentListModel *)model {
    _model = model;
    
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:[NSString getStrUserPhoto:model.photo]] imageViewWidth:30 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    self.nameLabel.text = model.customerName;
    self.createDateLabel.text = model.createDate;
    self.contentLabel.text = model.content;
}

@end

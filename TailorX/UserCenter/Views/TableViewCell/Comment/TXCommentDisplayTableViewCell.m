//
//  TXCommentDisplayTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCommentDisplayTableViewCell.h"

@implementation TXCommentDisplayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXCommentDisplayTableViewCell";
    TXCommentDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)tapGestureRecognize:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(tapDisplayImageViewWithIndex:)]) {
        [self.delegate tapDisplayImageViewWithIndex:sender.view.tag];
    }
}

- (void)setDetailModel:(TXCommentDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.desLabel.text = detailModel.content;
    
    if (detailModel.pics.count == 0) {
        [self.firstImageView removeFromSuperview];
        [self.secondImageView removeFromSuperview];
        [self.thirdImageView removeFromSuperview];
    } else if (detailModel.pics.count == 1) {
        [self.secondImageView removeFromSuperview];
        [self.thirdImageView removeFromSuperview];
        
        [self.firstImageView sd_small_setImageWithURL:[NSURL URLWithString:detailModel.pics[0]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    } else if (detailModel.pics.count == 2) {
        [self.thirdImageView removeFromSuperview];
        
        [self.firstImageView sd_small_setImageWithURL:[NSURL URLWithString:detailModel.pics[0]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        [self.secondImageView sd_small_setImageWithURL:[NSURL URLWithString:detailModel.pics[1]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    } else {
        [self.firstImageView sd_small_setImageWithURL:[NSURL URLWithString:detailModel.pics[0]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        [self.secondImageView sd_small_setImageWithURL:[NSURL URLWithString:detailModel.pics[1]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        [self.thirdImageView sd_small_setImageWithURL:[NSURL URLWithString:detailModel.pics[2]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    }
}

@end

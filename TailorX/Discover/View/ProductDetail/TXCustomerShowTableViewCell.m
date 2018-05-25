//
//  TXCustomerShowTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCustomerShowTableViewCell.h"

@interface TXCustomerShowTableViewCell ()




@end

@implementation TXCustomerShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstImageView.layer.cornerRadius = 2.7;
    self.firstImageView.layer.masksToBounds = true;
    self.secondImageView.layer.cornerRadius = 2.7;
    self.secondImageView.layer.masksToBounds = true;
    self.thirdImageView.layer.cornerRadius = 2.7;
    self.thirdImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TXProductDetailModel *)model {
    _model = model;
    
    if (model.customerUpLoadPics.count == 1) {
        self.firstImageView.hidden = false;
        self.secondImageView.hidden = true;
        self.thirdImageView.hidden = true;
    } else if (model.customerUpLoadPics.count == 2) {
        self.firstImageView.hidden = false;
        self.secondImageView.hidden = false;
        self.thirdImageView.hidden = true;
        [self.secondImageView sd_small_setImageWithURL:[NSURL URLWithString:model.customerUpLoadPics[1]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    } else if (model.customerUpLoadPics.count == 3) {
        self.firstImageView.hidden = false;
        self.secondImageView.hidden = false;
        self.thirdImageView.hidden = false;
        [self.secondImageView sd_small_setImageWithURL:[NSURL URLWithString:model.customerUpLoadPics[1]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        [self.thirdImageView sd_small_setImageWithURL:[NSURL URLWithString:model.customerUpLoadPics.lastObject] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    }
    
    [self.firstImageView sd_small_setImageWithURL:[NSURL URLWithString:model.customerUpLoadPics.firstObject] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXCustomerShowTableViewCell";
    TXCustomerShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)tapImageView:(UITapGestureRecognizer *)sender {
    UIImageView *img = (UIImageView *)sender.view;
    if ([self.delegate respondsToSelector:@selector(tapImageViewWithIndex:photoArray:cell:)]) {
        [self.delegate tapImageViewWithIndex:img.tag-100 photoArray:self.model.customerUpLoadPics cell:self];
    }
}


@end

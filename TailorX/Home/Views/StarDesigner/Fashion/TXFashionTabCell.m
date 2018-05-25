//
//  TXFashionTabCell.m
//  TailorX
//
//  Created by Qian Shen on 15/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFashionTabCell.h"

@interface TXFashionTabCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImgHeightLayout;

@end

@implementation TXFashionTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.coverImgHeightLayout.constant = (SCREEN_WIDTH - 30)*0.55;
    [self layoutIfNeeded];

}

- (void)setModel:(TXTagGroupModel *)model {
    _model = model;
    [self.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:model.coverImg] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    self.nameLabel.text = [NSString isTextEmpty:model.name] ? @"" : model.name;
    self.descLabel.text = [NSString isTextEmpty:model.desc] ? @"" : model.desc;
}


@end

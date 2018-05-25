//
//  TXArthorInfoItemCell.m
//  TailorX
//
//  Created by Qian Shen on 30/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXArthorInfoItemCell.h"

@interface TXArthorInfoItemCell ()



@property (weak, nonatomic) IBOutlet UIButton *shadowView;

@end

@implementation TXArthorInfoItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.shadowView.layer.shadowOpacity = 0.3;
}


- (void)setModel:(TXDesignerProductionListModel *)model {
    _model = model;
    [self.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:model.productionImg] imageViewWidth:100 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
}

- (void)setPictureModel:(TXPicturesModel *)pictureModel {
    _pictureModel = pictureModel;
    [self.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:pictureModel.pictureUrl] imageViewWidth:100 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
}

@end

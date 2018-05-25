//
//  TXProductListCollectionViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductListCollectionViewCell.h"

@interface TXProductListCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation TXProductListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.productImageView.layer.cornerRadius = 4;
    self.productImageView.layer.masksToBounds = true;
    
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.shadowView.layer.shadowOpacity = 0.3;
    self.shadowView.layer.cornerRadius = 4;
}

- (void)setModel:(TXProductListModel *)model {
    _model = model;
    
    [self.productImageView sd_small_setImageWithURL:[NSURL URLWithString:model.workHeadPicture] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    self.desLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@", model.price];
}

@end

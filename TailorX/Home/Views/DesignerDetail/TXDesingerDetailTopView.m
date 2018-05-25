//
//  TXDesingerDetailTopView.m
//  TailorX
//
//  Created by Qian Shen on 30/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesingerDetailTopView.h"

@interface TXDesingerDetailTopView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftConstraint;

@end

@implementation TXDesingerDetailTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.shadowView.layer.shadowOpacity = 0.5;
    
    self.imageLeftConstraint.constant = [TXCustomTools customPopBarItemX] + 11;
    
    self.favoriteBtn = [[TXFavoriteButton alloc]init];
    
    [_favoriteBtn click:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(respondsToFavoriteBtn:)]) {
            [self.delegate respondsToFavoriteBtn:self.favoriteBtn];
        }
    }];
    [self.favoriteBtnBgView addSubview:self.favoriteBtn];
    [self.favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.favoriteBtnBgView.mas_top);
        make.left.mas_equalTo(self.favoriteBtnBgView.mas_left);
        make.bottom.mas_equalTo(self.favoriteBtnBgView.mas_bottom);
        make.right.mas_equalTo(self.favoriteBtnBgView.mas_right);
    }];
}

@end

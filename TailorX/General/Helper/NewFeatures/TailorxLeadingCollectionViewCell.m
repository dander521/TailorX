//
//  TailorxLeadingCollectionViewCell.m
//  Tailorx
//
//  Created by 高习泰 on 16/8/24.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "TailorxLeadingCollectionViewCell.h"

@implementation TailorxLeadingCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.leadingImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.leadingImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.leadingImageView];

        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = self.contentView.bounds;
        [self.contentView addSubview:touchBtn];
        
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btn];
        _btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [_btn setTitle:@"立即体验" forState:UIControlStateNormal];
        [_btn setBackgroundColor:RGB(46, 46, 46)];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _btn.layer.cornerRadius = 5;
        _btn.layer.masksToBounds = true;
        
        if (SCREEN_WIDTH > 320) {
            [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(LayoutW(25));
                make.bottom.mas_equalTo(LayoutH(-90));
                make.size.mas_equalTo(CGSizeMake(LayoutW(150), LayoutH(44)));
            }];
        } else {
            [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(LayoutW(25));
                make.bottom.mas_equalTo(LayoutH(-70));
                make.size.mas_equalTo(CGSizeMake(LayoutW(150), LayoutH(44)));
            }];
        }
    }
    return self;
}
@end

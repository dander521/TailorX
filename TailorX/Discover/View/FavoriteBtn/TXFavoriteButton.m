//
//  TXFavoriteButton.m
//  TailorX
//
//  Created by Qian Shen on 13/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFavoriteButton.h"

#define collectionImg [UIImage imageNamed:@"ic_nav_press_collection_3.2.1"]
#define notCollectionImg [UIImage imageNamed:@"ic_nav_default_collection_3.2.1"]

@interface TXFavoriteButton ()

/** 背景扩散视图*/
@property (nonatomic, strong) UIImageView *shapeImgView;
/** 收藏按钮*/
@property (nonatomic, strong) UIButton *favoriteBtn;


@end

@implementation TXFavoriteButton

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.shapeImgView];
        [self addSubview:self.favoriteBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.shapeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
}

#pragma mark - methods


- (void)showAnimation {
    [self.favoriteBtn setImage:collectionImg forState:UIControlStateNormal];
    self.shapeImgView.hidden = NO;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.favoriteBtn.layer addAnimation:animation forKey:nil];
    CAKeyframeAnimation* imgAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    imgAnimation.duration = 0.45;
    NSMutableArray *imfValues = [NSMutableArray array];
    [imfValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [imfValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.1, 2.1, 1.0)]];
    [imfValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [imfValues addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    imgAnimation.values = imfValues;
    [self.favoriteBtn.layer addAnimation:animation forKey:nil];
    [self.shapeImgView.layer addAnimation:imgAnimation forKey:nil];
}

- (void)dismissAnimation {
    self.shapeImgView.hidden = YES;
    [self.favoriteBtn setImage:notCollectionImg forState:UIControlStateNormal];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.favoriteBtn.layer addAnimation:animation forKey:nil];
}

- (void)click:(clickBlock)block {
    self.block = block;
}

#pragma mark - events

- (void)clickFavoriteBtn:(UIButton*)sender {
    if (self.block) {
        self.block();
    }
}

#pragma mark - setters

- (void)setNormalImg:(UIImage *)normalImg {
    _normalImg = normalImg;
    [self.favoriteBtn setImage:normalImg forState:UIControlStateNormal];
}
#pragma mark - getters

- (UIImageView *)shapeImgView {
    if (!_shapeImgView) {
        _shapeImgView = [[UIImageView alloc]initWithImage:collectionImg];
        _shapeImgView.alpha = 0.1;
        _shapeImgView.hidden = YES;
    }
    return _shapeImgView;
}

- (UIButton *)favoriteBtn {
    if (!_favoriteBtn) {
        _favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favoriteBtn addTarget:self action:@selector(clickFavoriteBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _favoriteBtn;
}

@end

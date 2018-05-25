//
//  FKActionSheetItme.m
//  5KM
//
//  Created by haozhiyu on 2017/4/23.
//  Copyright © 2017年 UTSoft. All rights reserved.
//

#import "FKActionSheetItme.h"

@interface FKActionSheetItme ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation FKActionSheetItme

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews {
    self.contentView.clipsToBounds = NO;
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeTop;
    [self.contentView addSubview:self.imageView];
    
    self.titleLable = [UILabel new];
    [self.contentView addSubview:self.titleLable];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.image) {
        self.imageView.hidden = NO;
        self.imageView.image = self.image;
    } else {
        self.imageView.hidden = YES;
    }
    
    if (self.title.length > 0) {
        self.titleLable.hidden = NO;
        self.titleLable.text = self.title;
    } else {
        self.titleLable.hidden = YES;
    }
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

@end

//
//  ThemeImageView.m
//  Tailorx
//
//  Created by   徐安超 on 16/8/19.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        [self setupConfig];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupConfig];
}

-(void)setImgName:(NSString *)imgName{
    if (_imgName != imgName) {
        _imgName = [imgName copy];
        [self themeChangeAction];
    }
}

-(void)setupConfig{
    self.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNotifation object:nil];
}

-(void)themeChangeAction{
    UIImage *img = [[ThemeManager shareManager]loadThemeImageWithName:_imgName];
    self.image = [img resizableImageWithCapInsets:self.edgeInset resizingMode:UIImageResizingModeStretch];
}

@end

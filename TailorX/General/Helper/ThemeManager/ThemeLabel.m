//
//  ThemeLabel.m
//  Tailorx
//
//  Created by   徐安超 on 16/8/19.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

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

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupConfig];
}

-(void)setCloName:(NSString *)cloName{
    if (_cloName != cloName) {
        _cloName = [cloName copy];
        [self themeChangeAction];
    }
}

-(void)setupConfig{
//    self.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNotifation object:nil];
}

-(void)themeChangeAction{
    self.textColor = [[ThemeManager shareManager]loadThemeColorWithName:_cloName];
}


@end

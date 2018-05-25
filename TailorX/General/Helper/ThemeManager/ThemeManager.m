//
//  ThemeManager.m
//  ThemeManager
//
//  Created by   徐安超 on 16/8/18.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "ThemeManager.h"

#define kDefaultThemeName   @"red"

#define kThemeNameKey   @"kThemeNameKey"

@implementation ThemeManager{
    NSString *boxPath;
}

+(instancetype)shareManager{
    static ThemeManager *instance = nil;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        instance = [[ThemeManager alloc]init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.theDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSLog(@"filePath----%@",filePath);
        //NSUserDefaults存储主题的名字
        NSString *themeName = [[NSUserDefaults standardUserDefaults]objectForKey:kThemeNameKey];
        if (themeName) {
            self.theName = themeName;
        }else{
            self.theName = kDefaultThemeName;
        }
    }
    return self;
}

//主题所在文件夹的全路径
-(NSString *)themePath{
    NSString *rootPath = [[NSBundle mainBundle]resourcePath];
    NSString *themePath = _theDic[_theName];
    NSString *path = [rootPath stringByAppendingPathComponent:themePath];
    return path;
}

-(void)setTheName:(NSString *)theName{
    if (_theName != theName) {
        _theName = [theName copy];
        // 红色主题 兼容版本
        _theName = @"red";
        NSString *fontFilePath = [[self themePath] stringByAppendingPathComponent:@"config.plist"];
        self.fontColorDic = [NSDictionary dictionaryWithContentsOfFile:fontFilePath];
    }
}

-(UIImage *)loadThemeImageWithName:(NSString *)imgName{
    NSString *imgPath = [[self themePath] stringByAppendingPathComponent:imgName];
    return [UIImage imageWithContentsOfFile:imgPath];
}

-(UIColor *)loadThemeColorWithName:(NSString *)colorName{
    NSDictionary *rbgDic = _fontColorDic[colorName];
    if (rbgDic.count < 3) {
        return nil;
    }
    CGFloat red = [rbgDic[@"R"] floatValue];
    CGFloat green = [rbgDic[@"G"] floatValue];
    CGFloat blue = [rbgDic[@"B"] floatValue];
    NSNumber *alpheNum = rbgDic[@"A"];
    CGFloat alpha = alpheNum ? [alpheNum floatValue] : 1;
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
}

- (NSDictionary *)loadRGBValueFromThemeColorWithName:(NSString *)colorName {
    NSDictionary *rgbDic = _fontColorDic[colorName];
    return rgbDic;
}

-(UIImage *)loadThemeImageWithThemeName:(NSString *)imgName{
    NSString *themePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:_theDic[imgName]];
    NSString *filePath = [themePath stringByAppendingPathComponent:@"more_icon_theme.png"];
    return [UIImage imageWithContentsOfFile:filePath];
}

-(void)saveTheme{
    [[NSUserDefaults standardUserDefaults] setObject:self.theName forKey:kThemeNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

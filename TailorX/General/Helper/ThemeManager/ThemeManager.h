//
//  ThemeManager.h
//  ThemeManager
//
//  Created by   徐安超 on 16/8/18.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kThemeDidChangeNotifation   @"kThemeDidChangeNotifation"


@interface ThemeManager : NSObject

//当前主题的名字
@property(nonatomic, copy)NSString *theName;

//当前主题的字典,主题名字对应的主题路径
@property(nonatomic, copy)NSDictionary *theDic;

//主题的颜色
@property(nonatomic, copy)NSDictionary *fontColorDic;

+(instancetype)shareManager;

- (UIImage *)loadThemeImageWithName:(NSString *)imgName;

- (UIColor *)loadThemeColorWithName:(NSString *)colorName;

- (UIImage *)loadThemeImageWithThemeName:(NSString *)imgName;

- (NSDictionary *)loadRGBValueFromThemeColorWithName:(NSString *)colorName;

- (void)saveTheme;

@end

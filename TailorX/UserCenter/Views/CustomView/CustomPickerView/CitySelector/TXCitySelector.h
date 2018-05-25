//
//  TXCitySelector.h
//  TailorX
//
//  Created by RogerChen on 2017/4/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXCitySelectorDelegate <NSObject>


/**
 点击确定按钮

 @param param
 */
- (void)touchCitySelectorButtonWithDictionary:(NSDictionary *)param;

@end

@interface TXCitySelector : UIWindow

/** 代理 */
@property (nonatomic, assign) id <TXCitySelectorDelegate> delegate;

+ (TXCitySelector *)shareManager;

/**
 显示选择器
 */
- (void)showCitySelector;

/**
 隐藏选择器
 */
- (void)hideCitySelector;

@end

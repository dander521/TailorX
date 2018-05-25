//
//  AppDelegate+tabBar.h
//  TailorX
//
//  Created by liuyanming on 2017/4/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (tabBar) <UITabBarControllerDelegate>


/**
 监听tabBar点击 处理点击排号跳转登录
 */
- (void)setTabBarSelectedDelegate;

@end

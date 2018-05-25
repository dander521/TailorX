//
//  AppDelegate+tabBar.m
//  TailorX
//
//  Created by liuyanming on 2017/4/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "AppDelegate+tabBar.h"

@implementation AppDelegate (tabBar)


- (void)setTabBarSelectedDelegate {
    
//    self.tabBarVc.delegate = self;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNSNotificationLoginSuccess object:nil];
}

- (void)loginSuccess {
    self.tabBarVc.selectedViewController = [self.tabBarVc.viewControllers objectAtIndex:self.tabBarSelectedIndex];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController  {
    
    self.tabBarSelectedIndex = tabBarController.selectedIndex;
    
    if ([viewController.tabBarItem.title isEqualToString:@"排号"]){
        self.tabBarSelectedIndex = 2;

        if ([GetUserInfo.isLogin integerValue] != 1) {
            [TXServiceUtil LoginController:tabBarController.selectedViewController];
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.tabBarSelectedIndex = tabBarController.selectedIndex;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

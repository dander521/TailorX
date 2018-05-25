//
//  ScrollTabBarDelegate.m
//  ScrollTabBar
//
//  Created by QiuQiu on 16/8/14.
//  Copyright © 2016年 Qiu. All rights reserved.
//

#import "ScrollTabBarDelegate.h"
#import "ScrollTabBarAnimator.h"
#import "AppDelegate.h"

@interface ScrollTabBarDelegate ()

@property (nonatomic, strong) ScrollTabBarAnimator *tabBarAnimator;

@end

@implementation ScrollTabBarDelegate

- (instancetype)init {
    if (self = [super init]) {
        _interactive = NO;
        _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
        _tabBarAnimator = [[ScrollTabBarAnimator alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNSNotificationLoginSuccess object:nil];

    }
    return self;
}

- (void)loginSuccess {
    [AppDelegate sharedAppDelegate].tabBarVc.selectedViewController = [[AppDelegate sharedAppDelegate].tabBarVc.viewControllers objectAtIndex:[AppDelegate sharedAppDelegate].tabBarSelectedIndex];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactive ? self.interactionController : nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC {
    
    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    self.tabBarAnimator.tabScrollDirection = (toIndex < fromIndex) ? TabLeftDirection: TabRightDirection;
    return self.tabBarAnimator;

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController  {
    
    [AppDelegate sharedAppDelegate].tabBarSelectedIndex = tabBarController.selectedIndex;
    
    if ([viewController.tabBarItem.title isEqualToString:@"排号"]){
        [AppDelegate sharedAppDelegate].tabBarSelectedIndex = 2;
        
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
    [AppDelegate sharedAppDelegate].tabBarSelectedIndex = tabBarController.selectedIndex;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

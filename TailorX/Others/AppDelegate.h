//
//  AppDelegate.h
//  TailorX
//
//  Created by Roger on 17/3/14.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTabBarController.h"
#import "TXNavigationViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**tabBar*/
@property(nonatomic ,strong) TXTabBarController *tabBarVc;
@property (nonatomic, assign) NSInteger tabBarSelectedIndex;

/**
 *  实例对象
 */
+ (instancetype)sharedAppDelegate;

@end


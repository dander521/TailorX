//
//  AppDelegate+HelpDesk.h
//  TailorX
//
//  Created by Qian Shen on 2/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HelpDesk)<HChatDelegate>

- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)resetCustomerServiceSDK;

- (void)showNotificationWithMessage:(NSArray *)messages;

@end

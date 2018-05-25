

//
//  AppDelegate+HelpDesk.m
//  TailorX
//
//  Created by Qian Shen on 2/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "AppDelegate+HelpDesk.h"

@implementation AppDelegate (HelpDesk)

- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化环信客服sdk
    [self initializeCustomerServiceSdk];
    
    // 注册环信监听
    [self setupNotifiers];
}

/**
 * 修改关联app后需要重新初始化
 */
- (void)resetCustomerServiceSDK {
    //如果在登录状态,账号要退出
    HChatClient *client = [HChatClient sharedClient];
    if (client.isLoggedInBefore) {
        HError *error = [client logout:YES];
        if (error) {
            NSLog(@"error.code:%u,error.errorDescription :%@",error.code,error.errorDescription);
        } else {
            exit(0);
        }
    } else {
        exit(0);
    }
}

/**
 * 初始化客服sdk
 */
- (void)initializeCustomerServiceSdk {
    //注册kefu_sdk
    HOptions *option = [[HOptions alloc] init];
    option.appkey = KF_AppKey;
    option.tenantId = KF_TenantId;
#if TX_Environment == 0
    option.enableConsoleLog = NO;
#else
    option.enableConsoleLog = YES;
#endif
    option.apnsCertName = KF_ApnsCertName;
    NSLog(@"appkey = %@ tenantId = %@ apnsCertName %@",KF_AppKey,KF_TenantId,KF_ApnsCertName);
    HChatClient *client = [HChatClient sharedClient];
    HError *initError = [client initializeSDKWithOptions:option];
    if (initError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重要提示[初始化错误]" message:initError.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"环信初始化失败");
    }else {
        NSLog(@"环信初始化成功");
    }
}

#pragma mark - HChatDelegate

-(void)messagesDidReceive:(NSArray *)aMessages {
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self showNotificationWithMessage:aMessages];
    }
    NSLog(@"-------------------------------------------------------------");
    // 新消息提醒
    [[NSNotificationCenter defaultCenter]postNotificationName:kNSNotificationFindNewServiceMessage object:@(1)];
    SaveUserInfo(isUnreadMessages, YES);
}

- (void)showNotificationWithMessage:(NSArray *)messages
{
    HPushOptions *options = [[HChatClient sharedClient] hPushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == HPushDisplayStyleMessageSummary) {
        id<HDIMessageModel> messageModel  = messages.firstObject;
        NSString *messageStr = nil;
        switch (messageModel.body.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageModel.body).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = @"你收到一张图片";
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = @"你收到一条定位信息";
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = @"你收到一条语音";
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = @"你收到一段视频";
            }
                break;
            default:
                break;
        }
        
        NSString *title = messageModel.from;
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = ++badge;
}



/**
 * 监听系统生命周期回调，以便将需要的事件传给SDK
 */
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers

- (void)appDidEnterBackgroundNotif:(NSNotification*)notif {
    [[HChatClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[HChatClient sharedClient] applicationWillEnterForeground:notif.object];
    
}

- (void)appDidFinishLaunching:(NSNotification*)notif {
    // [[HChatClient sharedClient] applicationdidfinishLounching];
    // [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif {
    // [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif {
    // [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif {
    // [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif {
    // [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif {
    
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif {
    
}




@end

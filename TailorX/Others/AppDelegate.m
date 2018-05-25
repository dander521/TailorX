//
//  AppDelegate.m
//  TailorX
//
//  Created by Roger on 17/3/14.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "AppDelegate.h"
#import "GXTCrashTool.h"
#import "TXUserCenterViewController.h"
#import "ReachabilityUtil.h"
#import "IQKeyboardManager.h"
#import "TXQueueNoViewController.h"
#import "AppDelegate+tabBar.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "TXScrollLeadingViewController.h"
#import "TXVersionUpdater.h"
#import "AppDelegate+HelpDesk.h"
#import "WXApi.h"
#import "UMMobClick/MobClick.h"
#import "TailorxLeadingViewController.h"

/** 10.0注册通知*/
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate,UtouuOauthDelegate,WXApiDelegate>
/** iOS10通知中心 */
@property (strong, nonatomic) UNUserNotificationCenter *notificationCenter;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setUpRideMenu];
    [self.window makeKeyAndVisible];
    
    [[UITextField appearance] setTintColor:RGB(46, 46, 46)];
    
#if TX_Environment != 0
    // 非生产环境 处理异常
    InstallUncaughtExceptionHandler();
#endif
    // 友盟
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57c3aad267e58efafb001c24"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105626248"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://www.utouu.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd29cb50b233e5cdd" appSecret:@"1e810e82ea21dda527e06e0792b8854e" redirectURL:@"http://www.utouu.com"];
    
    // 日志分析
    UMConfigInstance.appKey = @"5a0111a7aed1790af1000119";
    UMConfigInstance.channelId = @"App Store";
    [MobClick setCrashReportEnabled:true];
#if TX_Environment != 0
    [MobClick setLogEnabled:YES];
#endif
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    // 向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:WX_PAY_AppId];
    // 网络监听
    [ReachabilityUtil getCurrentAFNetworkingState];
    // 监听键盘
    [self iqKeyboardShowOrHide];
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    // 监听推送消息到达
    [self registerMessageReceive];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    [CloudPushSDK sendNotificationAck:launchOptions];
    // 处理点击排号跳转登录界面
    [self setTabBarSelectedDelegate];
    
    [UtouuOauth initWithAppID:TX_utouuAppId appKey:TX_utouuAppKey redirentUrl:strUtouuAPI delegate:self environmentType:[self getEnvironmentType:TX_Environment]];
    
    // 检测版本
    [TXVersionUpdater checkAppVersion];
    
    // 初始化环信
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    // 异步 注册及登录环信用户
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [TXKfLoginManager loginKefuSDKcomplete:^(bool success) {
            SaveUserInfo(hxLoginStatus, success);
        }];
    });
    
    [[HChatClient sharedClient].chat removeDelegate:self];
    [[HChatClient sharedClient].chat addDelegate:self];
    
    [AMapServices sharedServices].apiKey = @"762e141006b92ff1a317a1ab9be898db";
    
    return YES;
}

#pragma mark - APNs Register

/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        self.notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        // 创建category，并注册到通知中心
        self.notificationCenter.delegate = self;
        // 请求推送权限
        [self.notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) { //用户点击允许
                NSLog(@"注册成功");
                // 向APNs注册，获取deviceToken
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications]; 
                });
            } else {
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];
        
        [self.notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
        
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
    
}

/**
 *  主动获取设备通知是否授权(iOS 10+)
 */
- (void)getNotificationSettingStatus {
    [self.notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            NSLog(@"User authed.");
        } else {
            NSLog(@"User denied.");
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate
/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知，并上报通知打开回执
    [self handleiOS10Notification:notification];
    // 通知不弹出
    //    completionHandler(UNNotificationPresentationOptionNone);
    
    // 通知弹出，且带有声音、内容和角标
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}


/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        NSLog(@"%@----",response.notification);
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
    }
    completionHandler();
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}

/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Receive one notification.----%@",userInfo);
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    [TXNetRequest findUserUnreadMsgCount];
}


#pragma mark -  UtouuOauthDelegate

- (void)initUtouuOauthSDK:(NSDictionary *)resultDic {
    NSLog(@"--初始化SDK回调%@--",resultDic);
}
// 取消登录
- (void)cancleLogin {
    NSLog(@"---取消登录--");
}
// 开始登录
- (void)startLogin {
    NSLog(@"---开始登录--");
}
// 登录失败
- (void)loginFailWithFailedDic:(NSDictionary *)resultDic {
    NSLog(@"---登录失败--%@",resultDic);
    NSLog(@"-----%@",resultDic[@"msg"]);
}
// 登录成功
- (void)loginSuccessWithSuccessDic:(NSDictionary *)resultDic {
    NSLog(@"---登录成功--%@",resultDic);
}

#pragma mark - CloudPushSDK
// SDK初始化
- (void)initCloudPush {
    [CloudPushSDK asyncInit:pushKey appSecret:pushSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            [TXModelAchivar updateUserModelWithKey:@"deviceID" value:[CloudPushSDK getDeviceId]];
            NSLog(@"Push SDK init success, deviceId====================== %@", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

/**
 *	注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}

/**
 *	推送通道打开回调
 *
 *	@param 	notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"消息通道建立成功");
}

/**
 *	@brief	注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

/**
 *	处理到来推送消息
 *
 *	@param 	notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    NSLog(@"Receive one message!");
    
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
    [TXNetRequest findUserUnreadMsgCount];
}

#pragma mark - UIApplicationDelegate
/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken===============%@",[CloudPushSDK getApnsDeviceToken]);
            [TXModelAchivar updateUserModelWithKey:@"deviceToken" value:[CloudPushSDK getApnsDeviceToken]];
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //环信推送
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
        
        NSLog(@"环信推送deviceToken:%@",deviceToken);
    });
}

/*
 *  苹果推送注册失败回调 
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 检测版本
    [TXVersionUpdater checkAppVersion];
    if ([[TXModelAchivar getUserModel] userLoginStatus]) {
        [TXNetRequest findUserUnreadMsgCount];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kNSNotificationRefreshHomeBanner object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

// 接收到内存警告的时候调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // 停止所有的下载
    [[EMSDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[EMSDWebImageManager sharedManager].imageCache clearMemory];
}

// NOTE: 4.2-9.0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"url.scheme = %@",url.scheme);
    BOOL result = false;
    if ([url.scheme hasPrefix:WX_PAY_AppId]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else{
        result = [[UMSocialManager defaultManager] handleOpenURL:url];
        if (result == FALSE) {
            if ([url.host isEqualToString:@"safepay"]) {
                // 支付跳转支付宝钱包进行支付，处理支付结果
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    NSLog(@"result = %@",resultDic);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationAliPaySuccess object:nil userInfo:resultDic];
                }];
            } else if ([url.host isEqualToString:@"we"]) {
                
            }
            return YES;
        }
    }
    
    return result;
}

// NOTE: 9.0以后使用新API接口
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"url.scheme = %@",url.scheme);
    BOOL result = false;
    if ([url.scheme hasPrefix:WX_PAY_AppId]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        result = [[UMSocialManager defaultManager] handleOpenURL:url];
        
        if (result == FALSE) {
            if ([url.host isEqualToString:@"safepay"]) {
                // 支付跳转支付宝钱包进行支付，处理支付结果
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    NSLog(@"result = %@",resultDic);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationAliPaySuccess object:nil userInfo:resultDic];
                }];
            }
            
            return YES;
        }
    }
    return result;
}
#endif

#pragma mark - Custom Method

/**
 *  实例对象
 */
+ (instancetype)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

/**
 * 初始化边菜单
 */
- (void)setUpRideMenu {
    
    self.tabBarVc = [[TXTabBarController alloc] init];
    
    // 获取版本号
    NSString *currenVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:APP_version];
    // 获取上一次的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:APP_version];
    
    TailorxLeadingViewController *vwcScroll = [[TailorxLeadingViewController alloc] init];
    vwcScroll.tabBarController = self.tabBarVc;
    self.window.rootViewController = vwcScroll;
    
    
    if ([currenVersion isEqualToString:lastVersion]) {
        self.window.rootViewController = self.tabBarVc;
    }else {
        self.window.rootViewController = vwcScroll;
        // 保存版本信息  判断是不是新版本来展示欢迎界面
        [[NSUserDefaults standardUserDefaults] setObject:currenVersion forKey:APP_version];
    }
}

#pragma mark - IQKeyboard

- (void)iqKeyboardShowOrHide {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (NSInteger)getEnvironmentType:(NSInteger)type {
    switch (type) {
        case 0:
            return 0;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            return 10;// 不可能出现的
            break;
    }
}

#pragma mark - WXApiDelegate

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void)onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationWXPaySuccess object:nil userInfo:nil];
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationWXPayFail object:nil userInfo:nil];
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationWXPayFail object:nil userInfo:nil];
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationWXPayFail object:nil userInfo:nil];
                break;
        }
    }
    NSLog(@"payResoult = %@", payResoult);
}


@end

//
//  TXServiceUtil.m
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXServiceUtil.h"
#import "TXMyMD5.h"
#import "TXLoginController.h"
#import "AppDelegate.h"

@implementation TXServiceUtil

/**
 * 获取ST
 */
+ (void) getSTbyTGT:(NSString*)tgt url:(NSString*)url success:(void (^)(AFHTTPSessionManager *operation, id responseObject))success failure:(void (^)(AFHTTPSessionManager *operation, NSError *error))failure{
    
    NSString *strUrl = [strPassport stringByAppendingString:strst];
    NSString *postUrl = [NSString stringWithFormat:@"%@/%@", strUrl, tgt];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:url,@"service", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *headDic = [self getSTHeadDictionary:dic strurl:postUrl];
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [manager POST:postUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *stStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *stDict = [NSDictionary dictionaryWithObjectsAndKeys:stStr, @"st", nil];
        SaveUserInfo(st, stStr);
        success(manager, stDict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(manager, error);
    }];
    
}

/**
 * 获取头部参数
 */
+(NSMutableDictionary *)getSTHeadDictionary:(NSDictionary *)dic_params strurl:(NSString*)url{
    @try {
        NSString *st = @"UTOUU-ST-INVALID";
        if ([NSString isTextEmpty:GetUserInfo.st]) {
            st = @"UTOUU-ST-INVALID";
        }else{
            st = GetUserInfo.st;
        }
        //时间
        NSString *time = [TXMyMD5 getSystemTime];
        //生成sign
        NSString *strSign = [TXMyMD5 md5:dic_params time:time];
        NSString *sign = strSign;
        NSMutableDictionary *head_dic = [[NSMutableDictionary alloc] initWithCapacity:5];
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
        if (appName == nil) {
            appName =@"";
        }
        NSString *deviceModel = [[UIDevice currentDevice] model];
        NSString *deviceSys = [[UIDevice currentDevice] systemVersion];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        NSString *user_agent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)",@"UTOUU",[TXCommon getAppVersion],deviceModel,deviceSys,screenScale];
        [head_dic setObject:sign forKey:@"cas-client-sign"];
        [head_dic setObject:time forKey:@"cas-client-time"];
        [head_dic setObject:strUtouuAPI forKey: @"cas-client-service"];//@"http://app.utouu"
        [head_dic setObject:st forKey:  @"cas-client-st"];
        [head_dic setObject:user_agent forKey:@"User-Agent"];
        [head_dic setObject:[TXCommon getAppVersion] forKey:@"app-version"];
        //cas-client-user
        return head_dic;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}


/**
 跳转到登录页面

 @param target 推送控制器，要求推送控制带导航条
 */
+ (BOOL)LoginController:(TXNavigationViewController *)target {
    if ([GetUserInfo.isLogin isEqualToString:@"1"]) {
        return true;
    }
    /*
    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"你还没有登录哦！确认登录？" actionsMsg:@[@"确认",@"取消"] buttonActions:^(NSInteger index) {
        if (index == 0) {
            
        }
    } target:target];
     */
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [target.view.layer addAnimation:transition forKey:nil];
    [target pushViewController:[TXLoginController new] animated:NO];
    return false;
}

/**
 退出登录
 */
+ (void)logout {

    TXUserModel *model = [TXUserModel defaultUser];
    // 记录上次登录的用户
    model.lastLoginAccount = model.accountA;
    [model resetModelData];
    [TXModelAchivar achiveUserModel];
    // 环信退出
    [[HChatClient sharedClient] logout:YES];
}

/**
 强行跳转到登录页面
 
 @param target 推送控制器，要求推送控制带导航条
 */

+ (void)loginViewControllerWithTarget:(UINavigationController*)target {
    if (target) {
        //[target pushViewController:[TXLoginController new] animated:YES];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [target.view.layer addAnimation:transition forKey:nil];
        [target pushViewController:[TXLoginController new] animated:NO];
    }
}

@end

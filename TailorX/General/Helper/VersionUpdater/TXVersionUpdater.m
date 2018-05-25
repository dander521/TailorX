//
//  TXVersionUpdater.m
//  TailorX
//
//  Created by 温强 on 2017/4/18.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXVersionUpdater.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
// TX appID
static NSString * appID = @"1154348037";

@implementation TXVersionUpdater

/**
 检测app版本
 */
+(void)checkAppVersion {
    
    // 设备Id
    NSString *deviceId = [TXCommon getDeviceUUId];
    
    NSLog(@"__________deviceId = %@",deviceId);
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 向appStore 请求版本信息
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析
        NSArray *arr = [responseObject objectForKey:@"results"];
        NSDictionary *dic = [arr firstObject];
        NSString *versionStr = [dic objectForKey:@"version"];        // 版本号
        // https://itunes.apple.com/cn/app/tailorx/id1154348037?mt=8&uo=4
        NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"]; // 下载地址
        //NSString *releaseNotes = [dic objectForKey:@"releaseNotes"];//更新日志

        NSURL *url = [NSURL URLWithString:trackViewUrl];
        
        if (versionStr == nil || versionStr.length == 0) {
            
        }
        // 本地版本号
        NSString* currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
       
        // 本地版本号低于appStore
        if ([currentVersion compare:versionStr] == NSOrderedAscending) {
            // deviceType  设备类型
            // version     当前版本号
            // deviceId    设备id
            NSDictionary *params = @{@"deviceType" : @"ios",
                                     @"version" : currentVersion,
                                     @"deviceId" : deviceId};
            // 向服务器请求版本信息
            [TXNetRequest userCenterRequestMethodWithParams:params relativeUrl:checkAppUpdate success:^(id responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    NSDictionary *infoDic = responseObject[@"data"];
                    NSString *upgradeMsg = [NSString isTextEmpty:infoDic[@"upgrade_msg"]] ? @"由于系统升级，您的版本已经停止服务，请及时更新到最新版本!" : infoDic[@"upgrade_msg"];
                    // 需要更新
                    if ([infoDic[@"upgrade"] boolValue]) {
                        // 需要强制更新
                        if ([infoDic[@"force"] boolValue]) {
                            
                            [UIAlertController showAlertWithTitle:@"温馨提示" message:upgradeMsg buttonAction:^{
                                
                                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                    [[UIApplication sharedApplication] openURL:url];
                                }
                            } target:[UIApplication sharedApplication].keyWindow.rootViewController];
                        }
                        // 不需要强制更新
                        else {
                            [UIAlertController showAlertWithTitle:@"温馨提示" message:upgradeMsg actionsMsg:@[@"立即前往",@"暂不升级"] buttonActions:^(NSInteger index) {
                                // 暂不升级
                                if (index == 1) {
                                    
                                }
                                // 立即前往
                                else if (index == 0) {
                                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                        [[UIApplication sharedApplication] openURL:url];
                                    }
                                }
                            } target:[UIApplication sharedApplication].keyWindow.rootViewController];
                        }
                    }
                    // 不需更新
                    else {
                        
                    }
                    
                } else {
                    
                    NSLog(@"%@",responseObject[ServerResponse_msg]);
                }

            } failure:^(NSError *error) {
                
            } isLogin:^{
                
            }];
        }
        // 本地为最新版本
        else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求AppStroe版本信息链接失败，URL= %@",url);
    }];
}
@end

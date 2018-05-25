//
//  TXNetworkTool.m
//  TailorX
//
//  Created by liuyanming on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXNetworkTool.h"

#import "Reachability.h"

@implementation TXNetworkTool

+(BOOL)checkNetWorkStatus {
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
        
        return YES;
    }
    else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        
        return YES;
    }
    else{
        return NO;
    }
}

@end

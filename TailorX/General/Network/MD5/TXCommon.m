//
//  TXCommon.m
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCommon.h"
#import <CommonCrypto/CommonDigest.h>
#import "HCRKeyChain.h"

#define KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define KEY_USERNAME @"com.company.app.username"
#define KEY_PASSWORD @"com.company.app.password"

@implementation TXCommon

/**
 MD5 加密

 @param str 加密字符串
 @return 加密后的字符串
 */
+ (NSString*)md5HexDigest:(NSString*)str{
    const char* cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

/**
 * 获取UDID
 */

+ (NSString *)createUDID {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[HCRKeyChain load:KEY_USERNAME_PASSWORD];
    NSString *UniqueId = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
    NSString *sUDID;
    if ([UniqueId length] <= 0)
    { //写入
        UIDevice *ud = [UIDevice currentDevice];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0){
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
            NSString *uuidString = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidStr));
            CFRelease(uuidStr);
            CFRelease(uuid);
            UniqueId = uuidString;
        }
        else{
            UniqueId = [[ud identifierForVendor] UUIDString];
        }
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:UniqueId forKey:KEY_USERNAME];
        [HCRKeyChain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
        return UniqueId;
    }
    else{
        sUDID = UniqueId;
    }
    return UniqueId;
}

/** 
 * 获取app版本号
 */

+ (NSString*)getAppVersion {
    NSString *app_Version = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    return app_Version;
    
}

+ (NSString*)getDeviceUUId {
    
  return [[[UIDevice currentDevice] identifierForVendor] UUIDString];

}

@end

//
//  TXCommon.h
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCommon : NSObject

/**
 MD5 加密
 
 @param str 加密字符串
 @return 加密后的字符串
 */
+ (NSString*)md5HexDigest:(NSString*)str;

/**
 * 获取UDID
 */

+ (NSString *)createUDID;

/**
 * 获取app版本号
 */

+ (NSString*)getAppVersion;
/**
 * 获取DeviceUUId
 */
+ (NSString*)getDeviceUUId;
@end

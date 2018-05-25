//
//  TXKVPO.h
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXKVPO : NSObject

+(void)setKey:(NSString*)key1;
+(NSString*)getKey;
+(void)setValue:(NSString*)value1;
+(NSString*)getValue;

// 图形验证码所需
+(void)setVerifyCodeUUID:(NSString *)uuid;
+(NSString *)getVerifyCodeUUID;

+(void)setIsInfomation:(NSString*)infomation;
+(NSString*)getIsInfomation;

+(void)setHeaderViewHeight:(NSString*)height;
+(NSString*)getHeaderViewHeight;

// 判断是否进入了发现页面
+(void)setIsDiscover:(NSString*)discover;
+(NSString*)getIsDiscover;

@end

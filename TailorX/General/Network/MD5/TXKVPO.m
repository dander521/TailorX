//
//  TXKVPO.m
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXKVPO.h"

@implementation TXKVPO

NSString *key;
NSString *value;

+(void)setKey:(NSString*)key1;{
    key = key1;
}
+(NSString*)getKey;{
    return key;
}
+(void)setValue:(NSString*)value1;{
    value = value1;
}
+(NSString*)getValue;{
    return value;
}

// 图形验证码所需
NSString *strUUID;

+(void)setVerifyCodeUUID:(NSString *)uuid{
    strUUID = uuid;
    
}

+(NSString *)getVerifyCodeUUID{
    
    return strUUID;
}

NSString *isInfomation;

+(void)setIsInfomation:(NSString*)infomation {
    isInfomation = infomation;
}

+(NSString*)getIsInfomation{
    return isInfomation;
}

NSString *isDiscover;

+(void)setIsDiscover:(NSString*)discover {
    isDiscover = discover;
    [TXDiscoverItem sharedTXDiscoverItem].hidden = [discover integerValue] == 1 ? NO : YES;
}

+(NSString*)getIsDiscover {
    return isDiscover;
}

NSString *headerViewHeight;
+(void)setHeaderViewHeight:(NSString*)height {
    headerViewHeight = height;
}
+(NSString*)getHeaderViewHeight {
    return headerViewHeight;
}


@end

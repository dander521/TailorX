//
//  NSString+WGDate.h
//  WildGrass
//
//  Created by yons on 16/11/15.
//  Copyright © 2016年 Mr.Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WGDate)
/**
 *  获取时间戳
 *
 *  @return 字符串类型
 */
+ (NSString *)getTimeInterval;
/**
 *  时间格式：yyyy/MM/dd
 */
+(NSString *)formatDate:(double)timesp;
/**
 *  时间格式：yyyy-MM-dd
 */
+(NSString *)formatDateLine:(double)timesp;
/**
 *  时间格式：yyyy-MM-dd HH:mm:ss
 */
+(NSString *)formatDateToSecond:(double)timesp;
/**
 *  时间格式：yyyy-MM-dd HH:mm
 */
+(NSString *)formatDateToMin:(double)timesp;
/**
 *  时间格式：MM-dd HH:mm
 */
+(NSString *)formatDateMMDDHHMM:(double)timesp;
/**
 *  时间格式：目标时间距离当前时间间隔显示“刚刚”，“time分钟之前”，“time小时之前”
 */
+(NSString *)formatNewsDate:(long long)time;

//通过时间戳得出显示时间 时间格式 **年**月**日
+ (NSString *)getDateStringWithTimestamp:(NSTimeInterval)timestamp;

/**
 获取剩余时间 秒
 
 @param timeInterval 时间戳
 @return
 */
+ (NSString *)getLastTimeWithTimeInterval:(NSTimeInterval)timeInterval;
/**
 刚刚：1分钟以内
 xx分钟前：1分钟-1个小时以内
 xx小时前：1小时-24小时以内
 昨天：当前时间前一天
 前天：当前时间前两天
 2017-09-23：当前时间前天以前
 */
+ (NSString *)formateDateWithString:(NSString *)dateString;

@end

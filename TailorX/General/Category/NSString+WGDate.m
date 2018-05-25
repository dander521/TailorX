//
//  NSString+WGDate.m
//  WildGrass
//
//  Created by yons on 16/11/15.
//  Copyright © 2016年 Mr.Chang. All rights reserved.
//

#import "NSString+WGDate.h"

@implementation NSString (WGDate)
+ (NSString *)getTimeInterval
{
    NSDate * date = [NSDate date];
    NSInteger timeInterval = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(long)timeInterval];
}
+(NSString *)formatDate:(double)timesp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}
/**
 *  时间格式：yyyy-MM-dd
 */
+(NSString *)formatDateLine:(double)timesp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+(NSString *)formatDateToSecond:(double)timesp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+(NSString *)formatDateToMin:(double)timesp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)formatDateMMDDHHMM:(double)timesp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)formatNewsDate:(long long)time{
    NSDate *newsDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *dateStr = nil;
    long long nowTime = [[NSDate date] timeIntervalSince1970];
    if (time + 60 >= nowTime) {
        dateStr = [NSString stringWithFormat:@"刚刚"];
    }else if (time + 60 * 60 >= nowTime) {
        long long minute = (nowTime - time) / 60;
        dateStr = [NSString stringWithFormat:@"%lld分钟前", minute];
    }else if (time + 60 * 60 * 24 >= nowTime) {
        long long hour = (nowTime - time) / (60 * 60);
        dateStr = [NSString stringWithFormat:@"%lld小时前", hour];
    }else {
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
        NSDate *beforeYesterday =  [[NSDate alloc] initWithTimeIntervalSinceNow:-2*secondsPerDay];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:newsDate];
        NSDateComponents* comp2 = [calendar components:unitFlags fromDate:yearsterDay];
        NSDateComponents* comp3 = [calendar components:unitFlags fromDate:beforeYesterday];
        if ( comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day) {
            dateStr = @"昨天";
        }
        else if (comp1.year == comp3.year && comp1.month == comp3.month && comp1.day == comp3.day) {
            dateStr = @"前天";
        }else {
            dateStr = [NSString stringWithFormat:@"%@", [self formatDateMMDDHHMM:time]];
        }
    }
    return dateStr;
}

+ (NSString*)getDateStringWithTimestamp:(NSTimeInterval)timestamp
{
    NSDate *confromTimesp    = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceYear  =referenceComponents.year;
    NSInteger referenceMonth =referenceComponents.month;
    NSInteger referenceDay   =referenceComponents.day;
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)referenceYear,(long)referenceMonth,(long)referenceDay];
}

+ (NSString *)formateDateWithString:(NSString *)dateString {
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * nowDate = [NSDate date];
        
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        NSString *dateStr = [[NSString alloc] init];
        
        if (time<=60) {  //1分钟
            dateStr = @"刚刚";
        }else if(time<=60*60){  //一个小时
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        }else if(time<=60*60*24*2){  //两天
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if (time < 60*60*24){
                if ([need_yMd isEqualToString:now_yMd]) {
                    //今天
                    dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
                }else{
                    //昨天
                    dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
                }
            }else {
                //昨天
                dateStr = [NSString stringWithFormat:@"前天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
            
        }else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

/**
 获取剩余时间 秒
 
 @param timeInterval 时间戳
 @return
 */
+ (NSString *)getLastTimeWithTimeInterval:(NSTimeInterval)timeInterval {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d", 30*60 - ((int)((int)now - timeInterval/1000))];
}

@end

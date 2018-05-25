//
//  TXMyMD5.h
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXMyMD5 : NSObject


+(NSString*)md5:(NSDictionary*)dicParamer
           time:(NSString*)time;

/**
 *获得系统时间
 */

+(NSString*)getSystemTime;

@end

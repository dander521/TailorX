//
//  TXStroeDataTool.h
//  TailorX
//
//  Created by 温强 on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXStroeDataTool : NSObject

/**
 * 获取门店列表模型数组
 */
+ (NSArray *)getStroeListModelArrayWithData:(id)data;

@end

//
//  TXFontTool.h
//  TailorX
//
//  Created by liuyanming on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MaxFont [UIFont systemFontOfSize:25]
#define MinFont [UIFont systemFontOfSize:14]

@interface TXFontTool : NSObject

+ (NSMutableAttributedString *)addFontAttribute:(NSString*)string minFont:(UIFont *)minfont number:(NSInteger)number;

/**
 * 计算文字的宽高
 */
+ (CGSize)heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width;

@end

//
//  TXFontTool.m
//  TailorX
//
//  Created by liuyanming on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFontTool.h"

@implementation TXFontTool

+ (NSMutableAttributedString *)addFontAttribute:(NSString*)string minFont:(UIFont *)minfont number:(NSInteger)number{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:string];
    [aString addAttribute:NSFontAttributeName value:minfont range:NSMakeRange(string.length-number,number)];
    return aString;
}

/**
 * 计算文字的宽高
 */
+ (CGSize)heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

@end

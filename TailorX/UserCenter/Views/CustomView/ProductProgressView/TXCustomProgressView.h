//
//  TXCustomProgressView.h
//  iOS开发常见技术-每日一记
//
//  Created by Qian Shen on 2017/3/14.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXCustomProgressView : UIView

/**标题数组*/
@property (nonatomic, strong) NSArray   *titles;

/**当前脚标*/
@property (nonatomic, assign) NSInteger currentIndex;

/**选中颜色*/
@property (nonatomic, strong) UIColor   *currentColor;

/**未选中颜色*/
@property (nonatomic, strong) UIColor   *customProgressViewColor;

/**
 * 创建 TXCustomProgressView
 */

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end

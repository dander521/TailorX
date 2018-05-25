//
//  TXCustomProgressView.m
//  iOS开发常见技术-每日一记
//
//  Created by Qian Shen on 2017/3/14.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import "TXCustomProgressView.h"

// 在实际使用中如果导入了Masonry，可以将其去掉
#import "Masonry.h"

#define kTitleSize 14
#define kTitleLabelTag 100
#define kDotViewTag 300
#define kLineViewtag 200

#define kDotViewRadius 5
#define kLineViewHeight 1

@interface TXCustomProgressView ()


/**大半透明圆圈*/
@property (nonatomic, strong) UIView *bigDotView;


@end

@implementation TXCustomProgressView

/**
 * 创建TXCustomProgressView 这里为了使用for循环创建控件，不方便在layoutSubviews进行布局，所以不提供init方法
 */

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    CGFloat w = self.frame.size.width;
    NSMutableArray *titleWidths = [@[]mutableCopy];
    NSMutableArray *lineViewWidths = [@[]mutableCopy];
    CGFloat titlesAllWidth = 0;
    for (NSInteger i = 0; i < self.titles.count; i ++) {
        CGFloat titleWidth = [self labelText:self.titles[i] fondSize:kTitleSize width:MAXFLOAT].width;
        titlesAllWidth += titleWidth;
        [titleWidths addObject:@(titleWidth)];
    }
    // 标题的左边距离
    CGFloat titleLeft = 0;
    // 标题之间的间隔
    CGFloat titleInterval = (w - titlesAllWidth) / (self.titles.count - 1);
    // dotView的centerX
    CGFloat oldLineViewCenterx = 0;
    CGFloat lineViewCentery = 0;
    for (NSInteger i = 0; i < self.titles.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.titles[i];
        label.font = [UIFont systemFontOfSize:kTitleSize];
        label.tag = kTitleLabelTag + i;
        [self addSubview:label];
        
        UIView *dotView = [[UIView alloc]init];
        dotView.layer.cornerRadius = kDotViewRadius;
        dotView.layer.masksToBounds = YES;
        dotView.tag = kDotViewTag + i;
        [self addSubview:dotView];
        dotView.backgroundColor = [UIColor yellowColor];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(titleLeft));
            make.top.mas_equalTo(self).offset(5);
        }];
        
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(label.mas_centerX);
            // 调节标题与原点的上下距离
            make.centerY.mas_equalTo(label.mas_centerY).offset(30);
            make.width.mas_equalTo(@(kDotViewRadius * 2));
            make.height.mas_equalTo(dotView.mas_width);
        }];
        [self layoutIfNeeded];
        titleLeft += [titleWidths[i] floatValue] + titleInterval;
        
        if (i > 0) {
            CGFloat lineViewWidth = dotView.center.x - oldLineViewCenterx;
            [lineViewWidths addObject:@(lineViewWidth)];
        }else{
            lineViewCentery = dotView.center.y;
        }
        oldLineViewCenterx = dotView.center.x;
    }
    CGFloat linViewLeft = [titleWidths.firstObject floatValue] / 2;
    
    for (NSInteger i = 0; i < self.titles.count - 1; i ++) {
        UIView *lineView = [[UIView alloc]init];
        lineView.tag = kLineViewtag + i;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(linViewLeft));
            make.height.mas_equalTo(@(kLineViewHeight));
            make.width.mas_equalTo([lineViewWidths[i] floatValue]);
            make.top.mas_equalTo(@(lineViewCentery - kLineViewHeight / 2.0));
        }];
        linViewLeft += [lineViewWidths[i]floatValue];
    }
}

- (void)setCustomProgressViewColor:(UIColor *)customProgressViewColor {
    _customProgressViewColor = customProgressViewColor;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel*)view).textColor = _customProgressViewColor;
        }else{
            view.backgroundColor = _customProgressViewColor;
        }
    }
}

- (void)setCurrentColor:(UIColor *)currentColor {
    _currentColor = currentColor;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            if (view.tag % kTitleLabelTag == self.currentIndex) {
                ((UILabel*)view).textColor = _currentColor;
            }else{
                ((UILabel*)view).textColor = _customProgressViewColor;
            }
        }else{
            if (view.tag % kLineViewtag < self.currentIndex) {
                ((UILabel*)view).backgroundColor = _currentColor;
            }else if (view.tag % kDotViewTag < self.currentIndex){
                ((UILabel*)view).backgroundColor = _currentColor;
            }else if (view.tag % kDotViewTag == self.currentIndex){
                UIView *dotView = (UILabel*)view;
                dotView.backgroundColor = _currentColor;
                [self addSubview:self.bigDotView];
                self.bigDotView.center = dotView.center;
                self.bigDotView.backgroundColor = _currentColor;
                self.bigDotView.alpha = 0.1;
                
            }else{
                ((UILabel*)view).backgroundColor = _customProgressViewColor;
            }
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self setCurrentColor:_currentColor];
}


- (void)layoutSubviews {
    NSArray *views = self.subviews;
    for (NSInteger i = 0; i < views.count; i ++) {
        UIView *tempView = (UIView*)views[i];
        if (tempView.tag >= kDotViewTag) {
            [self bringSubviewToFront:tempView];
        }
    }
}

/**
 *  计算字符串长度，UILabel自适应高度
 *
 *  @param text  需要计算的字符串
 *  @param size  字号大小
 *  @param width 最大宽度
 *
 *  @return 返回大小
 */
- (CGSize)labelText:(NSString *)text fondSize:(float)size width:(CGFloat)width
{
    NSDictionary *send = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:send context:nil].size;
    
    return textSize;
}


- (UIView *)bigDotView {
    if (!_bigDotView) {
        _bigDotView = [[UIView alloc]init];
        _bigDotView.bounds = CGRectMake(0, 0, kDotViewRadius * 5, kDotViewRadius * 5);
        _bigDotView.layer.cornerRadius = kDotViewRadius * 2.5;
    }
    return _bigDotView;
}






@end

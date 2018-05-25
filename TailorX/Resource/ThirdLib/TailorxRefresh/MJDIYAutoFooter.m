//
//  MJDIYAutoFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYAutoFooter.h"

@interface MJDIYAutoFooter()
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@property (weak, nonatomic) UIView *bottomView;
@end

@implementation MJDIYAutoFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 70;

    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    self.bottomView.hidden = YES;
    UILabel * middleLab = [[UILabel alloc] init];
    middleLab.text = @"~我也是有底线的~";
    middleLab.font = [UIFont systemFontOfSize:13];
    middleLab.textAlignment = NSTextAlignmentCenter;
    middleLab.textColor = RGB(204, 204, 204);
    [self.bottomView addSubview:middleLab];
    [middleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(@(17));
    }];
    
    UILabel * leftLine = [[UILabel alloc] init];
    leftLine.hidden = YES;
    leftLine.backgroundColor = RGB(221, 221, 221);
    [self.bottomView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(middleLab.mas_left).offset(-16);
        make.size.mas_equalTo(CGSizeMake(54, 0.5));
    }];
    
    UILabel * rightLine = [[UILabel alloc] init];
    rightLine.backgroundColor = RGB(221, 221, 221);
    rightLine.hidden = YES;
    [self.bottomView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(middleLab.mas_right).offset(16);
        make.size.mas_equalTo(CGSizeMake(54, 0.5));
    }];
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.bottomView.frame = self.bounds;
    
    self.loading.center = CGPointMake(self.bounds.size.width / 2, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.bottomView.hidden = YES;
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.bottomView.hidden = YES;
            [self.loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            self.bottomView.hidden = NO;
            [self.loading stopAnimating];
            break;
        default:
            break;
    }
}

@end

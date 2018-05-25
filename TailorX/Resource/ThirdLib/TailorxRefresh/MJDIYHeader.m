//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYHeader.h"
#import "DACircularProgressView.h"

static NSString* const kRotationAnimation = @"RotationAnimation";
@interface MJDIYHeader()
@property (nonatomic, strong) DACircularProgressView *circleView;
@property (nonatomic, strong) ThemeImageView *loadingImageView;

@property (nonatomic, strong) UILabel * desLab;
@end

@implementation MJDIYHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 62;
    
    self.circleView = [[DACircularProgressView alloc] init];
    self.circleView.roundedCorners = 3;
    self.circleView.thicknessRatio = 0.2;
    self.circleView.trackTintColor = [UIColor clearColor];
     self.circleView.progressTintColor = [[ThemeManager shareManager]loadThemeColorWithName:@"navigation_color"];
    [self addSubview:self.circleView];
    
    self.loadingImageView = [[ThemeImageView alloc] init];
    self.loadingImageView.imgName = @"pullDown";
    self.loadingImageView.hidden = YES;
    self.loadingImageView.layer.allowsEdgeAntialiasing = YES;
    [self addSubview:self.loadingImageView];
    
//    UILabel * label = [TailorxFactory setLabWithText:@"PULL TO REFRESH" textColor:RGB(204, 204, 204) fontType:FONTType(@"HelveticaNeue-Light", 11) superView:self];
    UILabel * label = [TailorxFactory setLabWithText:@"下拉刷新" textColor:RGB(204, 204, 204) fontType:FONTType(@"HelveticaNeue-Light", 11) superView:self];
    label.textAlignment = NSTextAlignmentCenter;
    self.desLab = label;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNotifation object:nil];
    
}

-(void)themeChangeAction{
    UIColor *color = [[ThemeManager shareManager]loadThemeColorWithName:@"navigation_color"];
    self.circleView.progressTintColor = color;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.circleView.frame = CGRectMake(0, 0, 16, 16);
    self.circleView.transform = CGAffineTransformMakeRotation(M_PI);
    self.circleView.center = CGPointMake(self.center.x, 20);
    
    self.loadingImageView.frame = self.circleView.frame;
    
    self.desLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 13);
    self.desLab.center = CGPointMake(self.center.x, 48);
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
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
//        self.desLab.text = @"PULL TO REFRESH";
        self.desLab.text = @"下拉刷新";
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            self.loadingImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
            if (self.state != MJRefreshStateIdle) return;
            
            self.loadingImageView.alpha = 1.0;
            [self.loadingImageView.layer removeAnimationForKey:kRotationAnimation];
            self.circleView.hidden = NO;
            self.loadingImageView.hidden = YES;
        }];
    } else if (state == MJRefreshStatePulling) {
        
//        self.desLab.text = @"RELEASE TO REFRESH";
        self.desLab.text = @"松开刷新";
        [self.loadingImageView.layer removeAnimationForKey:kRotationAnimation];
        self.circleView.hidden = NO;
        self.loadingImageView.hidden = YES;
    } else if (state == MJRefreshStateRefreshing) {
        
//        self.desLab.text = @"REFRESHING";
        self.desLab.text = @"正在刷新";
        self.circleView.hidden = YES;
        self.loadingImageView.hidden = NO;
        self.loadingImageView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingImageView.layer addAnimation:[self createRotationAnimation] forKey:kRotationAnimation];
    }
}
- (CAAnimation *)createRotationAnimation {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotationAnimation setValue:kRotationAnimation forKey:@"id"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    rotationAnimation.duration = 0.8f;
    rotationAnimation.repeatCount = NSUIntegerMax;
    rotationAnimation.speed = 1.0f;
    rotationAnimation.removedOnCompletion = YES;
    
    return rotationAnimation;
}
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    [self.circleView setProgress:pullingPercent animated:YES];
}

@end

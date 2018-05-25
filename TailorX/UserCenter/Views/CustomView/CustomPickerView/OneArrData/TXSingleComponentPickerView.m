//
//  TXBodyDataViewController.m
//  TailorX
//
//  Created by RogerChen on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#define YLSRect(x, y, w, h)  CGRectMake([UIScreen mainScreen].bounds.size.width * x,\
[UIScreen mainScreen].bounds.size.height * y,\
[UIScreen mainScreen].bounds.size.width * w,\
[UIScreen mainScreen].bounds.size.height * h)

#define YLSFont(f) [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width * f]

#define YLSColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define YLSMainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]

#define BlueColor [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]

#define ClearColor [UIColor clearColor]

#import "TXSingleComponentPickerView.h"

@interface TXSingleComponentPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
/** view */
@property (nonatomic,strong) UIView *topView;
/** button */
@property (nonatomic,strong) UIButton *doneBtn;
/** button */
@property (nonatomic,strong) UIButton *cancelBtn;
/** pickerView */
@property (nonatomic,strong) UIPickerView *pickerView;

@end

@implementation TXSingleComponentPickerView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
    if (self)
    {
        self.backgroundColor = YLSColorAlpha(0, 0, 0, 0.4);
    }
    
    // 刘彦铭
    [self addSubViews];
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.topView = [[UIView alloc]initWithFrame:YLSRect(0, 667/667, 1, 258.5/667)];

// 刘彦铭
- (void)addSubViews {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, LayoutH(258.5))];

    self.topView.backgroundColor = RGB(246, 246, 246);
    [self addSubview:self.topView];
    
    //为view上面的两个角做成圆角。不喜欢的可以注掉
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.topView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topView.layer.mask = maskLayer;
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneBtn.titleLabel.font = FONT(18);
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:RGB(0, 122, 255) forState:UIControlStateNormal];
    [self.doneBtn setFrame:YLSRect(320/375, 5/667, 43.5/375, 33.5/667)];
    [self.doneBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.doneBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.titleLabel.font = FONT(17);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:RGB(145, 151, 163) forState:UIControlStateNormal];
    [self.cancelBtn setFrame:YLSRect(5/375, 5/667, 43.5/375, 33.5/667)];
    [self.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.cancelBtn];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:YLSRect(100/375, 0, 175/375, 43.5/667)];
    titlelb.backgroundColor = ClearColor;
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.text = self.title;
    titlelb.font = YLSFont(20/375);
    [self.topView addSubview:titlelb];
    
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(titlelb.frame), SCREEN_WIDTH, self.topView.frame.size.height - CGRectGetMaxY(titlelb.frame));
    
    [self.pickerView setBackgroundColor:YLSMainBackColor];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.topView addSubview:self.pickerView];
    
}

// 快速创建
+ (instancetype)pickerView;
{
    return [[self alloc] init];
}

// 点击背景
- (void)tapGestrueMethod:(UITapGestureRecognizer *)gesture {
    [self hide];
}

// 弹出
- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    
    [view addSubview:self];
    
    // 浮现
    [UIView animateWithDuration:0.5 animations:^{
        self.topView.transform = CGAffineTransformMakeTranslation(0, -self.topView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)quit {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.topView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (!self.result) {
            self.result = self.array[0];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"value" object:self];
        [self removeFromSuperview];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.topView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.array count];
}

#pragma mark - 代理
// 返回第component列第row行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.array[row];
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.result = self.array[row];
}


@end

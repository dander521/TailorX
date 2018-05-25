//
//  TXCitySelector.m
//  TailorX
//
//  Created by RogerChen on 2017/4/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCitySelector.h"
#import "LocationObject.h"
#import "CustomLocationPickerView.h"

#define Animation_Time    0.2

@interface TXCitySelector ()<CustomLocationPickerViewDelegate>

@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) LocationObject *locationObject;

@property (nonatomic, strong) NSDictionary *locationDictionary;
@property (nonatomic, strong) NSMutableDictionary *submitDictionary;

@end

@implementation TXCitySelector

+ (TXCitySelector *)shareManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    
    return self;
}

/**
 显示选择器
 */
- (void)showCitySelector {
    [self makeKeyWindow];
    
    [UIView animateWithDuration:Animation_Time delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.showView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        self.showView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    }];
    
    self.hidden = false;
}

/**
 隐藏选择器
 */
- (void)hideCitySelector {
    self.showView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:Animation_Time delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.showView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self resignKeyWindow];
        
        self.hidden = true;
    }];
}

- (void)setupUI
{
    _locationObject = [LocationObject configObject];
    _submitDictionary = [NSMutableDictionary new];
    
    if (!self.showView)
    {
        self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.showView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
        tapGesture.numberOfTapsRequired = 1;
        [self.showView addGestureRecognizer:tapGesture];
    }
    
    UIView *selectTimeView = [[UIView alloc] init];
    selectTimeView.backgroundColor = RGB(246, 246, 246);
    
    selectTimeView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 258.5, [UIScreen mainScreen].bounds.size.width, 43.5);
    
    // 为view上面的两个角做成圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:selectTimeView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = selectTimeView.bounds;
    maskLayer.path = maskPath.CGPath;
    selectTimeView.layer.mask = maskLayer;
    
    // 显示文字
    UILabel *showLabel = [UILabel new];
    showLabel.frame = selectTimeView.bounds;
    showLabel.text = _locationObject.pickerTitle;
    showLabel.textAlignment = NSTextAlignmentCenter;
    [selectTimeView addSubview:showLabel];
    
    CustomLocationPickerView *locationPicker = [[CustomLocationPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 215, [UIScreen mainScreen].bounds.size.width, 215) locationObject:_locationObject];
    locationPicker.backgroundColor = [UIColor whiteColor];
    locationPicker.locationDelegate = self;
    
    [self.showView addSubview:locationPicker];
    
    // 确定按钮
    UIButton *buttonSub = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 64, 0, 43.5, 43.5)];
    buttonSub.titleLabel.adjustsFontSizeToFitWidth = true;
    buttonSub.titleLabel.font = FONT(18);
    [buttonSub setTitleColor:RGB(246, 47, 94) forState:UIControlStateNormal];
    [buttonSub setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSub addTarget:self action:@selector(touchSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    [selectTimeView addSubview:buttonSub];
    
    // 取消按钮
    UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 43.5, 43.5)];
    buttonCancel.titleLabel.adjustsFontSizeToFitWidth = true;
    buttonCancel.titleLabel.font = FONT(17);
    [buttonCancel setTitleColor:RGB(145, 151, 163) forState:UIControlStateNormal];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(touchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [selectTimeView addSubview:buttonCancel];
    
    [self.showView addSubview:selectTimeView];
    
    [self addSubview:self.showView];
}

#pragma mark - CustomLocationPickerViewDelegate

- (void)didSelectLocation:(NSDictionary *)locationDictionary
{
    _locationDictionary = locationDictionary;
}

#pragma mark - Touch Method

- (void)touchSubmitButton:(id)sender
{
    NSMutableDictionary *dicBack = [NSMutableDictionary new];
    
    if (_locationDictionary == nil)
    {
        if (_locationObject.selectMode == CitySelectorModeCouty) {
            [dicBack setValue:_locationDictionary[@"province"] == nil ? _locationObject.defaultProvince : _locationDictionary[@"province"] forKey:@"province"];
        } else if (_locationObject.selectMode == CitySelectorModeCity)
        {
            [dicBack setValue:_locationDictionary[@"province"] == nil ? _locationObject.defaultProvince : _locationDictionary[@"province"] forKey:@"province"];
            [dicBack setValue:_locationDictionary[@"city"] == nil ? _locationObject.defaultCity : _locationDictionary[@"c"] forKey:@"city"];
        } else {
            [dicBack setValue:_locationDictionary[@"province"] == nil ? _locationObject.defaultProvince : _locationDictionary[@"province"] forKey:@"province"];
            [dicBack setValue:_locationDictionary[@"city"] == nil ? _locationObject.defaultCity : _locationDictionary[@"city"] forKey:@"city"];
            [dicBack setValue:_locationDictionary[@"zone"] == nil ? _locationObject.defaultCouty : _locationDictionary[@"zone"] forKey:@"zone"];
        }
    } else {
        [dicBack addEntriesFromDictionary:_locationDictionary];
    }
    
    _submitDictionary = [NSMutableDictionary dictionaryWithDictionary:dicBack];
    [_submitDictionary setValue:@"1" forKey:@"index"];

    [self hideCitySelector];
    
    if (dicBack.count == 0) {
        dicBack = [NSMutableDictionary dictionaryWithDictionary:@{@"province" : @"北京市", @"city" : @"市辖区", @"zone" : @"东城区"}];
    }
    
    if ([self.delegate respondsToSelector:@selector(touchCitySelectorButtonWithDictionary:)]) {
        [self.delegate touchCitySelectorButtonWithDictionary:dicBack];
    }
}

- (void)touchCancelButton:(id)sender
{
    [self hideCitySelector];
}

// 点击背景
- (void)tapGestrueMethod:(UITapGestureRecognizer *)gesture {
    [self hideCitySelector];
}

@end

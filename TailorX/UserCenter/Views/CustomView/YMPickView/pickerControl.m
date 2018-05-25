//
//  pickerControl.m
//  F2FClient
//
//  Created by l_ym  on 15/10/21.
//  Copyright (c) 2015年 feng. All rights reserved.
//

#import "pickerControl.h"
#import "AppDelegate.h"

@interface pickerControl () <UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *dataSource;
    UIView *contentView;
    void(^backBlock)(NSString *);
    NSString *restr;
    NSInteger columns;
    NSArray *columns_two_dataSource;
}

@end
@implementation pickerControl

- (instancetype)initWithType:(NSInteger)type columuns:(NSInteger)col WithDataSource:(NSArray *)sources response:(void (^)(NSString *))block {
    if (self = [super init]) {
        columns = col;
        self.frame = [UIScreen mainScreen].bounds;
        [self setViewInterface];
        if (block) {
            backBlock = block;
        }
        if (sources) {
            dataSource = [sources copy];
        }
        if (type == 0) {
            [self pickerView];
        }else {
            [self dataPicker];
        }
        
        
    }
    return self;
}
#pragma mark View初始配置
- (void)setViewInterface {
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 260)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];//设置背景颜色为黑色，并有0.4的透明度
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    whiteView.backgroundColor = RGB( 246, 246, 246);
    [contentView addSubview:whiteView];
    
   
    
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 44)];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        [button setTitleColor: i == 0 ?RGB( 145, 151, 163) : RGB( 0, 122, 255) forState:UIControlStateNormal];
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
}
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    }else {
        backBlock(restr);
        [self dismiss];
    }
}
#pragma mark dataPicker
- (void)dataPicker{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:datePicker];
    restr = [self changeToStringWithDate:[NSDate date]];//给一个最初值防止没滑动就直接确定
}
#pragma mark date 值改变方法
- (void)dateChange:(UIDatePicker *)datePicker {
    restr = [self changeToStringWithDate:datePicker.date];
}
- (NSString *)changeToStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}
#pragma mark pickerView
- (void)pickerView {
    for (id obj in dataSource) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            columns_two_dataSource = [dataSource[0] allValues][0];
             restr = columns_two_dataSource[0];
        }else{
            restr = dataSource[0];
        }
        break;
    }
   
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    [contentView addSubview:pickerView];
}
#pragma mark 出现
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}
#pragma mark 消失
- (void)dismiss{
   
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark UIPickerViewDataSource UIPickerViewDelegate
//返回有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return columns;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return dataSource.count;
    }
    else {
        return columns_two_dataSource.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        if (columns_two_dataSource) {
            return [dataSource[row]allKeys][0];
        }else{
            return dataSource[row];
        }
        
    }else {
        return columns_two_dataSource[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (columns_two_dataSource) {
            columns_two_dataSource = [dataSource[row] allValues][0];
            restr = columns_two_dataSource[0];
            [pickerView reloadComponent:1];
        }else{
            restr = dataSource[row];
        }
        
    }else {
        restr = columns_two_dataSource[row];
    }
}

@end

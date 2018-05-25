//
//  TXBodyDataViewController.m
//  TailorX
//
//  Created by RogerChen on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXSingleComponentPickerView : UIView

/** array */
@property (nonatomic,strong) NSArray *array;
/** title */
@property (nonatomic,strong) NSString *title;
/** srting */
@property (nonatomic,strong) NSString *result;

// 快速创建
+ (instancetype)pickerView;

// 弹出
- (void)show;

@end

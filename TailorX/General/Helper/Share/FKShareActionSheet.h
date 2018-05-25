//
//  FKShareActionSheet.h
//  5KM
//
//  Created by haozhiyu on 2017/4/23.
//  Copyright © 2017年 UTSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FKShareActionSheetClickBlock)();

@interface FKShareActionSheet : UIControl

/**
 添加一个点击按钮

 @param image 按钮图片
 @param title 按钮标题
 @param clickBlock 按钮触发事件的回调
 */
- (void)addActionWithImage:(UIImage *)image title:(NSString *)title clickBlock:(FKShareActionSheetClickBlock)clickBlock;

/**
 弹出视图的方法
 */
- (void)show;

@end

//
//  UITextView+TXPlaceholder.m
//  TailorX
//
//  Created by RogerChen on 23/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (SQExtension)

/**
 *  自定义弹出框（带确定按钮，不带点击事件）
 *
 *  @param title   标题
 *  @param message 提示信息
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                    target:(UIViewController *)target;
/**
 *  自定义弹出框（带确定按钮，带点击事件）
 *
 *  @param title        标题
 *  @param message      提示信息
 *  @param buttonAction 点击事件的回调
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              buttonAction:(void(^)())buttonAction
                    target:(UIViewController *)target;
/**
 *  自定义弹出框（带多个按钮，带点击事件）
 *
 *  @param title        标题
 *  @param message      提示信息
 *  @param actionMsg    按钮标题s
 *  @param buttonAction 点击事件的回调
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                actionsMsg:(NSArray *)actionMsg
             buttonActions:(void (^)(NSInteger))buttonAction
                    target:(UIViewController*)target;

/**
 *  自定义弹出框
 *
 *  @param message      提示信息
 *  @param actionMsg    按钮标题
 */
+ (void)showAlertWithMessage:(NSString *)message
                      target:(UIViewController *)target;

/**
 *  自定义弹出框（带多个按钮，带点击事件, style自定义）
 *
 *  @param title        标题
 *  @param message      提示信息
 *  @param actionMsg    按钮标题s
 *  @param buttonAction 点击事件的回调
 */
+ (void)showAlertWithPreferredStyle:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actionsMsg:(NSArray *)actionMsg buttonActions:(void (^)(NSInteger))buttonAction target:(UIViewController*)target;

+ (void)showAlertWithTitle:(NSString *)title msg:(NSString *)message actionsMsg:(NSArray *)actionMsg buttonActions:(void (^)(NSInteger))buttonAction target:(UIViewController*)target;

+ (void)showAlertWithStyle:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actionsMsg:(NSArray *)actionMsg buttonActions:(void (^)(NSInteger))buttonAction target:(UIViewController *)target;

@end

//
//  TXCustomTools.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXAllDetailViewController.h"

@interface TXCustomTools : NSObject


/**
 调起系统拨打电话

 @param phoneNo 电话号码
 */
+ (void)callStoreWithPhoneNo:(NSString *)phoneNo target:(UIViewController *)target;

/**
 跳转容器详情控制器

 @param parentVC    父控制器
 @param childVC     子控制器
 @param orderNo     订单编号
 @param index       索引页
 */
+ (void)pushContainerVCWithParentVC:(UIViewController *)parentVC childVC:(UIViewController<ZJScrollPageViewChildVcDelegate> *)childVC orderNo:(NSString *)orderNo indexPage:(NSInteger)index;


/**
 设置alert按钮颜色

 @param color
 @param action
 */
+ (void)setActionTitleTextColor:(UIColor *)color action:(UIAlertAction *)action;


/**
 处理自定义返回按钮导航栏位置

 @return
 */
+ (float)customPopBarItemX;

/**
 处理自定义刷新图片

 @param scrollView
 @param target
 @param action
 */
+ (void)customHeaderRefreshWithScrollView:(UIScrollView *)scrollView
                         refreshingTarget:(id)target
                         refreshingAction:(SEL)action;

/**
 根据给定颜色 生成图片
 
 @param color
 @return
 */
+ (UIImage*)createImageWithColor:(UIColor*)color;

//随机颜色
+ (UIColor *)randomColor;

+ (NSString*)deviceModelName;

@end

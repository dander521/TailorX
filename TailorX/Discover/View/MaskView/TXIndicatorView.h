//
//  TXIndicatorView.h
//  TailorX
//
//  Created by Qian Shen on 13/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXIndicatorView : UIView

/**
 * 显示菊花
 * @param layout: 菊花的顶部位置
 * @param inView: 父视图
 */
- (void)showMaskIndicatorViewTopLayout:(CGFloat)layout inView:(UIView*)inView;

/**
 * 隐藏菊花
 */
- (void)hiddenMaskIndicatorView;

/** 返回上级页面的按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *topActivityView;
/** 菊花*/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

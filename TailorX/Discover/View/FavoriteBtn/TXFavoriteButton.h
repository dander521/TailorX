//
//  TXFavoriteButton.h
//  TailorX
//
//  Created by Qian Shen on 13/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBlock)(void);

@interface TXFavoriteButton : UIView

/** 点击回调*/
@property (nonatomic, copy) clickBlock block;
/** 按钮图片*/
@property (nonatomic, strong) UIImage *normalImg;


- (void)click:(clickBlock)block;

- (void)showAnimation;

- (void)dismissAnimation;

@end

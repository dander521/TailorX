//
//  TXDesingerDetailTopView.h
//  TailorX
//
//  Created by Qian Shen on 30/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFavoriteButton.h"

@protocol TXDesingerDetailTopViewDelegate <NSObject>

- (void)respondsToFavoriteBtn:(TXFavoriteButton*)favoriteBtn;

@end

@interface TXDesingerDetailTopView : UIView

/** 打电话*/
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
/** 收藏按钮的背景视图（这里为了不改变之前的约束，所以背景视图使用的之前的按钮）*/
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtnBgView;
/** 预约*/
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;
/** 返回*/
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIView *shadowView;
/** 收藏按钮*/
@property (nonatomic, strong) TXFavoriteButton *favoriteBtn;
/** 代理*/
@property (nonatomic, weak) id<TXDesingerDetailTopViewDelegate> delegate;

@end

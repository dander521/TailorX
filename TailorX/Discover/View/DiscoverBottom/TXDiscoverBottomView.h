//
//  TXDiscoverBottomView.h
//  TailorX
//
//  Created by Qian Shen on 21/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXFavoriteButton.h"

@protocol TXDiscoverBottomViewDelegate <NSObject>

- (void)respondsToFavoriteBtn:(TXFavoriteButton*)favoriteBtn;

@end

@interface TXDiscoverBottomView : UIView

/** 分享*/
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/** 预约*/
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;
/** 返回*/
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/** 阴影*/
@property (weak, nonatomic) IBOutlet UIView *shadowView;
/** 收藏按钮*/
@property (nonatomic, strong) TXFavoriteButton *favoriteBtn;
/** 收藏按钮的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *favoriteBtnBgView;
/** 代理*/
@property (nonatomic, weak) id<TXDiscoverBottomViewDelegate> delegate;

@end

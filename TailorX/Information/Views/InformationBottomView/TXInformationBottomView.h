//
//  TXInformationBottomView.h
//  TailorX
//
//  Created by Qian Shen on 15/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFavoriteButton.h"

@protocol TXInformationBottomViewDelegate <NSObject>

- (void)respondsToFavoriteBtn:(TXFavoriteButton*)favoriteBtn;

@end

@interface TXInformationBottomView : UIView

@property (weak, nonatomic) IBOutlet UIView *shadowView;
/** 评论*/
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
/** 预约*/
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/** 返回*/
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/** 收藏按钮*/
@property (nonatomic, strong) TXFavoriteButton *favoriteBtn;
/** 收藏按钮的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *favoriteBtnBgView;
/** 代理*/
@property (nonatomic, weak) id<TXInformationBottomViewDelegate> delegate;

@end

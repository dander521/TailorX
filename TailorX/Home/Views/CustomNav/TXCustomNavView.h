//
//  TXCustomNavView.h
//  TailorX
//
//  Created by Qian Shen on 7/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXCustomNavView : UIView

/** 返回按钮*/
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/** 标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 加载控件*/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
/** 底部分割线*/
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/** 分享按钮*/
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 中间图片*/
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;

+ (instancetype)getCustomNavView;

@end

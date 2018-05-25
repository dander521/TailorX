//
//  TXRegisteredView.h
//  TailorX
//
//  Created by Qian Shen on 17/7/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXRegisteredView : UIView

/** 倒计时标签*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 立即跳转*/
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

+ (instancetype)creationRegisteredView;

@end

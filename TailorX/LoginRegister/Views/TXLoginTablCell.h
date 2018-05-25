//
//  TXLoginTablCell.h
//  TailorX
//
//  Created by Qian Shen on 31/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TXTextField.h"

@interface TXLoginTablCell : UITableViewCell

/** 忘记密码*/
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
/** 登录*/
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/** 手机号码*/
@property (strong, nonatomic) TXTextField *phoneTextField;
/** 密码*/
@property (strong, nonatomic) TXTextField *passTextField;
/** 判断手机号是否正确的标记*/
@property (weak, nonatomic) IBOutlet UIImageView *phoneNumMarkImgView;
/** 手机号输入框的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *phoneNumBgView;
/** 密码输入框的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *passwordBgView;
/** 注册按钮*/
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

//
//  TXRegisterTabCell.h
//  TailorX
//
//  Created by Qian Shen on 28/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTextField.h"

@interface TXRegisterTabCell : UITableViewCell

/** 手机号输入*/
@property (strong, nonatomic)  TXTextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UIView *phoneNumBgView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneNumMarkImgView;
/** 短信验证码输入*/
@property (strong, nonatomic)  TXTextField *yzmTextField;
@property (weak, nonatomic) IBOutlet UIView *yzmBgView;
/** 输入密码框*/
@property (strong, nonatomic)  TXTextField *inputPassTextField;
@property (weak, nonatomic) IBOutlet UIView *inputPassBgView;
/** 确认密码框*/
@property (strong, nonatomic)  TXTextField *surePassTextField;
@property (weak, nonatomic) IBOutlet UIView *surePassBgView;
/** 注册按钮*/
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/** 获取验证码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *getYzmBtn;
/** 同意用户协议*/
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

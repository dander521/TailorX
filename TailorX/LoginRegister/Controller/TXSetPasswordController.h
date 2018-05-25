//
//  TXSetPasswordController.h
//  TailorX
//
//  Created by liuyanming on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingType) {
    SettingRegister = 0, // 注册
    SettingFind          // 找回
};


@interface TXSetPasswordController : UIViewController



/** 短信验证码*/
@property (nonatomic, strong) NSString *code;
/** 手机号*/
@property (nonatomic, strong) NSString *phoneNum;
/** 图形验证码*/
@property (nonatomic, strong) NSString *txCode;
/** 校验成功后返回的验证数据*/
@property (nonatomic, strong) NSString *idenKey;
/** 找回密码使用的ID*/
@property (nonatomic, strong) NSString *forgetId;



@property (nonatomic, assign) SettingType type;


@end

//
//  TXAppointmentDetailViewController.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBaseViewController.h"
#import "ZJScrollPageViewDelegate.h"

typedef void (^cancelBlock)(void);

@interface TXAppointmentDetailViewController : TXBaseViewController <ZJScrollPageViewChildVcDelegate>

/** 预约id（只用于预约成功后，跳转到该页面使用）*/
@property (nonatomic, strong) NSString *appointmentNo;
/** blcok变量*/
@property (nonatomic, copy) cancelBlock block;

@end

//
//  TXAppointmentHeaderView.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXAppointmentDetailModel.h"

@interface TXAppointmentHeaderView : UIView

/** 预约详情model */
@property (strong, nonatomic) TXAppointmentDetailModel *appoinmentModel;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end

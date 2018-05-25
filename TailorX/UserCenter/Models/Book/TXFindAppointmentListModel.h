//
//  TXFindAppointmentListModel.h
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXFindAppointmentListModel : NSObject
/** 预约时间 时间戳*/
@property (nonatomic, assign) NSInteger appointmentTime;
/** 预约时间（格式化)*/
@property (nonatomic, strong) NSString * appointmentTimeStr;
/** 设计师名*/
@property (nonatomic, strong) NSString * designerName;
/** 设计师头像*/
@property (nonatomic, strong) NSString * designerPhoto;
/** 预约订单id*/
@property (nonatomic, assign) NSInteger ID;
/** 预约分类名（二级分类名*/
@property (nonatomic, strong) NSString * secondOrderCategoryName;
/** 商店名*/
@property (nonatomic, strong) NSString * storeName;

@property (nonatomic, assign) NSInteger status;



@end

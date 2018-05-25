//
//  TXAppointmentDetailTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXAppointmentDetailModel.h"

@interface TXAppointmentDetailTableViewCell : TXSeperateLineCell

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 模型*/
@property (nonatomic, strong) TXAppointmentDetailModel *model;


@end

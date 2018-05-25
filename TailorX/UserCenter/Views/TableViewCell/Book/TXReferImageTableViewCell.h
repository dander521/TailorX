//
//  TXReferImageTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXAppointmentDetailModel.h"
#import "TXAppointmentReferView.h"

@protocol TXReferImageTableViewCellDelegate <NSObject>

- (void)tapImageViewWithIndex:(NSUInteger)index;

@end

@interface TXReferImageTableViewCell : TXSeperateLineCell

/** 预约详情model */
@property (strong, nonatomic) TXAppointmentDetailModel *appoinmentModel;
/** 代理 */
@property (nonatomic, assign) id <TXReferImageTableViewCellDelegate> delegate;

@property (weak, nonatomic) TXAppointmentReferView *firstImageView;
@property (weak, nonatomic) TXAppointmentReferView *secondImageView;
@property (weak, nonatomic) TXAppointmentReferView *thirdImageView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

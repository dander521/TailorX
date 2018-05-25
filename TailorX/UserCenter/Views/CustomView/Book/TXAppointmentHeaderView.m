//
//  TXAppointmentHeaderView.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAppointmentHeaderView.h"

@interface TXAppointmentHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *cancelResonLabel;


@end

@implementation TXAppointmentHeaderView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setAppoinmentModel:(TXAppointmentDetailModel *)appoinmentModel {
    _appoinmentModel = appoinmentModel;
    
    if (appoinmentModel.status == 10) {
        self.statusLabel.text = self.appoinmentModel.cancelType == 1 ? @"定制已取消(自己)" : @"定制已取消(门店)";
        self.markImageView.image = self.appoinmentModel.cancelType == 1 ? [UIImage imageNamed:@"ic_main_username_zhan"] : [UIImage imageNamed:@"ic_zmain_stores"];
        self.cancelResonLabel.text = [NSString stringWithFormat:@"您支付的%0.2f元定金已全额退回",appoinmentModel.deposit];
    }else {
        self.statusLabel.text = @"预约成功";
        self.markImageView.image = [UIImage imageNamed:@"ic_xmain_success"];
        self.cancelResonLabel.text = [NSString stringWithFormat:@"已支付定金%0.2f元，取消预约可全额退款",appoinmentModel.deposit];
    }
}

@end

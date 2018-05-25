//
//  TXAppointmentDetailTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAppointmentDetailTableViewCell.h"

@interface TXAppointmentDetailTableViewCell ()

/** 订单编号*/
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
/** 门店*/
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
/** 门店地址*/
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;
/** 设计师*/
@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;
/** 到店时间*/
@property (weak, nonatomic) IBOutlet UILabel *appointmentTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *designerView;

@end

@implementation TXAppointmentDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXAppointmentDetailTableViewCell";
    TXAppointmentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(TXAppointmentDetailModel *)model {
    _model = model;
    
    self.orderNoLabel.text = [NSString isTextEmpty:model.orderNo]==YES ? @"" : model.orderNo;
    
    self.storeNameLabel.text = [NSString isTextEmpty:model.storeName]==YES ? @"" : model.storeName;
    
    self.storeAddressLabel.text = [NSString isTextEmpty:model.storeAddress]==YES ? @"" : model.storeAddress;
    
    self.designerView.hidden = [NSString isTextEmpty:model.designerName];
    self.designerNameLabel.text = [NSString isTextEmpty:model.designerName]==YES ? @"" : model.designerName;
    
    self.appointmentTimeLabel.text = [NSString isTextEmpty:model.appointmentTime]==YES ? @"" : model.appointmentTime;
}

@end

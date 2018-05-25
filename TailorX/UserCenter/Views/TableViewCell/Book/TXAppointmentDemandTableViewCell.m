//
//  TXAppointmentDemandTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/9/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAppointmentDemandTableViewCell.h"

@implementation TXAppointmentDemandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXAppointmentDemandTableViewCell";
    TXAppointmentDemandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    return cell;
}


@end

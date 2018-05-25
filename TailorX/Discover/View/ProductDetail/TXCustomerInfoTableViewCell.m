//
//  TXCustomerInfoTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCustomerInfoTableViewCell.h"

@interface TXCustomerInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *customerImageView;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel;

@end

@implementation TXCustomerInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TXProductDetailModel *)model {
    _model = model;
    
    [self.customerImageView sd_small_setImageWithURL:[NSURL URLWithString:model.customerPhoto] imageViewWidth:0 placeholderImage:[UIImage imageNamed:@"ic_main_user_3.3.0"]];
    
    self.customerName.text = model.customerName;
    self.appointTimeLabel.text = [NSString stringWithFormat:@"定制时间：%@", model.createDateStr];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXCustomerInfoTableViewCell";
    TXCustomerInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end

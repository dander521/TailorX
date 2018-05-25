//
//  TXOrderHeaderTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/26.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXOrderHeaderTableViewCell.h"

@implementation TXOrderHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.cornerRadius = 50.0;
    self.headerImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeaderType:(TXOrderCellHeaderType)headerType {
    _headerType = headerType;
    UIImage *headerImage = nil;
    NSString *status = nil;
    switch (headerType) {
        case TXOrderCellHeaderTypeInProduct: {
            headerImage = [UIImage imageNamed:@"ic_main_produce"];
            status = @"生产中";
            [self.queueNoLabel removeFromSuperview];
        }
            break;
            
        case TXOrderCellHeaderTypeInQueue: {
            headerImage = [UIImage imageNamed:@"ic_main_number"];
            status = @"排队中";
        }
            break;
            
        case TXOrderCellHeaderTypeForComment: {
            headerImage = [UIImage imageNamed:@"shareLogo"];
            status = @"交易成功";
            [self.queueNoLabel removeFromSuperview];
        }
            break;
            
        case TXOrderCellHeaderTypeForReceive: {
            headerImage = [UIImage imageNamed:@"ic_main_receipt"];
            status = @"待收货";
            [self.queueNoLabel removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
    
    self.headerImageView.image = headerImage;
    self.headerStatusLabel.text = status;
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXOrderHeaderTableViewCell";
    TXOrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end

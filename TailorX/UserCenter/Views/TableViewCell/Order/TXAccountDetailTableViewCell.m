//
//  TXAccountDetailTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/26.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAccountDetailTableViewCell.h"

@implementation TXAccountDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(TXAccountDetailTableViewCellType)cellType {
    _cellType = cellType;
    if (cellType == TXAccountDetailTableViewCellTypeInvalid) {
        [self.midLineLabel removeFromSuperview];
        [self.actualLabel removeFromSuperview];
        [self.actualDesLabel removeFromSuperview];
        self.depositLabel.text = @"已退定金";
    } else {
        self.depositLabel.text = @"已付定金";
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXAccountDetailTableViewCell";
    TXAccountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end

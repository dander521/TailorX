//
//  TXAvatarTableViewCell.m
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAvatarTableViewCell.h"

@implementation TXAvatarTableViewCell

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
    static NSString *cellID = @"TXAvatarTableViewCell";
    TXAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
        
    }
    
    return cell;
}


@end

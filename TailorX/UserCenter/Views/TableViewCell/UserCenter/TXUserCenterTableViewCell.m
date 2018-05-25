//
//  UserCenterTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 16/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXUserCenterTableViewCell.h"

@implementation TXUserCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXUserCenterTableViewCell";
    TXUserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TXUserCenterTableViewCell class]) owner:self options:nil] lastObject];
        
    }
    return cell;
}

/**
 *  配置cell
 */
- (void)configCellWithIndexPath:(NSIndexPath *)indexPath cellArray:(NSArray *)cellArray {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cellLabel.text = [cellArray firstObject][indexPath.row];
    self.iconImageView.image = [UIImage imageNamed:[cellArray lastObject][indexPath.row]];
}

@end

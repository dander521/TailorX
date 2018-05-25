//
//  TXPersonalMinusMarginTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPersonalMinusMarginTableViewCell.h"

@implementation TXPersonalMinusMarginTableViewCell

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
    static NSString *cellID = @"TXPersonalMinusMarginTableViewCell";
    TXPersonalMinusMarginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

/**
 设置cell内容
 
 @param content cellLabel内容
 @param detailContent cellDetailLabel内容
 */
- (void)configPersonalInfoCellWithContent:(NSString *)content detailContent:(NSString *)detailContent {
    self.cellTitleLabel.text = content;
    self.cellDetailLabel.text = detailContent;
}

/**
 设置titleLabel显示
 
 @param font 字体
 @param color 颜色
 */
- (void)customTitleLabelWithFont:(UIFont *)font color:(UIColor *)color {
    self.cellTitleLabel.textColor = color;
    self.cellTitleLabel.font = font;
}

/**
 设置detailLabel显示
 
 @param font 字体
 @param color 颜色
 */
- (void)customDetailTitleLabelWithFont:(UIFont *)font color:(UIColor *)color {
    self.cellDetailLabel.textColor = color;
    self.cellDetailLabel.font = font;
}

@end

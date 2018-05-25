//
//  TXPersonalMinusMarginTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXPersonalMinusMarginTableViewCell : TXSeperateLineCell

/**
 cell 文字
 */
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

/**
 cell 详细描述
 */
@property (weak, nonatomic) IBOutlet UILabel *cellDetailLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 设置cell内容
 
 @param content cellLabel内容
 @param detailContent cellDetailLabel内容
 */
- (void)configPersonalInfoCellWithContent:(NSString *)content detailContent:(NSString *)detailContent;

/**
 设置titleLabel显示

 @param font 字体
 @param color 颜色
 */
- (void)customTitleLabelWithFont:(UIFont *)font color:(UIColor *)color;

/**
 设置detailLabel显示
 
 @param font 字体
 @param color 颜色
 */
- (void)customDetailTitleLabelWithFont:(UIFont *)font color:(UIColor *)color;

@end

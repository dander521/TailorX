//
//  UserCenterTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 16/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXUserCenterTableViewCell : TXSeperateLineCell

/**
 logo
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/**
 text
 */
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  配置cell
 */
- (void)configCellWithIndexPath:(NSIndexPath *)indexPath cellArray:(NSArray *)cellArray;

@end

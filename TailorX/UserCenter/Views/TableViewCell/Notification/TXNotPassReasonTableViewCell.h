//
//  TXNotPassReasonTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXNotPassReasonTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

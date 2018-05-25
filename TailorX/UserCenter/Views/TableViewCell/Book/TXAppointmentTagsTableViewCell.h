//
//  TXAppointmentTagsTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/9/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXAppointmentTagsTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;


/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

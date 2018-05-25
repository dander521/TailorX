//
//  TXOrderCategoryTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXOrderCategoryTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

//
//  TXAvatarTableViewCell.h
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXAvatarTableViewCell : TXSeperateLineCell

/**
 cell 文字
 */
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

/**
 用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

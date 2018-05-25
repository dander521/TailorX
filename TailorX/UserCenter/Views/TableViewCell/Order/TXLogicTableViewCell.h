//
//  TXLogicTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXLogicTableViewCell : TXSeperateLineCell

/** 上线条 */
@property (weak, nonatomic) IBOutlet UILabel *topLineLabel;
/** 状态imageView */
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
/** 状态label */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/** 时间label */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 最上cell */
@property (nonatomic, assign) BOOL isTop;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

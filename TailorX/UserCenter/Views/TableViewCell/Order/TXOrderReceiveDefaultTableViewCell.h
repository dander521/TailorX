//
//  TXOrderReceiveDefaultTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXOrderReceiveDefaultTableViewCell : TXSeperateLineCell

/** 物流公司 */
@property (weak, nonatomic) IBOutlet UILabel *logisticCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticNoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logisticImageView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

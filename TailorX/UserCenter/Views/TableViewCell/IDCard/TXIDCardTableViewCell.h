//
//  TXIDCardTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXIDCardTableViewCell : TXSeperateLineCell

/** 证件图 */
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

/** 证件图 */
@property (weak, nonatomic) IBOutlet UILabel *sateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardDesLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

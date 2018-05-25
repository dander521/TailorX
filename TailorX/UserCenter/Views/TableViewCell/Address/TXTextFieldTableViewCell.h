//
//  TXTextFieldTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXAddressModel.h"

@interface TXTextFieldTableViewCell : TXSeperateLineCell

/** textfield */
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

/**
 *  配置tableViewCell
 */
- (void)configTableViewCellWithIndexPath:(NSIndexPath *)indexPath addressModel:(TXAddressModel *)address;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

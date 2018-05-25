//
//  TXLogicInfoTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXLogicInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *logicCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *logicTransNoLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

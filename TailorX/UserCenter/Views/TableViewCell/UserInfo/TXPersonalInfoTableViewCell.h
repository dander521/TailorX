//
//  TXPersonalInfoTableViewCell.h
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXPersonalInfoTableViewCell : TXSeperateLineCell

/**
 cell 文字
 */
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

/**
 cell 详细描述
 */
@property (weak, nonatomic) IBOutlet UILabel *cellDetailLabel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 设置cell内容

 @param content cellLabel内容
 @param detailContent cellDetailLabel内容
 */
- (void)configPersonalInfoCellWithContent:(NSString *)content detailContent:(NSString *)detailContent;

@end

//
//  TXProductDesignerTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/11/9.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXProductDetailModel.h"

@interface TXProductDesignerTableViewCell : TXSeperateLineCell


@property (nonatomic, strong) TXProductDetailModel *model;
/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

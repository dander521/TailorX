//
//  TXTransDetailCell.h
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXTransactionRecordModel;
@interface TXTransDetailCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TXTransactionRecordModel *data;

@end

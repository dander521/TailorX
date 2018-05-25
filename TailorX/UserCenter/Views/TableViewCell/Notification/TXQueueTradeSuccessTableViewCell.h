//
//  TXQueueTradeSuccessTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXQueueTradeSuccessModel.h"

@interface TXQueueTradeSuccessTableViewCell : TXSeperateLineCell

/** 交易排号成功模型 */
@property (nonatomic, strong) TXQueueTradeSuccessModel *queueModel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

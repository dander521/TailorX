//
//  TXTransRecordCell.h
//  TailorX
//
//  Created by liuyanming on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFindRecordListModel.h"

@interface TXTransRecordCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TXFindRecordModel *data;

@end

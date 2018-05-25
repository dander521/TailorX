//
//  TXPayNoCell.h
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXQueueNoModel.h"

@interface TXPayNoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet ThemeImageView *selectImgView;

@property (nonatomic, strong) TXQueueNoModel *data;

@end

//
//  TXProductProgressTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 21/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCustomProgressView.h"

@interface TXProductProgressTableViewCell : UITableViewCell

/** 生产进度view */
@property (weak, nonatomic) IBOutlet UIView *productProgressView;
/** 预估完成时间 */
@property (weak, nonatomic) IBOutlet UILabel *estimateTimeLabel;
/** 自定义进度view */
@property (nonatomic, strong) TXCustomProgressView *customProgressView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

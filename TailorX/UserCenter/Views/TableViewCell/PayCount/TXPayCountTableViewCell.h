//
//  TXPayCountTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 21/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 订单支付方式
 */
typedef NS_ENUM(NSUInteger, TXPayCountTableViewCellType) {
    TXPayCountTableViewCellTypeInvalide, /**< 失效 */
    TXPayCountTableViewCellTypeValide /**< 有效 */
};

@interface TXPayCountTableViewCell : TXSeperateLineCell

/** 订单创建时间 */
@property (nonatomic, assign) int orderCreatTime;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
/** cell type */
@property (nonatomic, assign) TXPayCountTableViewCellType cellType;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

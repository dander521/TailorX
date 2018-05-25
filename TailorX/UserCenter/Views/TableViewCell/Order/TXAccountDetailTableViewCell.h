//
//  TXAccountDetailTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/26.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 订单支付方式
 */
typedef NS_ENUM(NSUInteger, TXAccountDetailTableViewCellType) {
    TXAccountDetailTableViewCellTypeValid, /**< 有效 */
    TXAccountDetailTableViewCellTypeInvalid /**< 失效 */
};

@interface TXAccountDetailTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLineLabel;
@property (weak, nonatomic) IBOutlet UIView *actualDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *topDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payOriginPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *payOriginLineLabel;

/** cellType */
@property (nonatomic, assign) TXAccountDetailTableViewCellType cellType;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

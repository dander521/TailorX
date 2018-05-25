//
//  TXDesignerListTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/8/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXDesignerListModel.h"

/**
 订单支付方式
 */
typedef NS_ENUM(NSUInteger, TXDesignerOrderType) {
    TXDesignerOrderTypeRecommand = 1, /**< 推荐 */
    TXDesignerOrderTypeLike = 2, /**< 好评 */
    TXDesignerOrderTypeFavorite = 3 /**< 人气 */
};

@interface TXDesignerListTableViewCell : UITableViewCell

/** 设计师模型 */
@property (nonatomic, strong) TXDesignerListModel *designerModel;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

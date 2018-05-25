//
//  TXOrderHeaderTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/26.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 服务器参数类别枚举
 */
typedef NS_ENUM(NSUInteger, TXOrderCellHeaderType) {
    TXOrderCellHeaderTypeInQueue, /**< 排队中 */
    TXOrderCellHeaderTypeInProduct, /**< 生产中 */
    TXOrderCellHeaderTypeForReceive, /**< 待收货 */
    TXOrderCellHeaderTypeForComment /**< 待评论 */
};

@interface TXOrderHeaderTableViewCell : TXSeperateLineCell

/** 头部类型 */
@property (nonatomic, assign) TXOrderCellHeaderType headerType;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *queueNoLabel;


/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

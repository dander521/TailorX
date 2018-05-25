//
//  TXCustomerShowTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXProductDetailModel.h"

@class TXCustomerShowTableViewCell;

@protocol TXCustomerShowTableViewCellDelegate <NSObject>

@optional

- (void)tapImageViewWithIndex:(NSUInteger)index photoArray:(NSArray *)photoArray cell:(TXCustomerShowTableViewCell *)cell;

@end


@interface TXCustomerShowTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

/** <#description#> */
@property (nonatomic, assign) id <TXCustomerShowTableViewCellDelegate> delegate;
/**  */
@property (nonatomic, strong) TXProductDetailModel *model;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

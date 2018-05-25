//
//  TXProgressNodeTabCell.h
//  Test
//
//  Created by Qian Shen on 25/7/17.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXProgressNodeModel.h"
@class TYAttributedLabel;
@class TXProgressNodeTabCell;

@protocol TTXProgressNodeTabCellDelegate <NSObject>

@optional

- (void)tapImageViewWithIndex:(NSUInteger)index photoArray:(NSArray *)photoArray cell:(TXProgressNodeTabCell *)cell;

@end

@interface TXProgressNodeTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TYAttributedLabel *contentLabel;
/** model*/
@property (nonatomic, strong) TXProgressNodeModel *model;
/** 判断是否为第一个cell*/
@property (nonatomic, assign) BOOL isFirst;
/** 代理 */
@property (nonatomic, assign) id<TTXProgressNodeTabCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

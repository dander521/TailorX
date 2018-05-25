//
//  TXStarRateTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@protocol TXStarRateTableViewCellProtocol <NSObject>


/**
 选择星级代理

 @param starView 星级view
 @param currentScore 星级数
 */
- (void)selectRatingView:(XHStarRateView *)starView score:(CGFloat)currentScore;

@end

@interface TXStarRateTableViewCell : TXSeperateLineCell <XHStarRateViewDelegate>

/** 描述 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
/** content view */
@property (weak, nonatomic) IBOutlet UIView *ratingView;
/** 星级view */
@property (strong, nonatomic) XHStarRateView *starView;
/** 评论描述状态 */
@property (weak, nonatomic) IBOutlet UILabel *commentStatusLabel;
/** 代理 */
@property (nonatomic, assign) id <TXStarRateTableViewCellProtocol> delegate;

@property (nonatomic, assign) CGFloat scoreSelected;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

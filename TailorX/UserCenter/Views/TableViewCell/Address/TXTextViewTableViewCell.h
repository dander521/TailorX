//
//  TXTextViewTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXAddressModel.h"

@protocol TXTextViewTableViewCellDelegate <NSObject>

/**
 *  点击默认按钮
 */
- (void)touchDefaultButton:(BOOL)isSelected;

@end

@interface TXTextViewTableViewCell : TXSeperateLineCell

/** 输入textView */
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
/** 默认按钮 */
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
/** 默认label */
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
/** 代理 */
@property (assign, nonatomic) id <TXTextViewTableViewCellDelegate> cellDelegate;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  配置tableViewCell
 */
- (void)configTableViewCellWithAddressModel:(TXAddressModel *)address;

@end

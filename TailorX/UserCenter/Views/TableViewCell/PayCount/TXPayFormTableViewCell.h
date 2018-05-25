//
//  TXPayFormTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 21/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXPayFormTableViewCellDelegate <NSObject>

/**
 点击支付方式
 */
- (void)touchPayFormButton;

@end

@interface TXPayFormTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 代理 */
@property (nonatomic, assign) id <TXPayFormTableViewCellDelegate> delegate;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

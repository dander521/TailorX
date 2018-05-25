//
//  TXModifySecretTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXModifySecretTableViewCell <NSObject>

- (void)endInputTextWithString:(NSString *)textContent textField:(UITextField *)textField;

@end

@interface TXModifySecretTableViewCell : TXSeperateLineCell

/** 描述 */
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
/** 输入框 */
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
/** 代理 */
@property (assign, nonatomic) id <TXModifySecretTableViewCell> delegate;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

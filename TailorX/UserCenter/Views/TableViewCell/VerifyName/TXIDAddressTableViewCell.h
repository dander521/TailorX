//
//  TXIDAddressTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXIDAddressTableViewCellDelegate <NSObject>

- (void)endInputTextView:(UITextView *)textView content:(NSString *)textContent;

@end

@interface TXIDAddressTableViewCell : TXSeperateLineCell

/** 证件地址 */
@property (weak, nonatomic) IBOutlet UITextView *cardIDTextView;

@property (nonatomic, assign) id <TXIDAddressTableViewCellDelegate> delegate;
/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

//
//  TXCommentTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TXCommentTableViewCell : TXSeperateLineCell



/** 输入textView */
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
/** 字数 */
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;



/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

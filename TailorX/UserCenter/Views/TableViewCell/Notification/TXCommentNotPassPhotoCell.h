//
//  TXCommentNotPassPhotoCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXCommentNotPassPhotoCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UILabel *orderDesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

//
//  TXProductImageTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXProductImageTableViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) NSString *imageUrl;
/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

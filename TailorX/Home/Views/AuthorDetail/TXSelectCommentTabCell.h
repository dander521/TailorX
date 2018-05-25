//
//  TXSelectCommentTabCell.h
//  TailorX
//
//  Created by Qian Shen on 12/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXSelectCommentTabCell : UITableViewCell

/** 评论量*/
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

- (void)showSubViews:(BOOL)isShow;

@end

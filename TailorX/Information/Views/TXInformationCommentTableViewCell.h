//
//  TXInformationCommentTableViewCell.h
//  TailorX
//
//  Created by 温强 on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXInformationCommetModel.h"

@interface TXInformationCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (nonatomic, strong) TXInformationCommetModel *model;

@end

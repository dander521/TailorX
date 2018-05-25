//
//  TXBodyDataTabCell.h
//  TailorX
//
//  Created by Qian Shen on 11/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBodyDataModel.h"

@interface TXBodyDataTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

/** 模型*/
@property (nonatomic, strong) TXBodyDataModel *model;

@end

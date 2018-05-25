//
//  TXInfomationDescTabCell.h
//  TailorX
//
//  Created by Qian Shen on 27/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXInformationDetailModel.h"

@interface TXInfomationDescTabCell : UITableViewCell

@property (nonatomic, strong) TXInformationDetailModel *model;
/** 收藏设计按钮*/
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
/** 点击头衔*/
@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@end

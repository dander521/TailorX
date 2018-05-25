//
//  TXSelectDesignerTabCell.h
//  TailorX
//
//  Created by Qian Shen on 6/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXGetStoreDesignerListModel.h"

@interface TXSelectDesignerTabCell : UITableViewCell
/** 底部分割线*/
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/** model*/
@property (nonatomic, strong) TXGetStoreDesignerListModel *model;


@end

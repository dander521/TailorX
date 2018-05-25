//
//  TXStoreListCell.h
//  TailorX
//
//  Created by 温强 on 2017/4/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXStroeListModel.h"

@interface TXStoreListCell : UITableViewCell

@property (nonatomic, copy) NSArray *storeListDataAry;

@property (nonatomic, strong) TXStroeListModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *facadeImageView;

@end

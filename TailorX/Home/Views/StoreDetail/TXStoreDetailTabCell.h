//
//  TXStoreDetailTabCell.h
//  TailorX
//
//  Created by Qian Shen on 16/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXStoreDetailModel.h"

@protocol TXStoreDetailTabCellDelegate <NSObject>

- (void)touchAddressButton;

@end

@interface TXStoreDetailTabCell : UITableViewCell

/** <#description#> */
@property (nonatomic, weak) id <TXStoreDetailTabCellDelegate> delegate;
/** 数据模型*/
@property (nonatomic, strong) TXStoreDetailModel *model;
/** 拨打门店电话*/
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
/** 入驻设计师数量*/
@property (weak, nonatomic) IBOutlet UILabel *inDesignerNumLabel;


@end

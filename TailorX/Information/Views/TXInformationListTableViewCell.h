//
//  TXInformationListTableViewCell.h
//  TailorX
//
//  Created by 温强 on 2017/4/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXInformationListModel.h"
@class TXInformationListTableViewCell;

@protocol TXInformationListTableViewCellDelegate <NSObject>

- (void)informationListTableViewCell:(TXInformationListTableViewCell*)cell clickPopularityNumBtn:(UIButton*)sender ofIndex:(NSInteger)index;

@end

@interface TXInformationListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *islikedImageView;

@property (nonatomic, strong) TXInformationListModel *model;

/** 代理*/
@property (nonatomic, weak) id<TXInformationListTableViewCellDelegate> delegate;
/** cell所在的位置*/
@property (nonatomic, assign) NSInteger index;

@end

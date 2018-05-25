//
//  TXQueueNoCell.h
//  TailorX
//
//  Created by liuyanming on 2017/3/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TXQueueNoCellBtnType) {
    TXQueueNoCellBtnTypeCancel, // 取消
    TXQueueNoCellBtnTypeTrans, // 转让
    TXQueueNoCellBtnTypepay, // 购买
};

typedef NS_ENUM(NSUInteger, TXQueueNoCellType) {
    TXQueueNoCellTypeMyNum, //我的排号
    TXQueueNoCellTypeTransNum, // 排号交易
};

@class TXQueueNoCell;
@class TXQueueNoModel;

@protocol TXQueueNoCellDelegate <NSObject>

@optional
- (void)cellOfButtonClick:(TXQueueNoCell *)cell senderType:(TXQueueNoCellBtnType)senderType;

@end

@interface TXQueueNoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<TXQueueNoCellDelegate> delegate;

@property (nonatomic, assign) TXQueueNoCellType cellType;

@property (nonatomic, strong) TXQueueNoModel* data;


@end

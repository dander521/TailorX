//
//  TXPayNoView.h
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXQueueNoModel.h"

@protocol TXPayNoViewDelegate <NSObject>

@optional
- (void)payForButtonAction:(TXQueueNoModel *)selectData;

@end

@interface TXPayNoView : UIView

+ (instancetype)instanse;

@property (nonatomic, strong) TXQueueNoModel *data;

@property (nonatomic, weak) id<TXPayNoViewDelegate> delegate;

@end

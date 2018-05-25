//
//  TXMyQueueNoController.h
//  TailorX
//
//  Created by liuyanming on 2017/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZJScrollPageViewDelegate.h"

@interface TXMyQueueNoController : TXBaseViewController <ZJScrollPageViewChildVcDelegate>

// 程荣刚：2017-3-23 2:54 添加该bool值用于订单排队中页面 加速生产 跳转 解决页面布局 底部白边问题
/** 是否加速生产 */
@property (nonatomic, assign) BOOL isQuickProduce;

@end

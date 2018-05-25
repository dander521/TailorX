//
//  TXPayNoController.h
//  TailorX
//
//  Created by liuyanming on 2017/3/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"
#import "TXQueueNoModel.h"


@interface TXPayNoController : TXBaseViewController

// 生成排号交易订单，跳转到支付界面前调用，检查购买状态,添加购买记录
@property (nonatomic, assign) NSInteger recordId;

@property (nonatomic, strong) TXQueueNoModel *data;

// 返回到交易列表需要刷新数据
@property (nonatomic, copy) void(^popBlock)();

@end

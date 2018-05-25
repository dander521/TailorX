//
//  TXNotificationCell.h
//  TailorX
//
//  Created by Qian Shen on 23/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXGetMsgModel.h"

/**
 订单运送方式
 */
typedef NS_ENUM(NSUInteger, TXMessageStatus) {
    TXMessageStatusPaySuccess = 1, /**< 支付成功 */
    TXMessageStatusQueueTradeSuccess, /**< 排号交易成功 */
    TXMessageStatusCommentNotPass, /**< 评论未通过 */
    TXMessageStatusOrderForReceive, /**< 订单待收货 */
    TXMessageStatusAppointmentRemind, /**< 预约提醒 */
    TXMessageStatusCancelAppointment, /**< 取消预约 */
    TXMessageStatusForPay, /**< 待付款 */
    TXMessageStatusUploadDesignPaper, /**< 设计稿上传 */
    TXMessageStatusFactoryInWork, /**< 工厂进入生产 */
    TXMessageStatusWorkDone, /**< 生产完成 */
    TXMessageStatusStoreCheckPass, /**< 门店验收通过 */
    TXMessageStatusStoreSendProduct /**< 门店发货 */
};

@interface TXNotificationCell : TXSeperateLineCell

/** model*/
@property (nonatomic, strong) TXGetMsgModel       *model;
/** 底部分割线*/
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

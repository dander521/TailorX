//
//  TXNotificationCell.m
//  TailorX
//
//  Created by Qian Shen on 23/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXNotificationCell.h"

@interface TXNotificationCell ()


/** 消息内容*/
@property (weak, nonatomic) IBOutlet UILabel *contentsLabel;

@property (weak, nonatomic) IBOutlet UIView  *dotView;
/** 创建时间*/
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 通知类型*/
@property (weak, nonatomic) IBOutlet UILabel *msgStatusLabel;


@end

@implementation TXNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TXGetMsgModel *)model {
    _model = model;
    // 已读
    if (model.status == 1) {
        self.contentsLabel.textColor = RGB(153, 153, 153);
        self.dotView.hidden = YES;
    }
    // 未读
    else if (model.status == 0) {
        self.contentsLabel.textColor = RGB(76, 76, 76);
        self.dotView.hidden = NO;
    }
    // 删除
    else {
        
    }
    
    NSString *msgStatus = nil;
    switch ([model.contentType integerValue]) {
        case TXMessageStatusPaySuccess: {
            msgStatus = @"支付成功";
        }
            break;
            
        case TXMessageStatusCommentNotPass: {
            msgStatus = @"评论未通过";
        }
            break;
            
        case TXMessageStatusOrderForReceive: {
            msgStatus = @"订单待收货";
        }
            break;
            
        case TXMessageStatusQueueTradeSuccess: {
            msgStatus = @"排号交易成功";
        }
            break;
            
        case TXMessageStatusAppointmentRemind: {
            msgStatus = @"预约提醒";
        }
            break;
            
        case TXMessageStatusCancelAppointment: {
            msgStatus = @"取消预约";
        }
            break;
            
        case TXMessageStatusForPay: {
            msgStatus = @"待付款";
        }
            break;
            
        case TXMessageStatusUploadDesignPaper: {
            msgStatus = @"设计稿上传";
        }
            break;
            
        case TXMessageStatusFactoryInWork: {
            msgStatus = @"工厂进入生产";
        }
            break;
            
        case TXMessageStatusWorkDone: {
            msgStatus = @"生产完成";
        }
            break;
            
        case TXMessageStatusStoreCheckPass: {
            msgStatus = @"门店验收通过";
        }
            break;
            
        case TXMessageStatusStoreSendProduct: {
            msgStatus = @"门店发货";
        }
            break;

        default:
            break;
    }
    
    self.msgStatusLabel.text = msgStatus;
    if ([NSString isTextEmpty:model.content]) {
        self.contentsLabel.text = @"";
    }else {
        self.contentsLabel.text = model.content;
        // 调整行间距
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.content length])];
        self.contentsLabel.attributedText = attributedStr;
    }
    self.createTimeLabel.text = [self getDateStringWithDate:model.createTime DateFormat:@"yyyy-MM-dd HH:mm"];
}

/**
 * 将date时间戳转变成时间字符串
 */
- (NSString *)getDateStringWithDate:(NSUInteger)time
                         DateFormat:(NSString *)formatString
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatString];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

@end

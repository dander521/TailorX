//
//  TXOrderTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXOrderTableViewCell.h"

@interface TXOrderTableViewCell ()

@property (nonatomic, strong) TXOrderModel *orderModel;
@property (weak, nonatomic) IBOutlet UIImageView *depositImageView;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@end

@implementation TXOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dressPriceLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    // 为view上面的两个角做成圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.dressImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.dressImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.dressImageView.layer.mask = maskLayer;
    
    self.discountLabel.layer.cornerRadius = 2.23;
    self.discountLabel.layer.masksToBounds = true;
    self.discountLabel.layer.borderWidth = 0.56;
    self.discountLabel.layer.borderColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0].CGColor;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        [self.choiceButton setImage:[[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
    } else {
        [self.choiceButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    }
}

- (void)setCellType:(TXOrderStatus)cellType {
    _cellType = cellType;
    
    switch (cellType) {
        case TXOrderStatusForPay: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            self.dressQueueNoLabel.text = @"待付款";
            [self.choiceButton removeFromSuperview];
            [self.logisticButton removeFromSuperview];
            [self.actionButton setTitle:@"立即付款" forState:UIControlStateNormal];
        }
            break;
            
        case TXOrderStatusInQueue: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            self.dressQueueNoLabel.text = @"排队中";
            [self.choiceButton removeFromSuperview];
            [self.actionButton setTitle:@"加速生产" forState:UIControlStateNormal];
            [self.logisticButton removeFromSuperview];
        }
            break;
            
        case TXOrderStatusInProduct: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            self.dressQueueNoLabel.text = @"生产中";
            [self.choiceButton removeFromSuperview];
            [self.actionButton removeFromSuperview];
            [self.logisticButton removeFromSuperview];
        }
            break;
            
        case TXOrderStatusForReceiveWaitDeliver: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            [self.choiceButton removeFromSuperview];
            self.dressQueueNoLabel.text = @"待收货";
            [self.logisticButton removeFromSuperview];
            [self.actionButton removeFromSuperview];
        }
            break;

        case TXOrderStatusForComment: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            self.dressQueueNoLabel.text = @"交易成功";
            [self.choiceButton removeFromSuperview];
            [self.logisticButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.actionButton setTitle:@"评价晒单" forState:UIControlStateNormal];
            [self.processButton removeFromSuperview];
        }
            break;
            
        case TXOrderStatusCommented: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            self.dressQueueNoLabel.text = @"已完成";
            [self.choiceButton removeFromSuperview];
            [self.logisticButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.actionButton setTitle:@"评价详情" forState:UIControlStateNormal];
            [self.processButton removeFromSuperview];
        }
            break;
            
        case TXOrderStatusInvalidNoDeposit:
        case TXOrderStatusInvalidHasDeposit: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            [self.choiceButton removeFromSuperview];
            self.dressQueueNoLabel.text = @"已失效";
            self.dressQueueNoLabel.backgroundColor = RGB(245, 245, 245);
            self.dressQueueNoLabel.textColor = RGB(204, 204, 204);
            [self.logisticButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.actionButton removeFromSuperview];
            [self.processButton removeFromSuperview];
        }
            break;
            
        case TXOrderStatusAppointmentSuccess: {
            [self.choiceButton removeFromSuperview];
            self.dressQueueNoLabel.text = @"预约成功";
            self.depositLabel.text = @"定金";
            [self.actionButton setTitle:@"联系门店" forState:UIControlStateNormal];
            [self.logisticButton removeFromSuperview];
        }
            break;
            
        case TXOrderStatusAppointmentCancel: {
            [self.choiceButton removeFromSuperview];
            self.dressQueueNoLabel.text = @"已取消";
            self.depositLabel.text = @"定金";
            self.dressQueueNoLabel.backgroundColor = RGB(245, 245, 245);
            self.dressQueueNoLabel.textColor = RGB(204, 204, 204);
            [self.logisticButton setTitle:@"删除预约" forState:UIControlStateNormal];
            [self.actionButton removeFromSuperview];
            [self.processButton removeFromSuperview];
        }
            break;
            
        case TXOrderStatusForReceiveGetBySelf: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            [self.choiceButton removeFromSuperview];
            [self.logisticButton removeFromSuperview];
            self.dressQueueNoLabel.text = @"待收货";
            [self.actionButton setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
            
        case TXOrderStatusForReceiveDelivered: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            [self.choiceButton removeFromSuperview];
            self.dressQueueNoLabel.text = @"待收货";
            [self.actionButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.logisticButton setTitle:@"查看物流" forState:UIControlStateNormal];
        }
            break;

        case TXOrderStatusContactStore: {
            [self.depositLabel removeFromSuperview];
            [self.depositImageView removeFromSuperview];
            [self.choiceButton removeFromSuperview];
            [self.dressQueueNoLabel removeFromSuperview];
            [self.actionButton removeFromSuperview];
            [self.logisticButton removeFromSuperview];
            [self.processButton removeFromSuperview];
            self.contentView.backgroundColor = RGB(251, 251, 251);
        }
            break;

        default:
            break;
    }
    
    self.actionButton.borderColor = RGB(255, 51, 102);
    [self.actionButton setTitleColor:RGB(255, 51, 102) forState:UIControlStateNormal];
    self.logisticButton.borderColor = RGB(46, 46, 46);
    [self.logisticButton setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    self.processButton.borderColor = RGB(46, 46, 46);
    [self.processButton setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    self.logisticButton.layer.borderWidth = 0.6;
    self.actionButton.layer.borderWidth = 0.6;
    self.processButton.layer.borderWidth = 0.6;
    self.logisticButton.layer.cornerRadius = 2.0;
    self.actionButton.layer.cornerRadius = 2.0;
    self.processButton.layer.cornerRadius = 2.0;
    self.logisticButton.layer.masksToBounds = true;
    self.actionButton.layer.masksToBounds = true;
    self.processButton.layer.masksToBounds = true;
    
    if (cellType == TXOrderStatusInvalidNoDeposit ||
        cellType == TXOrderStatusInvalidHasDeposit ||
        cellType == TXOrderStatusAppointmentCancel ||
        cellType == TXOrderStatusForComment ||
        cellType == TXOrderStatusCommented) {
        self.logisticButton.borderColor = RGB(153, 153, 153);
        [self.logisticButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    }
    
    if (cellType == TXOrderStatusContactStore ||
        cellType == TXOrderStatusAppointmentSuccess ||
        cellType == TXOrderStatusCommented) {
        self.actionButton.borderColor = RGB(46, 46, 46);
        [self.actionButton setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXOrderTableViewCell";
    TXOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    cell.isSelected = false;
    
    return cell;
}

/**
 *  配置cell
 */
- (void)configOrderCellWithOrderModel:(TXOrderModel *)orderModel isAllOrderCell:(BOOL)isAllOrderCell {
    self.orderModel = orderModel;
    if ([orderModel.status integerValue] == 4) {
        if (orderModel.delivery == TXOrderDeliveryTypeGetSelf) {
            self.cellType = TXOrderStatusForReceiveGetBySelf;
        } else {
            self.cellType = TXOrderStatusForReceiveDelivered;
        }
    } else {
        self.cellType = [orderModel.status integerValue];
    }
    
    if ([NSString isTextEmpty:orderModel.discount]) {
        self.discountLabel.hidden = true;
    } else {
        self.discountLabel.hidden = false;
        float discountRate = [orderModel.discount floatValue] * 10.0;
        NSString *strDiscount = [NSString stringWithFormat:@"%.2f", discountRate];
        NSArray *arrTemp = [strDiscount componentsSeparatedByString:@"."];
        if ([arrTemp.lastObject integerValue] > 0) {
            self.discountLabel.text = [NSString stringWithFormat:@"  %.1f折  ", discountRate];
        } else {
            if ([arrTemp.firstObject integerValue] == 10) {
                self.discountLabel.hidden = true;
            } else {
                self.discountLabel.text = [NSString stringWithFormat:@"  %zd折  ", [arrTemp.firstObject integerValue]];
            }
        }
        
    }
    
    self.dressDescriptionLabel.text = [NSString isTextEmpty:orderModel.designerName] ? @"设计师：待指定" : [NSString stringWithFormat:@"设计师：%@", orderModel.designerName];
    
    NSMutableArray *temArray = [NSMutableArray new];
    if (orderModel.tagStrs && orderModel.tagStrs.count > 0) {
        for (int i = 0; i<orderModel.tagStrs.count; i++) {
            if (![NSString isTextEmpty:orderModel.tagStrs[i]]) {
                [temArray addObject:orderModel.tagStrs[i]];
            }
        }
    }
    
    self.dressCategoryLabel.text = temArray.count > 0 ? [NSString stringWithFormat:@"标签：%@", [temArray componentsJoinedByString:@"、"]] : @"标签：暂无标签";
    
    if ([orderModel.status integerValue] == TXOrderStatusAppointmentSuccess ||
        [orderModel.status integerValue] == TXOrderStatusAppointmentCancel) {
        self.dressPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", [orderModel.deposit floatValue]];
    } else {
        if ([NSString isTextEmpty:orderModel.discountPrice]) {
            
        }
        self.dressPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", [orderModel.totalAmount floatValue]];
    }
    
    [self.dressImageView sd_small_setImageWithURL:[NSURL URLWithString:orderModel.styleUrl] imageViewWidth:100 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    self.isSelected = orderModel.isSelected;
}

#pragma mark - Touch Metnod

- (IBAction)touchOrderCellButton:(id)sender {
    // 防止按钮重复点击 沈钱
    [sender setAcceptClickInterval:2];
    if ([self.delegate respondsToSelector:@selector(touchActionButtonWithOrder:)]) {
        [self.delegate touchActionButtonWithOrder:self.orderModel];
    }
}

- (IBAction)touchOrderChoiceButton:(id)sender {
    self.isSelected = !self.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(touchOrderTableViewCellButtonWithSelected:orderModel:)]) {
        [self.delegate touchOrderTableViewCellButtonWithSelected:self.isSelected orderModel:self.orderModel];
    }
}

- (IBAction)touchLogisticButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchLogisticButtonWithOrder:)]) {
        [self.delegate touchLogisticButtonWithOrder:self.orderModel];
    }
}

- (IBAction)touchProcessButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchProcessButtonWithOrder:)]) {
        [self.delegate touchProcessButtonWithOrder:self.orderModel];
    }
}



@end

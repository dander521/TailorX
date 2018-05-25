//
//  TXPayCountTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 21/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXPayCountTableViewCell.h"
#import "TXCountdownView.h"

@interface TXPayCountTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *countDownView;

@property (nonatomic, strong) TXCountdownView *customView;

@property (weak, nonatomic) IBOutlet UILabel *waitLabel;

@end

@implementation TXPayCountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.image = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_main_money_bag"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (TXCountdownView *)customView {
    if (!_customView) {
        _customView = [TXCountdownView setupTXCountdownView];
        _customView.frame = self.countDownView.bounds;
        [self.countDownView addSubview:_customView];
    }
    return _customView;
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXPayCountTableViewCell";
    TXPayCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TXPayCountTableViewCell class]) owner:self options:nil] lastObject];
        
    }
    
    return cell;
}

- (void)setCellType:(TXPayCountTableViewCellType)cellType {
    _cellType = cellType;
    if (cellType == TXPayCountTableViewCellTypeInvalide) {
        [self.customView updateUI];
        self.waitLabel.text = @"订单已失效";
        self.customView.descLabel.text = @"未在限定时间进行支付";
        self.customView.descLabel.textColor = RGB(153, 153, 153);
        self.headerImageView.image = [UIImage imageNamed:@"ic_main_money_bag_no"];
    }
}

- (void)setOrderCreatTime:(int)orderCreatTime {
    self.customView.reverseTime = orderCreatTime;
    [self.customView startTimeCompleteBlock:^{
        self.waitLabel.text = @"订单已失效";
        self.customView.descLabel.text = @"未在限定时间进行支付";
        self.customView.descLabel.textColor = RGB(153, 153, 153);
        self.headerImageView.image = [UIImage imageNamed:@"ic_main_money_bag_no"];
    }];
}

@end

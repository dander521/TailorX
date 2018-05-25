//
//  TXTransDetailCell.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTransDetailCell.h"
#import "TXTransactionRecordModel.h"



//rgb 80 210 194  绿色
//rgb 255 51 102  红色

@interface TXTransDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation TXTransDetailCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"transDetailCell";
    
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    return cell;
}


- (void)setData:(TXTransactionRecordModel *)data {
    _data = data;
    
    _orderLabel.text = data.name;
    _dateLabel.text = data.dateStr;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f", [data.amount floatValue]];
    
    if ([data.amount containsString:@"-"]) {
//        _moneyLabel.textColor = RGB(255, 51, 102);
        _moneyLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    }else  {
        _moneyLabel.text = [NSString stringWithFormat:@"+%.2f", [data.amount floatValue]];
        _moneyLabel.textColor = RGB(80, 210, 194);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _moneyLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
}


@end

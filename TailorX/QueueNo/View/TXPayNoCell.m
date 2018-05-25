//
//  TXPayNoCell.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPayNoCell.h"
#include "TXFontTool.h"

@interface TXPayNoCell ()

@property (weak, nonatomic) IBOutlet ThemeLabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation TXPayNoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PayNoCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numLabel.layer.cornerRadius = 32;
    _numLabel.cloName = @"theme_color";
}

- (void)setData:(TXQueueNoModel *)data {
    _data = data;
    NSString *num = [NSString stringWithFormat:@"%ld号", (long)data.sortNo];
    _numLabel.attributedText = [TXFontTool addFontAttribute:num minFont:MinFont number:1];
    _titleLabel.text = data.orderNo;
    _descLabel.text = [NSString isTextEmpty:data.categoryName] ? @"" : [NSString stringWithFormat:@"定制标签：%@", data.categoryName];
}

@end

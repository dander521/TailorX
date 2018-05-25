//
//  TXPersonalInfoTableViewCell.m
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPersonalInfoTableViewCell.h"

@implementation TXPersonalInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.cellDetailLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXPersonalInfoTableViewCell";
    TXPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

/**
 设置cell内容
 
 @param content cellLabel内容
 @param detailContent cellDetailLabel内容
 */
- (void)configPersonalInfoCellWithContent:(NSString *)content detailContent:(NSString *)detailContent {
    self.cellTitleLabel.text = content;

    if ([NSString isTextEmpty:detailContent]) {
        self.cellDetailLabel.text = @"";
    }else {
        self.cellDetailLabel.text = detailContent;
    }
}

@end

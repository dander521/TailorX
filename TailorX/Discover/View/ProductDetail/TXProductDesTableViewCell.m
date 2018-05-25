//
//  TXProductDesTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/9.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductDesTableViewCell.h"

@interface TXProductDesTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation TXProductDesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TXProductDetailModel *)model {
    _model = model;
    
    self.desLabel.text = model.title;
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXProductDesTableViewCell";
    TXProductDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end

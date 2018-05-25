//
//  TXPayFormTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 21/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXPayFormTableViewCell.h"

@implementation TXPayFormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        [self.choiceButton setImage:[UIImage imageNamed:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
    } else {
        [self.choiceButton setImage:[UIImage imageNamed:@"ic_mian_default_address"] forState:UIControlStateNormal];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXPayFormTableViewCell";
    TXPayFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TXPayFormTableViewCell class]) owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (IBAction)touchPayFormButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchPayFormButton)]) {
        [self.delegate touchPayFormButton];
    }
}

@end

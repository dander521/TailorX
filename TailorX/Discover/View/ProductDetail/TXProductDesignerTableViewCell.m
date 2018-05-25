//
//  TXProductDesignerTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/9.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductDesignerTableViewCell.h"

@interface TXProductDesignerTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation TXProductDesignerTableViewCell

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
    
    [self.avatarImageView sd_small_setImageWithURL:[NSURL URLWithString:model.designerPhoto] imageViewWidth:0 placeholderImage:[UIImage imageNamed:@"ic_main_user_3.3.0"]];
    
    self.nameLabel.text = model.designerName;
    self.desLabel.text = model.designerIntroduction;
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXProductDesignerTableViewCell";
    TXProductDesignerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end

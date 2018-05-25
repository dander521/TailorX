//
//  TXQueueTradeSuccessTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXQueueTradeSuccessTableViewCell.h"
#import "TXFontTool.h"

@interface TXQueueTradeSuccessTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *myNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *transNoLabel;

@end

@implementation TXQueueTradeSuccessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_myNoLabel circleLabelWithWithRoundedRect:CGRectMake(0, 0, 63, 63) cornerRadius:63*0.5];
    [_transNoLabel circleLabelWithWithRoundedRect:CGRectMake(0, 0, 63, 63) cornerRadius:63*0.5];
    
    _myNoLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    _transNoLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQueueModel:(TXQueueTradeSuccessModel *)queueModel {
    if (queueModel == nil) {
        return;
    }
    _queueModel = queueModel;
    
    NSString *myNum = [NSString stringWithFormat:@"%@号", queueModel.sortNoSale];
    self.myNoLabel.attributedText = [TXFontTool addFontAttribute:myNum minFont:LayoutF(14) number:1];
    
    NSString *transNum = [NSString stringWithFormat:@"%@号", queueModel.sortNoBuy];
    self.transNoLabel.attributedText = [TXFontTool addFontAttribute:transNum minFont:LayoutF(14) number:1];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXQueueTradeSuccessTableViewCell";
    TXQueueTradeSuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end

//  TXTransRecordCell.m
//  TailorX
//
//  Created by liuyanming on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTransRecordCell.h"
#import "TXFontTool.h"

@interface TXTransRecordCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLabelW;

/** 我的号 */
@property (weak, nonatomic) IBOutlet ThemeLabel *myNumLabel;
/** 交换的号 */
@property (weak, nonatomic) IBOutlet ThemeLabel *transNumLabel;
/** 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *tradeNoLabel;
/** 卖家 */
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;
/** 售价 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 交易状态 */
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
// TODO: 沈钱
/** 曲线（箭头） */
@property (weak, nonatomic) IBOutlet UIImageView *curveImgView;

@end

@implementation TXTransRecordCell


- (void)setData:(TXFindRecordModel *)data {
    _data = data;
    
    _tradeNoLabel.text = data.tradeNo;
    
    _sellerLabel.text = data.userName;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", data.amount];
    
    NSString *myNum = [NSString stringWithFormat:@"%ld号", (long)data.sortNoSale];
    self.myNumLabel.attributedText = [TXFontTool addFontAttribute:myNum minFont:LayoutF(13) number:1];
    
    // TODO: 沈钱
    if (data.sortNoBuy == 0) {
        self.curveImgView.hidden = YES;
        self.transNumLabel.hidden = YES;
    }else {
        self.curveImgView.hidden = NO;
        self.transNumLabel.hidden = NO;
        NSString *transNum = [NSString stringWithFormat:@"%ld号", (long)data.sortNoBuy];
        self.transNumLabel.attributedText = [TXFontTool addFontAttribute:transNum minFont:LayoutF(13) number:1];
    }
    
    // saleStatus-状态，0交易成功，1交易失败，2待付款
    if (data.saleStatus == 0) {
        _stateLabel.text = @"交易成功";
    }else if (data.saleStatus == 1) {
        _stateLabel.text = @"交易失败";
    }else if (data.saleStatus == 2) {
        _stateLabel.text = @"待付款";
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TransRecordCell";
    
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.myNumLabel circleLabelWithWithRoundedRect:CGRectMake(0, 0, 64, 64) cornerRadius:64*0.5];
    [self.transNumLabel circleLabelWithWithRoundedRect:CGRectMake(0, 0, 64, 64) cornerRadius:64*0.5];
    
    self.myNumLabel.font = LayoutF(25);
    self.transNumLabel.font = LayoutF(25);
    
    _myNumLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    _transNumLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    
    _priceLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
}

@end

//
//  TXWalletView.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXWalletView.h"

@interface TXWalletView ()

@property (weak, nonatomic) IBOutlet UIImageView *walletIcon;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *erningLabel;

@end

@implementation TXWalletView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _walletIcon.image = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_main_money_bag"];
    _erningLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
}

+ (instancetype)instanse {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}


- (IBAction)rechargeBtnClick:(UIButton *)sender {
    
    if (sender.tag == 1 && [_delegate respondsToSelector:@selector(rechargeBtnClick:)]) {
        [_delegate rechargeBtnClick:sender];
    }
    
    if (sender.tag == 2 && [_delegate respondsToSelector:@selector(withdrawBtnClick:)]) {
        [_delegate withdrawBtnClick:sender];
    }
    
    if (sender.tag == 3 && [_delegate respondsToSelector:@selector(erningBtnClick:)]) {
        [_delegate erningBtnClick:sender];
    }
}

- (void)setBalance:(NSString *)balance {
    _balance = balance;
    
    NSString *str = [NSString stringWithFormat:@"￥%.2f", [balance doubleValue]];
    
    NSString *str1 = [NSString stringWithFormat:@"余额:%@", str];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:str1];
    
    [str2 addAttribute:NSForegroundColorAttributeName value:[[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"] range:[str1 rangeOfString:str]];
    
    _balanceLabel.attributedText = str2;
    
}

- (void)setErning:(NSString *)erning {
    _erning = erning;
    
    _erningLabel.text = [NSString stringWithFormat:@"￥ %@", erning];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

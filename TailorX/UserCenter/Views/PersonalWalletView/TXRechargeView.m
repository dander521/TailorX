//
//  TXRechargeView.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXRechargeView.h"

@interface TXRechargeView () <UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation TXRechargeView

+ (instancetype)instanse {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView.delegate = self;
    self.textField.delegate = self;
    

    self.sureBtn.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];;
    self.rechargeMoneyLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];;
    
    if (self.textField.hasText) {
        self.rechargeMoneyLabel.text = [NSString stringWithFormat:@"￥%@", self.textField.text];
    }else {
        self.rechargeMoneyLabel.text = @"￥0.00";
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textField resignFirstResponder];
}
// textField输入金额的正则判断  不能以空格开头、0以后只能是小数点、最多2位小数  符合金钱的规则
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d*(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
    }
    self.rechargeMoneyLabel.text = toString;
    return YES;
}


// 确定
- (IBAction)sureBtnClick:(UIButton *)sender {
    if (!self.textField.hasText) {
        [ShowMessage showMessage:@"请输入金额" withCenter:self.center];
    }else {
        if ([_delegate respondsToSelector:@selector(rechargeViewSureBtnClick:)]) {
            [_delegate rechargeViewSureBtnClick:sender];
        }
    }
}


@end

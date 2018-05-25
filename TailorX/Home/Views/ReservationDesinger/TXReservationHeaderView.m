//
//  TXReservationHeaderView.m
//  TailorX
//
//  Created by Qian Shen on 14/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXReservationHeaderView.h"

@implementation TXReservationHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.switchDesignerBtn.layer.shadowOffset = CGSizeMake(1, 1);
    self.switchDesignerBtn.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.switchDesignerBtn.layer.shadowOpacity = 0.5;
    if (!self.msgTextView.hasText) {
        [self.msgTextView addPlaceholderWithText:@"请初步描述一下你定制服装的需求~" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14.f]];
    }
    self.msgTextView.delegate = self;
    self.msgTextView.tintColor = RGB(46, 46, 46);
    self.msgTextView.contentInset = UIEdgeInsetsMake(0, 0, 16, 0);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
}

- (void)textViewDidChange:(UITextView *)textView {
    [UIView textView:_msgTextView maxLength:200 showEmoji:false];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 文本内容
    NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else if (newStr.length > 200) {
        [ShowMessage showMessage:@"输入内容要在200字以内哦！"];
        return NO;
    }else {
        self.limitLabel.text = [NSString stringWithFormat:@"%zd/200",newStr.length];
        [self settingLimitLabelOfText:_limitLabel];
        return YES;
    }
    
}

#pragma mark - methods

- (void)settingLimitLabelOfText:(UILabel*)label {
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:label.text];
    [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(label.text.length-4,4)];
    [aString addAttribute:NSForegroundColorAttributeName value:RGB(193, 193, 193) range:NSMakeRange(label.text.length-4,4)];
    label.attributedText = aString;
}


@end

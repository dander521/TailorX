//
//  TXIDAddressTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXIDAddressTableViewCell.h"

@interface TXIDAddressTableViewCell ()<UITextViewDelegate>

@end

@implementation TXIDAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.cardIDTextView addPlaceholderWithText:LocalSTR(@"Prompt_InputIDAddress")
                                      textColor:[UIColor lightGrayColor]
                                           font:[UIFont systemFontOfSize:14.f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXIDAddressTableViewCell";
    TXIDAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(endInputTextView:content:)]) {
        [self.delegate endInputTextView:textView content:textView.text];
    }
    return YES;
}

@end

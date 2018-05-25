//
//  TXModifySecretTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXModifySecretTableViewCell.h"

@interface TXModifySecretTableViewCell ()<UITextFieldDelegate>

@end

@implementation TXModifySecretTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXModifySecretTableViewCell";
    TXModifySecretTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(endInputTextWithString:textField:)]) {
        [self.delegate endInputTextWithString:textField.text textField:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end

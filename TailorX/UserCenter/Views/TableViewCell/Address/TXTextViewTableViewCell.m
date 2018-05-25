//
//  TXTextViewTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXTextViewTableViewCell.h"

@interface TXTextViewTableViewCell ()

/** 地址对象 */
@property (nonatomic, strong) TXAddressModel *cellAddress;

@end

@implementation TXTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentTextView addPlaceholderWithText:@"详细地址"
                                     textColor:RGB(153, 153, 153)
                                          font:[UIFont systemFontOfSize:15.f]];
    self.defaultLabel.text = LocalSTR(@"Str_DefaultAdd");
    [self.defaultButton addTarget:self action:@selector(touchDefaultButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        [self.defaultButton setImage:[[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"]forState:UIControlStateNormal];
    } else {
        [self.defaultButton setImage:[UIImage imageNamed:@"ic_mian_default_address"] forState:UIControlStateNormal];
    }
}

- (void)touchDefaultButton:(id)sender {
    self.isSelected = !self.isSelected;
    
    if ([self.cellDelegate respondsToSelector:@selector(touchDefaultButton:)]) {
        [self.cellDelegate touchDefaultButton:self.isSelected];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXTextViewTableViewCell";
    TXTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
        
    }
    
    return cell;
}

/**
 *  配置tableViewCell
 */
- (void)configTableViewCellWithAddressModel:(TXAddressModel *)address {
    self.cellAddress = address;
    self.contentTextView.text = address.address;
    self.isSelected = address.isDefault;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.cellAddress.address = textView.text;
    return YES;
}

@end

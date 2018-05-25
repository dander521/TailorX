//
//  TXTextFieldTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXTextFieldTableViewCell.h"

@interface TXTextFieldTableViewCell ()<UITextFieldDelegate>

/** 地址对象 */
@property (nonatomic, strong) TXAddressModel *cellAddress;

@end

@implementation TXTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  配置tableViewCell
 */
- (void)configTableViewCellWithIndexPath:(NSIndexPath *)indexPath addressModel:(TXAddressModel *)address {
    self.cellAddress = address;
    NSString *placeholderStr = nil;
    NSString *contentStr = nil;
    switch (indexPath.row) {
        case 0:
        {
            placeholderStr = LocalSTR(@"Str_Consignee");
            contentStr = address.name;
        }
            break;
            
        case 1:
        {
            placeholderStr = LocalSTR(@"Str_Telephone");
            contentStr = address.telephone;
        }
            break;
            
        case 2:
        {
            placeholderStr = LocalSTR(@"Str_AreaCode");
            contentStr = address.postcode;
        }
            break;
            
        case 3:
        {
            placeholderStr = LocalSTR(@"Str_Area");
            contentStr = address.provinceName == nil ? nil : [NSString stringWithFormat:@"%@/%@/%@", address.provinceName, address.cityName, address.districtName];
        }
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        self.contentTextField.keyboardType = UIKeyboardTypePhonePad;
    } else {
        self.contentTextField.keyboardType = UIKeyboardTypeDefault;
    }
    self.contentTextField.tag = 10000 + indexPath.row;
    self.contentTextField.delegate = self;
    self.contentTextField.placeholder = placeholderStr;
    [self.contentTextField setValue:RGB(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
    self.contentTextField.text = contentStr;
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXTextFieldTableViewCell";
    TXTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
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
    if (textField.tag == 10001 && range.location >= 11) {
        return NO;
    }
    
    if (textField.tag == 10002 && range.location >= 6) {
        return NO;
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag - 10000) {
        case 0: // 收货人姓名
        {
            self.cellAddress.name = textField.text;
        }
            break;
        case 1: // 联系电话
        {
            self.cellAddress.telephone = textField.text;
        }
            break;
        case 2: // 邮编
        {
            self.cellAddress.postcode = textField.text;
        }
            break;

        default:
            break;
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

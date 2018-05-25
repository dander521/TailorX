//
//  TXAddressTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXAddressTableViewCell.h"

@interface TXAddressTableViewCell ()

/** 支持动画变换view */
@property (weak, nonatomic) IBOutlet UIView *supportView;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation TXAddressTableViewCell

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
    static NSString *cellID = @"TXAddressTableViewCell";
    TXAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}


- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        [self.defaultButton setImage:[[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"]forState:UIControlStateNormal];
    } else {
        [self.defaultButton setImage:[UIImage imageNamed:@"ic_mian_default_address"] forState:UIControlStateNormal];
    }
}

- (IBAction)touchDefaultAddressButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectDefaultAddressButtonWithAddress:)]) {
        [self.delegate selectDefaultAddressButtonWithAddress:self.address];
    }
}

- (IBAction)touchEditButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectEditAddressButtonWithAddress:)]) {
        [self.delegate selectEditAddressButtonWithAddress:self.address];
    }
}

- (IBAction)touchDeleteButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectDeleteAddressButtonWithAddress:)]) {
        [self.delegate selectDeleteAddressButtonWithAddress:self.address];
    }
}

- (void)setCellType:(TXAddressType)cellType {
    _cellType = cellType;
    switch (cellType) {
        case TXAddressTypeEdit: {
            self.deleteButton.hidden = false;
            self.editButton.hidden = false;
            self.defaultLabel.hidden = false;
            self.defaultButton.hidden = false;
        }
            break;
            
        case TXAddressTypeDefault: {
            self.deleteButton.hidden = true;
            self.editButton.hidden = true;
            self.defaultLabel.hidden = true;
            self.defaultButton.hidden = true;
            [self.supportView removeFromSuperview];
        }
            break;
            
        case TXAddressTypeOnlyStoreAddress: {
            self.deleteButton.hidden = true;
            self.editButton.hidden = true;
            self.defaultLabel.hidden = true;
            self.defaultButton.hidden = true;
            [self.supportView removeFromSuperview];
            [self.phoneImageView removeFromSuperview];
            [self.nameImageView removeFromSuperview];
            [self.nameLabel removeFromSuperview];
            [self.numberLabel removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}

/**
 配置地址
 
 @param address
 */
- (void)configAddressWithModel:(TXAddressModel *)address {
    self.address = address;
    self.nameLabel.text = address.name;
    self.numberLabel.text = [NSString seperateTelephoneString:address.telephone];
    self.isSelected = address.isDefault;
    if (address.isDefault == 1) {
        self.addressLabel.attributedText = [NSString setAttributedString:[NSString stringWithFormat:@"[默认]%@", address.address] color:RGB(51, 51, 51) rang:NSMakeRange(0, 4)  font:FONT(14)];
    } else {
        self.addressLabel.text = address.address == nil ? @"暂时无法获取到地址" : address.address;
    }
}

/**
 配置地址
 
 @param address
 */
- (void)configAddressWithName:(NSString *)name phoneNum:(NSString *)phoneNum address:(NSString *)address {
    self.addressLabel.text = address;
    self.nameLabel.text = name;
    self.numberLabel.text = [NSString seperateTelephoneString:phoneNum];
}

@end

//
//  TXPayBottomView.m
//  TailorX
//
//  Created by RogerChen on 21/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXPayBottomView.h"

@interface TXPayBottomView ()



@property (weak, nonatomic) IBOutlet UIButton *appointmentButton;

@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation TXPayBottomView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    
    TXPayBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    bottomView.accountLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    bottomView.submitButton.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    bottomView.isAllSelected = false;
    
    bottomView.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    bottomView.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    bottomView.shadowView.layer.shadowOpacity = 0.5;
    return bottomView;
}

- (IBAction)touchPayButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(touchPayAccountButton)]) {
        [self.delegate touchPayAccountButton];
    }
}

- (void)setPayType:(TXPayViewType)payType {
    if (payType == TXPayViewTypeSingle) {
        [self.allSelectLabel removeFromSuperview];
        [self.allSelectButton removeFromSuperview];
    }
}

- (IBAction)touchSelectedButton:(id)sender {
    
    self.isAllSelected = !self.isAllSelected;
    
    if ([self.delegate respondsToSelector:@selector(touchButtonWithStatusAllSelected:)]) {
        [self.delegate touchButtonWithStatusAllSelected:self.isAllSelected];
    }
}
- (IBAction)touchAppointmentButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchAppointmentDescriptionButton)]) {
        [self.delegate touchAppointmentDescriptionButton];
    }
}

- (void)setIsAllSelected:(BOOL)isAllSelected {
    _isAllSelected = isAllSelected;
    
    if (isAllSelected) {
        [self.allSelectButton setImage:[[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
    } else {
        [self.allSelectButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    }
}

- (void)setAppointmentType:(TXPayViewAppointmentType)appointmentType {
    _appointmentType = appointmentType;
    
    if (appointmentType == TXPayViewAppointmentTypeHide) {
        [self.appointmentButton removeFromSuperview];
    }
}

/**
 *  实例方法
 */
- (void)configBottomViewWithSelected:(BOOL)isSelected {
    self.isAllSelected = isSelected;
}

@end

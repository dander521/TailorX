//
//  TXOrderHeaderView.m
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXOrderHeaderView.h"

@interface TXOrderHeaderView ()

@property (nonatomic, strong) TXOrderHeaderModel *headerModel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;




@end

@implementation TXOrderHeaderView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    TXOrderHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    headerView.isSelected = false;
    headerView.headerStoreType = TXOrderHeaderStoreTypeDisable;
    return headerView;
}

/**
 *  配置门店
 */
- (void)configHeaderStoreNameWithModel:(TXOrderHeaderModel *)orderHeader {
    self.headerModel = orderHeader;
    self.storeLabel.text = orderHeader.storeName;
    self.isSelected = orderHeader.isSelected;
}

/**
 *  配置门店
 */
- (void)configStoreNameWithModel:(TXOrderModel *)order {
    self.storeLabel.text = order.storeName;
    self.isSelected = order.isSelected;
}

- (void)setHeaderType:(TXOrderHeaderType)headerType {
    _headerType = headerType;
    if (headerType == TXOrderHeaderTypeDismiss) {
        [self.choiceButton removeFromSuperview];
    } else if (headerType == TXOrderHeaderTypeDismissImage) {
        [self.choiceButton removeFromSuperview];
        [self.iconImageView removeFromSuperview];
    }
}

- (void)setHeaderStoreType:(TXOrderHeaderStoreType)headerStoreType {
    _headerStoreType = headerStoreType;
    if (headerStoreType == TXOrderHeaderStoreTypeDisable) {
        self.storeButton.hidden = true;
        self.rightArrowImageView.hidden = true;
    } else {
        self.storeButton.hidden = false;
        self.rightArrowImageView.hidden = false;
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        [self.choiceButton setImage:[[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"] forState:UIControlStateNormal];
    } else {
        [self.choiceButton setImage:[UIImage imageNamed:@"ic_mian_select_no"] forState:UIControlStateNormal];
    }
}

- (IBAction)touchChoiceButton:(id)sender {
    self.isSelected = !self.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(touchHeaderViewButtonWithSelected:headerModel:)]) {
        [self.delegate touchHeaderViewButtonWithSelected:self.isSelected headerModel:self.headerModel];
    }
}

- (IBAction)touchStoreButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchHeaderViewStoreButton)]) {
        [self.delegate touchHeaderViewStoreButton];
    }
}

@end

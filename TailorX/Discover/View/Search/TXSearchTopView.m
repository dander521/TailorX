//
//  TXSearchTopView.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSearchTopView.h"

@interface TXSearchTopView ()

@property (weak, nonatomic) IBOutlet UIView *shadowView;



@end

@implementation TXSearchTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.shadowView.layer.shadowOpacity = 0.5;
    
}

- (void)setViewType:(TXSearchTopViewType)viewType {
    _viewType = viewType;
    if (viewType == TXSearchTopViewTypeOrigin) {
        self.resultLabel.hidden = true;
    } else {
        self.resultLabel.hidden = false;
    }
}

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    TXSearchTopView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return headerView;
}

- (IBAction)touchCancelBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchCancelButton)]) {
        [self.delegate touchCancelButton];
    }
}

@end

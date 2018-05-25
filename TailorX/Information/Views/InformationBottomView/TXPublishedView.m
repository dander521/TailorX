//
//  TXPublishedView.m
//  TailorX
//
//  Created by Qian Shen on 15/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPublishedView.h"

@interface TXPublishedView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation TXPublishedView



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.shadowView.layer.shadowOpacity = 0.5;
    
    self.bgView.layer.borderWidth = 1.f;
    self.bgView.layer.cornerRadius = 7.f;
    self.bgView.borderColor = RGB(229, 229, 229);
    self.bgView.layer.masksToBounds = YES;
    
    self.inputTextView = [[UITextView alloc]init];
    self.inputTextView.textColor = RGB(46, 46, 46);
    self.inputTextView.font = [UIFont systemFontOfSize:14];
    self.inputTextView.returnKeyType = UIReturnKeySend;
    [self.bgView addSubview:self.inputTextView];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(30);
        make.top.mas_equalTo(self.bgView.mas_top).offset(3);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-3);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-3);
    }];
    if (![self.inputTextView hasText]) {
        [self.inputTextView addPlaceholderWithText:@"想说点什么？"
                                         textColor:RGB(204, 204, 204)
                                              font:[UIFont systemFontOfSize:14.f]];
    }
}

@end

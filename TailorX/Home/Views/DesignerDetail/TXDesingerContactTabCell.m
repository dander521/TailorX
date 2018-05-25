//
//  TXDesingerContactTabCell.m
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesingerContactTabCell.h"

@interface TXDesingerContactTabCell ()

/** 设计师电话*/
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/** 设计师QQ*/
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
/** 设计师微信号*/
@property (weak, nonatomic) IBOutlet UILabel *weChatLabel;

@end

@implementation TXDesingerContactTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setModel:(TXDesignerDetailModel *)model {
    
    _model = model;
    
    if ([NSString isTextEmpty:model.phone]) {
        self.phoneLabel.text = @"无";
    }else {
        self.phoneLabel.text = model.phone;
    }
    
    if ([NSString isTextEmpty:model.qq]) {
        self.qqLabel.text = @"无";
    }else {
        self.qqLabel.text = model.qq;
    }
    
    if ([NSString isTextEmpty:model.weChat]) {
        self.weChatLabel.text = @"无";
    }else {
        self.weChatLabel.text = model.weChat;
    }
    
    if (model.usedCount > 0) {
        for (UIView *subView in self.contentView.subviews) {
            subView.hidden =  NO;
        }
    }else {
        for (UIView *subView in self.contentView.subviews) {
            subView.hidden =  YES;
        }
    }
}

@end

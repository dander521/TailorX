//
//  TXFilterColViewCell.m
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFilterColViewCell.h"

@interface TXFilterColViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *markImgView;

@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;

@end

@implementation TXFilterColViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(TagInfo *)model {
    _model = model;
    
    self.markImgView.hidden = !model.isSelected;
    self.tagNameLabel.text = [NSString isTextEmpty:model.tagName] ? @"" :  model.tagName;
    if (model.isSelected) {
        self.tagNameLabel.textColor = RGB(255, 51, 102);
        self.tagNameLabel.backgroundColor = [RGB(255, 51, 102) colorWithAlphaComponent:0.2];
    }else {
        self.tagNameLabel.textColor = RGB(46, 46, 46);
        self.tagNameLabel.backgroundColor = RGB(240, 240, 240);
    }
}

@end

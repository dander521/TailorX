//
//  TXBodyDataTabCell.m
//  TailorX
//
//  Created by Qian Shen on 11/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBodyDataTabCell.h"

@implementation TXBodyDataTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(TXBodyDataModel *)model {
    
    _model = model;
    _nameLabel.text = model.labelName;
    
    if ([model.value isEqualToString:@"-1"]) {
        _numLabel.text = @"无";
    }else {
        _numLabel.text = [NSString isTextEmpty:model.value] == YES ? @"" : model.value;
    }
}
@end

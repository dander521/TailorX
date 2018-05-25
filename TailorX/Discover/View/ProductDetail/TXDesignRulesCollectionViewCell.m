//
//  TXDesignRulesCollectionViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignRulesCollectionViewCell.h"

@interface TXDesignRulesCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation TXDesignRulesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RulesInfo *)model {
    _model = model;
    
    self.nameLabel.text = model.labelName;
    self.countLabel.text = model.size;
}

@end

//
//  TXStoreColCell.m
//  TailorX
//
//  Created by Qian Shen on 4/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStoreColCell.h"

@interface TXStoreColCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation TXStoreColCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(TXStroeListModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    
    [self.coverImageView sd_small_setImageWithURL:[NSURL URLWithString:model.coverImage] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    if (model.status == 0) {
        if ([NSString isTextEmpty:model.coverImage]) {
            self.coverImageView.image = [UIImage imageNamed:@"img_stores"];
        }
    }
}


@end

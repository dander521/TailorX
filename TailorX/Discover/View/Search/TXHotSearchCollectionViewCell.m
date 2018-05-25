//
//  TXHotSearchCollectionViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXHotSearchCollectionViewCell.h"

@implementation TXHotSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tagLabel.layer.cornerRadius = 3;
    self.tagLabel.layer.masksToBounds = true;
}

@end

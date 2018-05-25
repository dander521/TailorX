//
//  TXCollectionInfoTabCell.m
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCollectionInfoTabCell.h"

@interface TXCollectionInfoTabCell ()

@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@end

@implementation TXCollectionInfoTabCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setPictureDetailModel:(TXFindPictureDetailModel *)pictureDetailModel {
    _pictureDetailModel = pictureDetailModel;
    self.publishTimeLabel.text = [NSString formatNewsDate:pictureDetailModel.publishTime/1000];
    self.shareCountLabel.text = [NSString stringWithFormat:@"%@",@(pictureDetailModel.shareCount)];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%@",@(pictureDetailModel.favoriteCount)];
}

@end

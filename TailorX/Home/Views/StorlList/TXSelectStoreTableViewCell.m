//
//  TXSelectStoreTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSelectStoreTableViewCell.h"
#import "XHStarRateView.h"

@interface TXSelectStoreTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealCountLabel;
@property (weak, nonatomic) IBOutlet UIView *starBgView;

/** 五星*/
@property (nonatomic, strong) XHStarRateView *starView;


@end

@implementation TXSelectStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 70, 11) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.userInteractionEnabled = NO;
    [self.starBgView addSubview:self.starView];
    
    self.storeImageView.layer.cornerRadius = 4;
    self.storeImageView.layer.masksToBounds = true;
    self.contentBgView.layer.cornerRadius = 4;
    self.contentBgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TXStroeListModel *)model {
    _model = model;
    
    self.storeName.text = model.name;
    self.addressLabel.text = model.address;
    [self.storeImageView sd_small_setImageWithURL:[NSURL URLWithString:model.coverImage] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2fkm",model.distance / 1000.0];
    self.dealCountLabel.text = [NSString stringWithFormat:@"成交量(%zd)", model.totalOrderCount];
    self.starView.currentScore = model.score;
}

@end

//
//  TXStoreDetailTabCell.m
//  TailorX
//
//  Created by Qian Shen on 16/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStoreDetailTabCell.h"
#import "XHStarRateView.h"


@interface TXStoreDetailTabCell ()

@property (weak, nonatomic) IBOutlet UIView *starBgView;
/** 五星*/
@property (nonatomic, strong) XHStarRateView *starView;

/** 店名*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 门店状态 0：建设中 1：运营中）*/
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/** 门店地址*/
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/** 门店的订单数(成交量)*/
@property (weak, nonatomic) IBOutlet UILabel *totalOrderCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
/** 门店介绍*/
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@end

@implementation TXStoreDetailTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.userInteractionEnabled = NO;
    [self.starBgView addSubview:self.starView];
    
}


- (void)setModel:(TXStoreDetailModel *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    
    if (model.status == 0) {
        self.statusLabel.text = @"装修中";
        self.statusLabel.textColor = RGB(80, 210, 194);
        self.statusImgView.image = [UIImage imageNamed:@"in_decoration"];
    }else if (model.status == 1) {
        self.statusLabel.text = @"营业中";
        self.statusLabel.textColor = RGB(255, 162, 0);
        self.statusImgView.image = [UIImage imageNamed:@"in_business"];
    }else {
        self.statusLabel.text = @"";
    }
    
    self.addressLabel.text = model.address;
    self.totalOrderCountLabel.text = [NSString stringWithFormat:@"成交量(%zd)",model.totalOrderCount];
    
    self.starView.currentScore = model.score;
    
    if ([NSString isTextEmpty:model.phone]) {
        self.callBtn.hidden = YES;
    }else {
        self.callBtn.hidden = YES;
    }
    
    if (![NSString isTextEmpty:model.introduce]) {
        // 调整行间距
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.introduce];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.introduce length])];
        self.introduceLabel.attributedText = attributedStr;
    }else {
        self.introduceLabel.text = @"暂无门店介绍";
    }
}
- (IBAction)touchLocationBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchAddressButton)]) {
        [self.delegate touchAddressButton];
    }
}

@end

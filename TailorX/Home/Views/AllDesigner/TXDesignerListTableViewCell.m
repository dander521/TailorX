//
//  TXDesignerListTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/8/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignerListTableViewCell.h"
#import "XHStarRateView.h"

@interface TXDesignerListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *designerAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *usedImageView;

@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designerTagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *designerStarsLabel;
@property (weak, nonatomic) IBOutlet UILabel *designerOrdersLabel;
@property (weak, nonatomic) IBOutlet UILabel *designerDistanceLabel;
@property (weak, nonatomic) IBOutlet UIView *starContentView;

/** 五星*/
@property (nonatomic, strong) XHStarRateView *starView;

@end

@implementation TXDesignerListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.designerAvatarImageView.layer.cornerRadius = 31.5;
    self.designerAvatarImageView.layer.masksToBounds = true;
    
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 13) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.userInteractionEnabled = NO;
    self.starView.currentScore = 2;
    [self.starContentView addSubview:self.starView];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXDesignerListTableViewCell";
    TXDesignerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)setDesignerModel:(TXDesignerListModel *)designerModel {
    _designerModel = designerModel;
    
    [self.designerAvatarImageView sd_small_setImageWithURL:[NSURL URLWithString:designerModel.photo] imageViewWidth:0 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    self.designerNameLabel.text = designerModel.name;
    self.designerTagsLabel.text = [NSString isTextEmpty:designerModel.goodStyle] ? @"无" : designerModel.goodStyle;
    if (designerModel.usedCount == 0) {
        self.usedImageView.hidden = true;
    } else {
        self.usedImageView.hidden = false;
        self.usedImageView.image = [UIImage imageNamed:@"ic_main_queen_3.2.1"];
    }
    self.storeAddressLabel.text = designerModel.storeName;
    self.starView.currentScore = designerModel.score;
    self.designerStarsLabel.text = [NSString stringWithFormat:@"%zd分", designerModel.score];
    self.designerOrdersLabel.text = [NSString stringWithFormat:@"%zd单", designerModel.order_count];
    self.designerDistanceLabel.text = [NSString stringWithFormat:@"%zdkm", designerModel.distance/1000];
}

@end

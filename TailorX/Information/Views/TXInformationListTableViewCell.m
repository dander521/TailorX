//
//  TXInformationListTableViewCell.m
//  TailorX
//
//  Created by 温强 on 2017/4/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInformationListTableViewCell.h"
#import "UIImage+YMImg.h"
@interface TXInformationListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIButton *popularityNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *amountOfReadingLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation TXInformationListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.bgView.layer.shadowOpacity = 0.5;
    
    [self.popularityNumBtn horizontalCenterImageAndTitle:5];

}

- (void)setModel:(TXInformationListModel *)model {
    _model = model;
    [self.coverImageView sd_small_setImageWithURL:[NSURL URLWithString:model.coverUrl] imageViewWidth:SCREEN_WIDTH-30 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    [self.iconImageView sd_small_setImageWithURL:[NSURL URLWithString:model.designerPhoto] imageViewWidth:30 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    self.titleLab.text = model.name;
    self.priceLab.text = [NSString stringWithFormat:@"¥%ld-%ld",(long)model.minPrice,(long)model.maxPrice];
    [self.priceLab setTextColor:[[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"]];
    self.nameLab.text = model.designerName;
    [self.popularityNumBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.popularity] forState:UIControlStateNormal];
    if (model.isLiked == 1) {
        [self.popularityNumBtn setImage:[UIImage imageNamed:@"ic_main_love_red"] forState:UIControlStateNormal];
    }else if (model.isLiked == 0) {
        [self.popularityNumBtn setImage:[UIImage imageNamed:@"ic_main_collect_the_information"] forState:UIControlStateNormal];
    }else {
        [self.popularityNumBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    self.amountOfReadingLab.text = [NSString stringWithFormat:@"%ld",(long)model.amountOfReading];
    if (model.isLiked) {
        self.islikedImageView.image = [UIImage imageNamed:@"ic_main_love_red"];
    } else {
        self.islikedImageView.image = [UIImage imageNamed:@"ic_main_love"];
    }
}
- (IBAction)clickPopularityNumBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(informationListTableViewCell:clickPopularityNumBtn:ofIndex:)]) {
        [_delegate informationListTableViewCell:self clickPopularityNumBtn:sender ofIndex:self.index];
    }
}

@end

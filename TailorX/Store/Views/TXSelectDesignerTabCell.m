//
//  TXSelectDesignerTabCell.m
//  TailorX
//
//  Created by Qian Shen on 6/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSelectDesignerTabCell.h"
#import "XHStarRateView.h"

@interface TXSelectDesignerTabCell ()

@property (weak, nonatomic) IBOutlet UIView *starBgView;
/** 五星*/
@property (nonatomic, strong) XHStarRateView *starView;

/** 设计师头像*/
@property (weak, nonatomic) IBOutlet UIImageView  *photoImgView;
/** 设计师名字*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** [设计师风格]*/
@property (weak, nonatomic) IBOutlet UILabel *stylesLabel;
/** work：是否工作中（ 0：未工作 1：工作中）*/
@property (weak, nonatomic) IBOutlet UILabel *workLabel;

@end

@implementation TXSelectDesignerTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.userInteractionEnabled = NO;
    [self.starBgView addSubview:self.starView];
    
}

- (void)setModel:(TXGetStoreDesignerListModel *)model {
    _model = model;
    
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:model.photo] imageViewWidth:63 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    self.nameLabel.text = model.name;
    self.stylesLabel.text = ![NSString isTextEmpty:model.goodStyle] ? model.goodStyle : @"";
    
    if  (model.goodStyle.length >= 5) {
        for(int i = 0; i < [model.goodStyle length]; i++)
        {
            NSString *tempStr = [model.goodStyle substringWithRange:NSMakeRange(i,1)];
            if ([tempStr isEqualToString:@"、"] && i == 4) {
                self.stylesLabel.text = [model.goodStyle substringToIndex:4];
            }else if ([tempStr isEqualToString:@"、"] && i == 0) {
                self.stylesLabel.text = [model.goodStyle substringWithRange:NSMakeRange(1, 4)];
            }
        }
    }
    self.starView.currentScore = model.score;
    // 0：繁忙中 1：工作中
    if (model.work == 0) {
        self.workLabel.text = kDesignerStatusBusy;
        self.workLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    }else if (model.work == 1) {
        self.workLabel.text = kDesignerStatusWorking;
        self.workLabel.textColor = RGB(255, 162, 0);
    }else {
        self.workLabel.text = @"";
    }
}

@end

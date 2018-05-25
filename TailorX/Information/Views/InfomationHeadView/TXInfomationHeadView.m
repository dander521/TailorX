//
//  TXInfomationHeadView.m
//  TailorX
//
//  Created by Qian Shen on 20/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInfomationHeadView.h"


@interface TXInfomationHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tempCoverImgView;

@end

@implementation TXInfomationHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.coverImgView.userInteractionEnabled = YES;
    [self.coverImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clcik)]];
}


- (void)setInformationModel:(TXInformationDetailModel *)informationModel {
    _informationModel = informationModel;
    
    if ([NSString isTextEmpty:informationModel.designerName]) {
        self.nameLabel.text = @"";
    }else {
    self.nameLabel.text = [NSString stringWithFormat:@"签约设计师：%@",informationModel.designerName];
    }
    
    self.photoImgView.layer.borderWidth = 1.f;
    self.photoImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:informationModel.designerPhoto] imageViewWidth:30 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
}

- (void)clcik {
    if (self.delegate && [self.delegate respondsToSelector:@selector(infomationHeadView:clickHeadImgView:)]) {
        [self.delegate infomationHeadView:self clickHeadImgView:self.coverImgView];
    }
}

@end

//
//  TXInfomationDescTabCell.m
//  TailorX
//
//  Created by Qian Shen on 27/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInfomationDescTabCell.h"

@interface TXInfomationDescTabCell ()

/** 描述信息*/
@property (weak, nonatomic) IBOutlet UILabel     *descLabel;
/** 设计师头像*/
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TXInfomationDescTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(TXInformationDetailModel *)model {
    _model = model;
    self.descLabel.text = model.designerIntroduction;
    
    if ([NSString isTextEmpty:model.designerIntroduction]) {
        self.descLabel.text = @"该设计师暂无描述";
    }else {
        self.descLabel.text = model.designerIntroduction;
        // 调整行间距
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.designerIntroduction];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.designerIntroduction length])];
        self.descLabel.attributedText = attributedStr;
    }
    
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:model.designerPhoto] imageViewWidth:30 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    self.nameLabel.text = model.designerName;
    
    if (model.favoriteDesigner) {
        [self.favoriteBtn setImage:[UIImage imageNamed:@"ic_main_collected_3.2.0"] forState:UIControlStateNormal];
    }else {
        [self.favoriteBtn setImage:[UIImage imageNamed:@"ic_main_collection_3.2.0"] forState:UIControlStateNormal];
    }
}

@end

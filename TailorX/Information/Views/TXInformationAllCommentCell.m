//
//  TXInformationAllCommentCell.m
//  TailorX
//
//  Created by 温强 on 2017/4/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInformationAllCommentCell.h"

@interface TXInformationAllCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end

@implementation TXInformationAllCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(TXInformationCommetModel *)model {
    if (_model == model) {
        return;
    }
    _model = model;
    self.nameLab.text = model.name;
    if ([NSString isTextEmpty:model.content]) {
        self.contentLab.text = @"";
    }else {
        self.contentLab.text = model.content;
        // 调整行间距
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.content length])];
        self.contentLab.attributedText = attributedStr;
    }

    [self.iconImageView sd_small_setImageWithURL:[NSURL URLWithString:model.photo] imageViewWidth:30 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    self.dateLab.text = [NSString formatDateLine:model.createDate / 1000];
}

@end

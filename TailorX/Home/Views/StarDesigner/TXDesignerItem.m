//
//  TXDesignerItem.m
//  TailorX
//
//  Created by Qian Shen on 29/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignerItem.h"
#define kStr @"、"

@interface TXDesignerItem ()

/** 设计师头像*/
@property (weak, nonatomic) IBOutlet UIImageView  *photoImgView;
/** 设计师名字*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** [设计师风格]*/
@property (weak, nonatomic) IBOutlet UILabel *stylesLabel;
/** 名字*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabelWidthLayout;
@end

@implementation TXDesignerItem

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(TXFindStarDesignerModel *)model {
    _model = model;
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:model.photo] imageViewWidth:100 placeholderImage:kDefaultUeserHeadImg];
    if ([NSString isTextEmpty:model.name]) {
        self.nameLabel.text = @"";
    }else {
        self.nameLabel.text = model.name;
    }
    
    NSMutableString *styleStr = [NSMutableString string];
    for (NSString *style in model.styleArray) {
        if (![NSString isTextEmpty:style]) {
            [styleStr appendString:[NSString stringWithFormat:@"%@%@",style,kStr]];
        }
    }
    
    if (styleStr.length > 0) {
        self.stylesLabel.text = [styleStr substringToIndex:styleStr.length-1];
    }else{
        self.stylesLabel.text = @"没有哦！";
    }
    if  (styleStr.length >= 5) {
        NSString *tempStr = [styleStr substringWithRange:NSMakeRange(4,1)];
        if ([tempStr isEqualToString:@"、"]) {
            self.stylesLabel.text = [styleStr substringToIndex:4];
        }else {
            self.stylesLabel.text = [styleStr substringToIndex:5];
        }
    }
}

@end

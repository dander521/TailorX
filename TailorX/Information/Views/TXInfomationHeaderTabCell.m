//
//  TXInfomationHeaderTabCell.m
//  TailorX
//
//  Created by Qian Shen on 27/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInfomationHeaderTabCell.h"
#import "UIView+SFrame.h"


@interface TXInfomationHeaderTabCell ()
/** 标题*/
@property (weak, nonatomic) IBOutlet UILabel     *title;
/** 标签视图的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LabelHeightLayout;
/** 标签背景视图*/
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation TXInfomationHeaderTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setInformationDetailModel:(TXInformationDetailModel *)informationDetailModel {
    _informationDetailModel = informationDetailModel;
    if ([NSString isTextEmpty:informationDetailModel.name]) {
        self.title.text = @"";
        self.topLayout.constant = 0;
    }else {
        self.title.text = informationDetailModel.name;
        self.topLayout.constant = 10;
        // 调整行间距
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:informationDetailModel.name];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [informationDetailModel.name length])];
        self.title.attributedText = attributedStr;
    }
    
    for (UIView *subView in self.bgView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat maxWidth = SCREEN_WIDTH - 95.5;
    NSArray<TagsCommonInfo*> *tagInfos = [TagsCommonInfo mj_objectArrayWithKeyValuesArray:informationDetailModel.commonList];
    if (tagInfos.count == 0) {
        TagsCommonInfo *tag = [TagsCommonInfo new];
        tag.tagName = @"暂无标签";
        tagInfos = @[tag];
    }
    float btnW = 0;
    int count = 0;
    for (int i = 0; i < tagInfos.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.borderColor = RGB(204, 204, 204);
        label.textColor = RGB(153, 153, 153);
        label.layer.borderWidth = 0.5f;
        label.layer.cornerRadius = 2.f;
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat labelWidth = [self heightForString:tagInfos[i].tagName fontSize:12 andWidth:maxWidth].width + 20;
        label.width = labelWidth;
        label.height = 22;
        if (i == 0) {
            label.x = 0;
            btnW += CGRectGetMaxX(label.frame);
        }
        else{
            btnW += CGRectGetMaxX(label.frame) + 10;
            if (btnW > maxWidth) {
                count++;
                label.x = 0;
                btnW = CGRectGetMaxX(label.frame);
            }
            else{
                label.x += btnW - label.width;
            }
        }
        label.y += count * (label.height + 10) + 10;
        label.text = tagInfos[i].tagName;
        [self.bgView addSubview:label];
        if (i == tagInfos.count - 1) {
            self.LabelHeightLayout.constant = CGRectGetMaxY(label.frame);
        }
    }
    [self.contentView layoutIfNeeded];

}


- (void)setPictureDetailModel:(TXFindPictureDetailModel *)pictureDetailModel {
    _pictureDetailModel = pictureDetailModel;
    if ([NSString isTextEmpty:pictureDetailModel.desc]) {
        self.title.text = @"";
        self.topLayout.constant = 0;
    }else {
        self.title.text = pictureDetailModel.desc;
        self.topLayout.constant = 10;
        // 调整行间距
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:pictureDetailModel.desc];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [pictureDetailModel.desc length])];
        self.title.attributedText = attributedStr;
    }
    
    for (UIView *subView in self.bgView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat maxWidth = SCREEN_WIDTH - 95.5;
    NSArray<TagsCommonInfo*> *tagInfos = [TagsCommonInfo mj_objectArrayWithKeyValuesArray:pictureDetailModel.tagsCommon];
    if (tagInfos.count == 0) {
        TagsCommonInfo *tag = [TagsCommonInfo new];
        tag.tagName = @"暂无标签";
        tagInfos = @[tag];
    }
    
    float btnW = 0;
    int count = 0;
    for (int i = 0; i < tagInfos.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.borderColor = RGB(204, 204, 204);
        label.textColor = RGB(153, 153, 153);
        label.layer.borderWidth = 0.5f;
        label.layer.cornerRadius = 2.f;
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat labelWidth = [self heightForString:tagInfos[i].tagName fontSize:12 andWidth:maxWidth].width + 20;
        label.width = labelWidth;
        label.height = 22;
        if (i == 0) {
            label.x = 0;
            btnW += CGRectGetMaxX(label.frame);
        }
        else{
            btnW += CGRectGetMaxX(label.frame) + 10;
            if (btnW > maxWidth) {
                count++;
                label.x = 0;
                btnW = CGRectGetMaxX(label.frame);
            }
            else{
                label.x += btnW - label.width;
            }
        }
        label.y += count * (label.height + 10) + 10;
        label.text = tagInfos[i].tagName;
        [self.bgView addSubview:label];
        if (i == tagInfos.count - 1) {
            self.LabelHeightLayout.constant = CGRectGetMaxY(label.frame);
        }
    }
    [self.contentView layoutIfNeeded];
}

/**
 * 计算文字的宽高
 */
- (CGSize)heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

@end

@implementation TagsCommonInfo : NSObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end

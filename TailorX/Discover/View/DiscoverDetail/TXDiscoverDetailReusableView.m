//
//  TXDiscoverDetailReusableView.m
//  TailorX
//
//  Created by Qian Shen on 18/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDiscoverDetailReusableView.h"
#import "TXInfomationHeaderTabCell.h"
#import "UIView+SFrame.h"


@interface TXDiscoverDetailReusableView ()

/** 头图的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImgHeightLayout;
/** 标签的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsLabelHeightLayout;
/** 标签的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *tagBgView;
/** 发现描述*/
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
/** 发布时间*/
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
/** 分享量*/
@property (weak, nonatomic) IBOutlet UILabel *shareCountLabel;
/** 收藏量*/
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

/** 设计师作品图右侧箭头*/
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
/** 成交作品*/
@property (weak, nonatomic) IBOutlet UILabel *dealProductLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealProductBtn;


@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *productLineLabel;

@end


@implementation TXDiscoverDetailReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.descLabel.font = [UIFont systemFontOfSize:17 weight:2];

    self.coverImgView.userInteractionEnabled = YES;
    [self.coverImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clcikCoverImgView)]];
}

- (void)setIsHasRecommendData:(BOOL)isHasRecommendData {
    _isHasRecommendData = isHasRecommendData;
    if (isHasRecommendData) {
        self.recommendLabel.hidden = false;
    } else {
        self.recommendLabel.hidden = true;
    }
}

- (void)setIsHasProductData:(BOOL)isHasProductData {
    _isHasProductData = isHasProductData;
    
    if (isHasProductData) {
        self.productImageView.hidden = false;
        self.productLineLabel.hidden = false;
        self.productCountLabel.hidden = false;
        self.arrowImageView.hidden = false;
        self.dealProductBtn.hidden = false;
        self.dealProductLabel.hidden = false;
    } else {
        self.productImageView.hidden = true;
        self.productLineLabel.hidden = true;
        self.productCountLabel.hidden = true;
        self.arrowImageView.hidden = true;
        self.dealProductBtn.hidden = true;
        self.dealProductLabel.hidden = true;
    }
    
}

- (void)setPictureDetailModel:(TXFindPictureDetailModel *)pictureDetailModel {
    _pictureDetailModel = pictureDetailModel;
    if (_pictureDetailModel == nil) {
        return;
    }
    [self.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:pictureDetailModel.imgUrl] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    // 头图相关
    CGFloat height = _pictureDetailModel.height == 0 ? 248 : _pictureDetailModel.height;
    CGFloat width = _pictureDetailModel.width == 0 ? SCREEN_WIDTH : _pictureDetailModel.width;
    self.coverImgHeightLayout.constant = height / width * SCREEN_WIDTH;
    
    if ([NSString isTextEmpty:pictureDetailModel.desc]) {
        self.descLabel.text = @"";
    }else {
        self.descLabel.text = pictureDetailModel.desc;
        // 调整行间距
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:pictureDetailModel.desc];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [pictureDetailModel.desc length])];
        self.descLabel.attributedText = attributedStr;
    }
    
    [self.tagBgView removeAllSubViews];
    CGFloat maxWidth = SCREEN_WIDTH - 93;
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
        [self.tagBgView addSubview:label];
        if (i == tagInfos.count - 1) {
            self.tagsLabelHeightLayout.constant = CGRectGetMaxY(label.frame);
        }
    }
    
    self.publishTimeLabel.text = [NSString formatNewsDate:pictureDetailModel.publishTime/1000];
    self.shareCountLabel.text = [NSString stringWithFormat:@"%@",@(pictureDetailModel.shareCount)];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%@",@(pictureDetailModel.favoriteCount)];
    
    if (self.pictureDetailModel.recommendDesignerWorkCount == 0) {
        self.dealProductBtn.enabled = false;
        self.arrowImageView.hidden = true;
        self.dealProductLabel.text = @"成交作品";
        self.productCountLabel.text = @"（暂无）";
    } else {
        self.dealProductBtn.enabled = true;
        self.arrowImageView.hidden = false;
        self.dealProductLabel.text = @"成交作品";
        self.productCountLabel.text = [NSString stringWithFormat:@"（%zd件）", self.pictureDetailModel.recommendDesignerWorkCount];
    }
}

#pragma mark - methods

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

#pragma mark - events

- (IBAction)touchDealProductBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchDealProductListBtn)]) {
        [self.delegate touchDealProductListBtn];
    }
}

- (void)clcikCoverImgView {
    if ([self.delegate respondsToSelector:@selector(discoverDetailReusableView:clickHeadImgView:)]) {
        [self.delegate discoverDetailReusableView:self clickHeadImgView:self.coverImgView];
    }
}

@end

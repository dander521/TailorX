//
//  TXDesignerHeaderCell.m
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignerHeaderCell.h"
#import "XHStarRateView.h"
#import "UIView+SFrame.h"


@interface TXDesignerHeaderCell ()


@property (weak, nonatomic) IBOutlet UIView  *starBgView;
/** 五星*/
@property (nonatomic, strong) XHStarRateView *starView;
/** 分格的背景视图*/
@property (weak, nonatomic) IBOutlet UIView *styleBgView;
/** 分格*/
@property (nonatomic, strong) NSArray *styles;

/** 设计师所属门店地址*/
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;
/** 订单成交量(如果没有则返回-1)*/
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
/** 交易成功总金额(如果没有该字段值。则返回-1)*/
@property (weak, nonatomic) IBOutlet UILabel *dealAmountLabel;
/** 效率(一天x件)如果没有该字段值，则返回-1*/
@property (weak, nonatomic) IBOutlet UILabel *efficiencyLabel;
/** 设计师描述*/
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
/** 风格视图的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *styleViewHeightLayout;

@property (weak, nonatomic) IBOutlet UILabel *desingerNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgHeightLayout;

@end

@implementation TXDesignerHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.userInteractionEnabled = NO;
    self.starView.currentScore = 2;
    [self.starBgView addSubview:self.starView];
    
    if (SCREEN_HEIGHT < 600){
        self.headImgHeightLayout.constant = 100;
        self.photoImgView.layer.cornerRadius = 50;
    }
    [self.contentView layoutIfNeeded];
    
}

- (void)setModel:(TXDesignerDetailModel *)model {
    _model = model;
    
    self.desingerNameLabel.text = [NSString isTextEmpty:model.name] ? @"" : model.name;
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:model.photo] imageViewWidth:100 placeholderImage:kDefaultUeserHeadImg];
    
    self.starView.currentScore = model.score;
    
    if (!model.styleArray || model.styleArray.count == 0) {
        self.styles = @[@"这人很懒，什么也没留下"];
    }else {
        self.styles = model.styleArray;
    }
    
    self.storeAddressLabel.text = model.storeName;
    
    if (model.amount  == -1) {
        self.amountLabel.text = [NSString stringWithFormat:@"%zd",0];
    }else {
        self.amountLabel.text = [NSString stringWithFormat:@"%zd",model.amount];
    }
    
    if ([model.dealAmount integerValue] == -1) {
        self.dealAmountLabel.text = @"0";
    }else {
        self.dealAmountLabel.text = model.dealAmount;
    }
    
    if (model.dealAmount.length>4){
        self.dealAmountLabel.font = [UIFont systemFontOfSize:20];
    }else {
         self.dealAmountLabel.font = [UIFont systemFontOfSize:24];
    }
    
    if (model.max_design == -1) {
        self.efficiencyLabel.text = [NSString stringWithFormat:@"%zd",0];
    }else {
        self.efficiencyLabel.text = [NSString stringWithFormat:@"%zd",model.max_design];
    }
    
    if ([NSString isTextEmpty:model.introduction]) {
        self.introductionLabel.text = @"";
    }else {
        self.introductionLabel.text = model.introduction;
    }
    
}

- (void)setStyles:(NSArray *)styles {
    _styles = styles;
    NSMutableArray *tempStytles = [@[]mutableCopy];
    for (NSInteger i = 0; i < styles.count; i ++) {
        if (![NSString isTextEmpty:styles[i]]) {
            [tempStytles addObject:styles[i]];
        }
    }
    [self.styleBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat maxWidth = 0;
    if (SCREEN_HEIGHT < 500){
        maxWidth = SCREEN_WIDTH - 140;
    }else {
        maxWidth = SCREEN_WIDTH - 170;
    }
    float btnW = 0;
    int count = 0;
    for (int i = 0; i < tempStytles.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.borderColor = RGB(204, 204, 204);
        label.textColor = RGB(153, 153, 153);
        label.layer.borderWidth = 0.5f;
        label.layer.cornerRadius = 2.f;
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat labelWidth = [self heightForString:tempStytles[i] fontSize:12 andWidth:maxWidth].width + 20;
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
        label.text = tempStytles[i];
        [self.styleBgView addSubview:label];
        if (i == tempStytles.count - 1) {
            self.styleViewHeightLayout.constant = CGRectGetMaxY(label.frame);
        }
    }
    [self.contentView layoutIfNeeded];
}

- (IBAction)clickHeadImgBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(designerHeaderCell:clickHeadImgBtn:)]) {
        [self.delegate designerHeaderCell:self clickHeadImgBtn:sender];
    }
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

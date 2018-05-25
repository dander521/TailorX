//
//  TXInformationDetailCell.m
//  TailorX
//
//  Created by 温强 on 2017/4/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInformationDetailCell.h"
#import "TXFontTool.h"

@interface TXInformationDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;

@property (weak, nonatomic) IBOutlet UILabel  *priceLabe;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelWidthCons;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLH;

@end
@implementation TXInformationDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect rect = CGRectMake(0, 0, 60, 34);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.frame = rect;
    shapeLayer.path = bezierPath.CGPath;
    self.orderBtn.layer.mask = shapeLayer;
}

- (void)setModel:(TXInformationDetailDesListModel *)model {
    _model = model;
    // 当描述信息为空的时候 去掉空白区域
    if ([NSString isTextEmpty:model.des]) {
        self.descriptionLab.text = nil;
        self.descriptionLab.hidden = YES;
        self.descLabTopLayout.constant = 0;
        self.descLabBottomLayout.constant = 0;
    }else {
        self.descriptionLab.text = model.des;
        self.descriptionLab.hidden = NO;
        self.descLabTopLayout.constant = 12;
        self.descLabBottomLayout.constant = 12;
        // 调整行间距
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.des];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.des length])];
        self.descriptionLab.attributedText = attributedStr;
    }
    CGFloat imgViewHeight = 371.5;
    if (model.height != 0) {
        imgViewHeight = model.height / model.width * (SCREEN_WIDTH-30);
    }
    self.imageH.constant = imgViewHeight;
    
    [self.contentView layoutIfNeeded];
    // TODO:该版本暂时不做
    self.nameLabel.text = @"";
    self.nameLH.constant = 0;
    self.nameLabel.hidden = YES;
    [self.nameLabel updateConstraints];
    
    [self.infoPicImageView sd_small_setImageWithURL:[NSURL URLWithString:model.infoPic] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    
    self.orderBtn.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    self.orderBtn.tag = model.order;
    self.priceLabe.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.priceLabe.text = [NSString stringWithFormat:@"￥%@-%@",model.minPrice,model.maxPrice];
    if ([model.minPrice integerValue] == 0 && [model.maxPrice integerValue] == 0) {
        self.priceLabe.hidden = true;
    } else {
        self.priceLabe.hidden = false;
    }
    
    CGFloat width = [TXFontTool heightForString:self.priceLabe.text fontSize:15.0 andWidth:200].width +20;
    _priceLabelWidthCons.constant = width;
    [self.priceLabe updateConstraints];
    [self addTapGesture];
}


- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    [self.infoPicImageView addGestureRecognizer:tap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)orderButtonAction:(id)sender {
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(orderButtonActionDelegate:)]) {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              _model.infoPic,@"infoPicUrl",
                              @(_model.ID),@"infoPicID", nil];
        [self.delegate orderButtonActionDelegate:info];
    }
}

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)tap {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(browseBigImageWithIndex:)]) {
        [self.delegate browseBigImageWithIndex:self.index];
    }
}

@end

//
//  TXWaterfallColCell.m
//  TailorX
//
//  Created by Qian Shen on 31/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXWaterfallColCell.h"

@interface TXWaterfallColCell ()

@property (weak, nonatomic) IBOutlet UIButton *shadowView;

/** 商品名称*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 价格区间*/
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareIconBottomLayout;
/** 设计师头像那块区域*/
@property (weak, nonatomic) IBOutlet UIView *designerPhotoImgBgView;
/** 设计师头像*/
@property (weak, nonatomic) IBOutlet UIImageView *designerPhotoImgView;
/** 设计师姓名*/
@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;
/** 设计师擅长风格*/
@property (weak, nonatomic) IBOutlet UILabel *designerGoodStyleLabel;

@end

@implementation TXWaterfallColCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.shadowView.layer.shadowOpacity = 0.3;
    self.shadowView.layer.cornerRadius = 4;
    
    self.priceLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    
}

- (void)setCellType:(TXWaterfallColCellType)cellType {
    _cellType = cellType;
    
    if (cellType == TXWaterfallColCellTypeDiscover) {
        [self.priceLabel removeFromSuperview];
        self.coverImageBottomConstraint.constant = 75.0 + 32;
        self.shareIconBottomLayout.constant = 60;
        self.designerPhotoImgBgView.hidden = NO;
    } else {
        self.designerPhotoImgBgView.hidden = YES;
        self.coverImageBottomConstraint.constant = 100.0;
        self.shareIconBottomLayout.constant = 18;
    }
}

-(void)setPictureListModel:(TXFindPictureListModel *)pictureListModel {
    _pictureListModel = pictureListModel;
    self.cellType = TXWaterfallColCellTypeDiscover;
    [self.imageView sd_small_setImageWithURL:[NSURL URLWithString:pictureListModel.imgUrl] imageViewWidth:(SCREEN_WIDTH-48)/2 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    // imgUrl = nil 收藏页面 使用 coverUrl
    if ([NSString isTextEmpty:pictureListModel.imgUrl]) {
        pictureListModel.imgUrl = pictureListModel.coverUrl;
        [self.imageView sd_small_setImageWithURL:[NSURL URLWithString:pictureListModel.coverUrl] imageViewWidth:(SCREEN_WIDTH-48)/2 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    }
    if ([NSString isTextEmpty:pictureListModel.desc] && [NSString isTextEmpty:pictureListModel.name]) {
        self.nameLabel.text = @"";
    } else {
        self.nameLabel.text = [NSString isTextEmpty:pictureListModel.desc] ?  pictureListModel.name : pictureListModel.desc;
    }

    if (pictureListModel.shareCount >= 1000) {
        self.amountOfReadingLabel.text = [NSString stringWithFormat:@"%0.1fk",pictureListModel.shareCount/1000.0];
    }else {
        self.amountOfReadingLabel.text = [NSString stringWithFormat:@"%@",@(pictureListModel.shareCount)];
    }
    
    if (pictureListModel.favoriteCount >= 1000) {
        self.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",pictureListModel.favoriteCount/1000.0];
    }else {
        self.popularityLabel.text = [NSString stringWithFormat:@"%@",@(pictureListModel.favoriteCount)];
    }
    
    if (pictureListModel.isFavorite == false && pictureListModel.favorite == false ) {
        [self.likedBtn setImage:[UIImage imageNamed:@"ic_main_big"] forState:UIControlStateNormal];
    } else {
        [self.likedBtn setImage:[UIImage imageNamed:@"ic_main_big-1"] forState:UIControlStateNormal];
    }
    
    [self.designerPhotoImgView sd_small_setImageWithURL:[NSURL URLWithString:pictureListModel.designerPhoto] imageViewWidth:(SCREEN_WIDTH-48)/2 placeholderImage:kDefaultUeserHeadImg];
    self.designerNameLabel.text = [NSString isTextEmpty:pictureListModel.designerName] ? @"" : pictureListModel.designerName;
    self.designerGoodStyleLabel.text = [NSString isTextEmpty:pictureListModel.goodStyle] ? @"" : pictureListModel.goodStyle;
}

- (void)setInfomationModel:(TXInformationListModel *)infomationModel {
    _infomationModel = infomationModel;
    self.cellType = TXWaterfallColCellTypeInformation;
    [self.imageView sd_small_setImageWithURL:[NSURL URLWithString:infomationModel.coverUrl] imageViewWidth:(SCREEN_WIDTH-48)/2 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    
    if ([NSString isTextEmpty:infomationModel.name]) {
        self.nameLabel.text = @"";
    }else {
        self.nameLabel.text = infomationModel.name;
    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥%zd-%zd",infomationModel.minPrice,infomationModel.maxPrice];
    self.priceLabel.textColor = [[ThemeManager shareManager]loadThemeColorWithName:@"theme_color"];
    if (infomationModel.shareCount >= 1000) {
        self.amountOfReadingLabel.text = [NSString stringWithFormat:@"%0.1fk",infomationModel.shareCount/1000.0];
    }else {
        self.amountOfReadingLabel.text = [NSString stringWithFormat:@"%@",@(infomationModel.shareCount)];
    }
    
    if (infomationModel.popularity >= 1000) {
        self.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",infomationModel.popularity/1000.0];
    }else {
        self.popularityLabel.text = [NSString stringWithFormat:@"%@",@(infomationModel.popularity)];
    }
    
    if (infomationModel.isLiked == 0) {
        [self.likedBtn setImage:[UIImage imageNamed:@"ic_main_big"] forState:UIControlStateNormal];
    }else if (infomationModel.isLiked == 1) {
        [self.likedBtn setImage:[UIImage imageNamed:@"ic_main_big-1"] forState:UIControlStateNormal];
    }
    
    [self.designerPhotoImgView sd_small_setImageWithURL:[NSURL URLWithString:infomationModel.designerPhoto] imageViewWidth:(SCREEN_WIDTH-48)/2 placeholderImage:kDefaultUeserHeadImg];
    self.designerNameLabel.text = [NSString isTextEmpty:infomationModel.designerName] ? @"" : infomationModel.designerName;
    self.designerGoodStyleLabel.text = [NSString isTextEmpty:infomationModel.goodStyle] ? @"" : infomationModel.goodStyle;
}
- (IBAction)clickScBtn:(UIButton *)sender {
    [self click:self.likedBtn];
}

- (void)click:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(waterfallColCell:clickLikedBtn:ofPictureListModelModel:)]) {
        [_delegate waterfallColCell:self clickLikedBtn:sender ofPictureListModelModel:self.pictureListModel];
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(waterfallColCell:clickLikedBtn:ofInformationModel:)]) {
        [_delegate waterfallColCell:self clickLikedBtn:sender ofInformationModel:self.infomationModel];
    }
}

- (IBAction)touchDesignerPhotoBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(waterfallColCell:clickDesignerBtn:ofPictureListModelModel:)]) {
        [_delegate waterfallColCell:self clickDesignerBtn:sender ofPictureListModelModel:self.pictureListModel];
        
    }
}


@end

//
//  TXFavoriteDesignTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/8/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFavoriteDesignTableViewCell.h"

@interface TXFavoriteDesignTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *designerAvatarImg;


@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveStatusBtn;

/** 设计师作品 */
@property (nonatomic, strong) NSMutableArray *designerOpusArray;

@end

@implementation TXFavoriteDesignTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.designerAvatarImg.layer.cornerRadius = 19.5;
    self.designerAvatarImg.layer.masksToBounds = true;
    self.designerOpusImg1.layer.cornerRadius = 4;
    self.designerOpusImg1.layer.masksToBounds = true;
    self.designerOpusImg2.layer.cornerRadius = 4;
    self.designerOpusImg2.layer.masksToBounds = true;
    self.designerOpusImg3.layer.cornerRadius = 4;
    self.designerOpusImg3.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXFavoriteDesignTableViewCell";
    TXFavoriteDesignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)setDesignerModel:(TXFavoriteDesignerListModel *)designerModel {
    _designerModel = designerModel;
    
    if ([NSString isTextEmpty:designerModel.productionPictures]) {
        self.designerOpusImg1.hidden = true;
        self.designerOpusImg2.hidden = true;
        self.designerOpusImg3.hidden = true;
        self.arrowImageView.hidden = true;
    }
    
    [self.designerAvatarImg sd_small_setImageWithURL:[NSURL URLWithString:designerModel.photo] imageViewWidth:0 placeholderImage:kDefaultUeserHeadImg];
    self.designerNameLabel.text = designerModel.name;
    self.descriptionLabel.text = [NSString isTextEmpty:designerModel.introduction] ? @"该设计师暂无描述" : designerModel.introduction;
    
    if (![NSString isTextEmpty:designerModel.productionPictures]) {
        NSArray *photoArray = [designerModel.productionPictures componentsSeparatedByString:@";"];
        
        self.designerOpusArray = [NSMutableArray new];
        if (photoArray.count > 3) {
            for (int i = 0; i < 3; i++) {
                [self.designerOpusArray addObject:photoArray[i]];
            }
        } else {
            [self.designerOpusArray addObjectsFromArray:photoArray];
        }
        
        if (self.designerOpusArray.count == 1) {
            self.designerOpusImg1.hidden = false;
            self.designerOpusImg2.hidden = true;
            self.designerOpusImg3.hidden = true;
        } else if (self.designerOpusArray.count == 2) {
            self.designerOpusImg1.hidden = false;
            self.designerOpusImg2.hidden = false;
            self.designerOpusImg3.hidden = true;
        } else if (self.designerOpusArray.count == 3) {
            self.designerOpusImg1.hidden = false;
            self.designerOpusImg2.hidden = false;
            self.designerOpusImg3.hidden = false;
        } else {
            self.designerOpusImg1.hidden = true;
            self.designerOpusImg2.hidden = true;
            self.designerOpusImg3.hidden = true;
        }
        
        for (int i = 0; i < self.designerOpusArray.count; i++) {
            if (i == 0) {
                [self.designerOpusImg1 sd_small_setImageWithURL:[NSURL URLWithString:self.designerOpusArray[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            } else if (i == 1) {
                [self.designerOpusImg2 sd_small_setImageWithURL:[NSURL URLWithString:self.designerOpusArray[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            } else if (i == 2) {
                [self.designerOpusImg3 sd_small_setImageWithURL:[NSURL URLWithString:self.designerOpusArray[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            }
        }
    }
}

- (void)setPictureDetailModel:(TXFindPictureDetailModel *)pictureDetailModel {
    _pictureDetailModel = pictureDetailModel;
    if (pictureDetailModel.favoriteDesigner == 1) {
        [self.saveStatusBtn setImage:[UIImage imageNamed:@"ic_main_collected_3.2.0"] forState:UIControlStateNormal];
    }else {
        [self.saveStatusBtn setImage:[UIImage imageNamed:@"ic_main_collection_3.2.0"] forState:UIControlStateNormal];
    }
    [self.designerAvatarImg sd_small_setImageWithURL:[NSURL URLWithString:pictureDetailModel.designerPhoto] imageViewWidth:0 placeholderImage:kDefaultUeserHeadImg];
    self.designerNameLabel.text = pictureDetailModel.designerName;
    self.descriptionLabel.text = [NSString isTextEmpty:pictureDetailModel.designerIntroduction] ? @"该设计师暂无描述" : pictureDetailModel.designerIntroduction;
    
    NSMutableArray *pictureList = [@[]mutableCopy];
    
    self.designerOpusImg1.userInteractionEnabled = NO;
    self.designerOpusImg2.userInteractionEnabled = NO;
    self.designerOpusImg3.userInteractionEnabled = NO;
    
    if ([NSString isTextEmpty:pictureDetailModel.productionPictures]) {
        [self.designerOpusImg1 removeFromSuperview];
        [self.designerOpusImg2 removeFromSuperview];
        [self.designerOpusImg3 removeFromSuperview];
        [self.arrowImageView removeFromSuperview];
    }else {
        NSArray *tempPictureList = [pictureDetailModel.productionPictures componentsSeparatedByString:@","];
        for (NSString *str in tempPictureList) {
            if (![NSString isTextEmpty:str]) {
                [pictureList addObject:str];
            }
        }
        if (pictureList.count == 1) {
            self.designerOpusImg2.hidden = true;
            self.designerOpusImg3.hidden = true;
        } else if (pictureList.count == 2) {
            self.designerOpusImg3.hidden = true;
        }
        for (int i = 0; i < pictureList.count; i++) {
            if (i == 0) {
                [self.designerOpusImg1 sd_small_setImageWithURL:[NSURL URLWithString:pictureList[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            } else if (i == 1) {
                [self.designerOpusImg2 sd_small_setImageWithURL:[NSURL URLWithString:pictureList[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            } else if (i == 2) {
                [self.designerOpusImg3 sd_small_setImageWithURL:[NSURL URLWithString:pictureList[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            }
        }
    }
}


- (IBAction)tapImageView:(UITapGestureRecognizer *)sender {
    UIImageView *img = (UIImageView *)sender.view;
    if ([self.delegate respondsToSelector:@selector(tapImageViewWithIndex:photoArray:cell:)]) {
        [self.delegate tapImageViewWithIndex:img.tag-100 photoArray:self.designerOpusArray cell:self];
    }
}

- (IBAction)touchCancelSaveBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cancelSaveDesignerWithDesignerModel:)]) {
        [self.delegate cancelSaveDesignerWithDesignerModel:self.designerModel];
    }
    if ([self.delegate respondsToSelector:@selector(cancelSaveDesignerWithDesignerId:ofLikeBtn:)]) {
        [self.delegate cancelSaveDesignerWithDesignerId:[NSString stringWithFormat:@"%zd", self.designerModel.ID]ofLikeBtn:sender];
    }
}


@end

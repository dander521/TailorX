//
//  TXDesignerCommentTabCell.m
//  TailorX
//
//  Created by Qian Shen on 20/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignerCommentTabCell.h"
#import "UIView+SFrame.h"
#import "UIButton+WebCache.h"

@interface TXDesignerCommentTabCell ()

/** 设计师地址*/
@property (weak, nonatomic) IBOutlet UIView *pictureBgView;
/** 存放图片视图的高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureBgViewHeightConstraint;
/** 评论人头像*/
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
/** 评论人名字*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 创建时间*/
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;


@end

@implementation TXDesignerCommentTabCell


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(TXDesignerCommentListModel *)model {
    _model = model;
    
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:model.photo] imageViewWidth:30 placeholderImage:kDefaultUeserHeadImg];
    
    self.nameLabel.text = model.customerName;
    self.createDateLabel.text = model.createDate;
    self.contentLabel.text = model.content;
    
    self.pictures = [@[]mutableCopy];
    for (NSString *imgUrl in model.pictureList) {
        if (![NSString isTextEmpty:imgUrl]) {
            [self.pictures addObject:imgUrl];
        }
    }
    
    if (self.pictures.count == 0) {
        self.pictureBgViewHeightConstraint.constant = 0;
        self.pictureBgView.hidden = YES;
    }else {
        self.pictureBgViewHeightConstraint.constant = LayoutW(80);
        self.pictureBgView.hidden = NO;
    }
    // 创建图片的数量
    NSInteger countNum = self.pictures.count > 3 ? 3 : self.pictures.count;
    float btnW = 0;
    int count = 0;
    for (int i = 0; i < countNum; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        
        btn.width = LayoutW(80);
        btn.height = LayoutW(80);
        
        [btn addTarget:self action:@selector(respondsToLookCommentsPictureBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.x = 0;
            btnW += CGRectGetMaxX(btn.frame);
        }
        else{
            btnW += CGRectGetMaxX(btn.frame)+ 8;
        }
        btn.x += btnW - btn.width;
        btn.backgroundColor = [UIColor clearColor];
        btn.y += count * (btn.height + 10);
        
        if (i == 0) {
            self.firstImageView = [[UIImageView alloc] initWithFrame:btn.frame];
            self.firstImageView.layer.cornerRadius = 5;
            self.firstImageView.layer.masksToBounds = YES;
            self.firstImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.firstImageView sd_small_setImageWithURL:[NSURL URLWithString:self.pictures[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            [self.pictureBgView addSubview:self.firstImageView];
        } else if (i ==1) {
            self.secondImageView = [[UIImageView alloc] initWithFrame:btn.frame];
            self.secondImageView.layer.cornerRadius = 5;
            self.secondImageView.layer.masksToBounds = YES;
            self.secondImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.secondImageView sd_small_setImageWithURL:[NSURL URLWithString:self.pictures[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            [self.pictureBgView addSubview:self.secondImageView];
        } else if (i == 2) {
            self.thirdImageView = [[UIImageView alloc] initWithFrame:btn.frame];
            self.thirdImageView.layer.cornerRadius = 5;
            self.thirdImageView.layer.masksToBounds = YES;
            self.thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.thirdImageView sd_small_setImageWithURL:[NSURL URLWithString:self.pictures[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            [self.pictureBgView addSubview:self.thirdImageView];
        }
        
        [self.pictureBgView addSubview:btn];
    }
}

/**
 * 查看评论图片
 */
- (void)respondsToLookCommentsPictureBtn:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(designerCommentTabCell:didSelectOfSection:ofIndex:)]) {
        [self.delegate designerCommentTabCell:self didSelectOfSection:self.section ofIndex:sender.tag];
    }
}

@end

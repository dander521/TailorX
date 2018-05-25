//
//  TXProgressNodeTabCell.m
//  Test
//
//  Created by Qian Shen on 25/7/17.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import "TXProgressNodeTabCell.h"
#import "TYAttributedLabel.h"

@interface TXProgressNodeTabCell ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**  */
@property (nonatomic, strong) NSMutableArray *allImgArray;

@end

@implementation TXProgressNodeTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TXProgressNodeModel *)model {
    _model = model;
    self.allImgArray = [NSMutableArray new];
    
    if ([NSString isTextEmpty:model.imgs]) {
        [self.firstImageView removeFromSuperview];
        [self.secondImageView removeFromSuperview];
        [self.thirdImageView removeFromSuperview];
    }else {
        NSArray *tempPictureList = [model.imgs componentsSeparatedByString:@","];
        
        for (int i = 0; i < tempPictureList.count; i++) {
            if (![NSString isTextEmpty:tempPictureList[i]]) {
                [self.allImgArray addObject:tempPictureList[i]];
            }
            if (self.allImgArray.count == 3) {
                break;
            }
        }
        
        if (self.allImgArray.count == 1) {
            self.secondImageView.hidden = true;
            self.thirdImageView.hidden = true;
        } else if (self.allImgArray.count == 2) {
            self.thirdImageView.hidden = true;
        }
        for (int i = 0; i < self.allImgArray.count; i++) {
            if (i == 0) {
                [self.firstImageView sd_small_setImageWithURL:[NSURL URLWithString:self.allImgArray[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            } else if (i == 1) {
                [self.secondImageView sd_small_setImageWithURL:[NSURL URLWithString:self.allImgArray[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            } else if (i == 2) {
                [self.thirdImageView sd_small_setImageWithURL:[NSURL URLWithString:self.allImgArray[i]] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            }
        }
    }
    
    if (self.isFirst) {
        if (![NSString isTextEmpty:model.currentNodeTail]) {
            self.contentLabel.text = [NSString stringWithFormat:@"%@，%@",model.content,model.currentNodeTail];
        }else {
            self.contentLabel.text = model.content;
        }
    }else {
        self.contentLabel.text = model.content;
    }
    
    self.timeLabel.text = model.createDateStr;

    if ([model.content containsString:@"点击查看物流信息"]) {
        TYTextContainer *textContainer = [[TYTextContainer alloc]init];
        textContainer.text = [NSString stringWithFormat:@"%@，%@",model.content,model.currentNodeTail];
        textContainer.textColor = self.isFirst== YES ? RGB(46, 46, 46) : RGB(153, 153, 153);
        textContainer.linkColor = RGB(58, 135, 242);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"点击查看物流信息"];
        [attributedString addAttributeUnderlineStyle:kCTUnderlineStyleSingle modifier:kCTUnderlinePatternSolid];
        [self.contentLabel appendTextAttributedString:attributedString];
        
        [textContainer addLinkWithLinkData:@"" linkColor:nil underLineStyle:kCTUnderlineStyleNone range:[model.content rangeOfString:@"点击查看物流信息"]];
        self.contentLabel.textContainer = textContainer;
        
        TYLinkTextStorage *linkTextStorage = [[TYLinkTextStorage alloc]init];
        linkTextStorage.range = [model.content rangeOfString:@"点击查看物流信息"];
        [textContainer addTextStorage:linkTextStorage];
    
    }else {
        
    }
    self.heightLayout.constant = [self.contentLabel getHeightWithWidth:SCREEN_WIDTH-kTopHeight];
    [self.contentView updateConstraints];
    
    self.contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-kTopHeight;
}

- (void)setIsFirst:(BOOL)isFirst {
    _isFirst = isFirst;
    if (_isFirst) {
        self.rightView.hidden = YES;
        self.statusImageView.image = [UIImage imageNamed:@"ic_main_tracking_state"];
        self.contentLabel.textColor = RGB(46, 46, 46);
        self.timeLabel.textColor = RGB(46, 46, 46);
    }else {
        self.rightView.hidden = NO;
        self.contentLabel.textColor = RGB(153, 153, 153);
        self.timeLabel.textColor = RGB(153, 153, 153);
        self.statusImageView.image = [UIImage imageNamed:@"ic_main_tracking_the_status1"];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXProgressNodeTabCell";
    TXProgressNodeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)tapImageView:(UITapGestureRecognizer *)sender {
    UIImageView *img = (UIImageView *)sender.view;
    if ([self.delegate respondsToSelector:@selector(tapImageViewWithIndex:photoArray:cell:)]) {
        [self.delegate tapImageViewWithIndex:img.tag-100 photoArray:self.allImgArray cell:self];
    }
}

@end

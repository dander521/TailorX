//
//  TXRePictureTabCell.m
//  TailorX
//
//  Created by Qian Shen on 5/7/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXRePictureTabCell.h"

#define IMGTAG 101
#define ERRORIMGTAG 201
#define ACTIVITYINDICATORVIEWTAG 301

@implementation TXRePictureTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    for (NSInteger i = 0; i < 3; i ++) {
        UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView*)[self viewWithTag:ACTIVITYINDICATORVIEWTAG+i];
        indicatorView.hidden = YES;
    }
}


- (void)setModels:(NSArray<TXBodyDataModel*> *)models {
    _models = models;
    for (NSInteger i = 0; i < models.count; i ++) {
        UIImageView *imageView = (UIImageView*)[self viewWithTag:IMGTAG+i];
        UIImageView *errorImageView = (UIImageView*)[self viewWithTag:ERRORIMGTAG+i];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        if (![NSString isTextEmpty:models[i].pictureUrl]) {
            models[i].image = [TXCustomTools createImageWithColor:[TXCustomTools randomColor]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:models[i].pictureUrl]
                         placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]
                                completed:^(UIImage * _Nullable image, NSError * _Nullable error, EMSDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                    if (image) {
                                        models[i].image = image;
                                    }
                                }];
        }else if (models[i].image) {
            imageView.image = models[i].image;
        }else {
            imageView.image = [UIImage imageNamed:@"ic_main_camera_img"];
            imageView.contentMode = UIViewContentModeScaleToFill;
        }
        errorImageView.hidden = !models[i].isLoadError;
    }
}


// 单击上传图片

-(IBAction)clickPositive:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(rePictureTabCell:clickImgViewOfIndex:)]) {
        [_delegate rePictureTabCell:self clickImgViewOfIndex:sender.view.tag-IMGTAG];
    }
}

// 单击上传图片失败

-(IBAction)clickPositiveOfError:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(rePictureTabCell:clickErrorImgViewOfIndex:)]) {
        [_delegate rePictureTabCell:self clickErrorImgViewOfIndex:sender.view.tag-ERRORIMGTAG];
    }
}

// 长按上传图片

-(IBAction)clickLongPositive:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
       
    }else {
        if (_delegate && [_delegate respondsToSelector:@selector(rePictureTabCell:longClickImgViewOfIndex:)]) {
            [_delegate rePictureTabCell:self longClickImgViewOfIndex:sender.view.tag-IMGTAG];
        }
    }
}

@end

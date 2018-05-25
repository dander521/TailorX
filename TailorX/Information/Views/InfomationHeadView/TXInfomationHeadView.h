//
//  TXInfomationHeadView.h
//  TailorX
//
//  Created by Qian Shen on 20/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFindPictureDetailModel.h"
#import "TXInformationDetailModel.h"

@class TXInfomationHeadView;

@protocol TXInfomationHeadViewDelegate <NSObject>

- (void)infomationHeadView:(TXInfomationHeadView*)headView clickHeadImgView:(UIImageView*)imgView;

@end

@interface TXInfomationHeadView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;

/** 资讯模型*/
@property (nonatomic, strong) TXInformationDetailModel *informationModel;
/** 发现模型*/
@property (nonatomic, strong) TXFindPictureDetailModel *pictureDetailModel;
/** 代理*/
@property (nonatomic, strong) id<TXInfomationHeadViewDelegate> delegate;


@end

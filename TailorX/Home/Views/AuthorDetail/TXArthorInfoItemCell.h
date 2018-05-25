//
//  TXArthorInfoItemCell.h
//  TailorX
//
//  Created by Qian Shen on 30/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXDesignerProductionListModel.h"
#import "TXStoreDetailModel.h"

@interface TXArthorInfoItemCell : UICollectionViewCell

/** 模型*/
@property (nonatomic, strong) TXDesignerProductionListModel *model;

/** 图片模型*/
@property (nonatomic, strong) TXPicturesModel *pictureModel;


@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;


@end

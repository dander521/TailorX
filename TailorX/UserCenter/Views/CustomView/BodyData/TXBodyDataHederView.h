//
//  TXBodyDataHederView.h
//  TailorX
//
//  Created by Qian Shen on 11/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXBodyDataHederView : UIView

/** 用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImgView;
/** 用户姓名*/
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 门店名称*/
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
/** 量体时间*/
@property (weak, nonatomic) IBOutlet UILabel *updateDateLabel;

@end

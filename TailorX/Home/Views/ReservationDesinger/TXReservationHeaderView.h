//
//  TXReservationHeaderView.h
//  TailorX
//
//  Created by Qian Shen on 14/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXReservationHeaderView : UIView<UITextViewDelegate>

/** 设计师名字*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 设计师头像*/
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
/** 点击头像的按钮*/
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
/** 顶部提示视图*/
@property (weak, nonatomic) IBOutlet UIView *topPromptView;
/** 门店名字*/
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
/** 门店地址*/
@property (weak, nonatomic) IBOutlet UILabel *stroeAddressLabel;
/** 工作时间*/
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
/** 提示字符*/
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptChangeLabel;
/** 切换实际师*/
@property (weak, nonatomic) IBOutlet UIButton *switchDesignerBtn;
/** 留言*/
@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
/** 字符限制的标签*/
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
/** 右边箭头*/
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
/** 门店定制*/
@property (weak, nonatomic) IBOutlet UIView *storeInfoView;
/** 平台签约设计师*/
@property (weak, nonatomic) IBOutlet UIImageView *desingerMarkImgView;

@end

//
//  TXPayNowayView.h
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXPayNowayView : UIView

@property (weak, nonatomic) IBOutlet UIButton *capitalImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *capitalBtn;

@property (weak, nonatomic) IBOutlet UIButton *alipayImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeImgBtn;

@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;

+ (instancetype)instanse;

// payType	int	是	支付类型：0支付宝，1余额
@property (nonatomic, assign) NSInteger payType;

@end

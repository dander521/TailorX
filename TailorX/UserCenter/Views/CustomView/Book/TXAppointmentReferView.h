//
//  TXAppointmentReferImageView.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TXAppointmentReferView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *referImageView;
@property (weak, nonatomic) IBOutlet UILabel *inforNoLabel;

/** 是否为咨询图 */
@property (nonatomic, assign) BOOL isInformation;

+ (TXAppointmentReferView *)setUpAppointmentReferView;

@end

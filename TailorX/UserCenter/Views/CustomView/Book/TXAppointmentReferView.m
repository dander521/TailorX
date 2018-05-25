//
//  TXAppointmentReferImageView.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAppointmentReferView.h"

@interface TXAppointmentReferView ()

@property (weak, nonatomic) IBOutlet UILabel *inforLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;

@end

@implementation TXAppointmentReferView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

- (void)setIsInformation:(BOOL)isInformation {
    _isInformation = isInformation;
    
    if (!isInformation) {
        self.inforNoLabel.hidden = true;
        self.inforLabel.hidden = true;
        self.maskImageView.hidden = true;
    } else {
        self.inforNoLabel.hidden = false;
        self.inforLabel.hidden = false;
        self.maskImageView.hidden = false;
    }
}

+ (TXAppointmentReferView *)setUpAppointmentReferView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TXAppointmentReferView class]) owner:nil options:nil].lastObject;
}

@end

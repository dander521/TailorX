//
//  TXAboutUsTabHearView.m
//  TailorX
//
//  Created by 温强 on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAboutUsTabHearView.h"

@implementation TXAboutUsTabHearView

+ (instancetype)instanse {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

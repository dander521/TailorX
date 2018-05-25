//
//  TXSetView.m
//  TailorX
//
//  Created by 温强 on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSetView.h"
@interface TXSetView()
@property (weak, nonatomic) IBOutlet UISwitch *pushServiceSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cacheLabel;
@end


@implementation TXSetView

//实时推送
- (IBAction)pushSerViceSwithClickd:(id)sender {
    

}
//切换主题
- (IBAction)changeThemeClickd:(id)sender {
    
}
// 清除缓存
- (IBAction)clearCacheClickd:(id)sender {
}

// 关于我们
- (IBAction)aboutUsClickd:(id)sender {
    
    if (self.aboutUsBlock) {
        self.aboutUsBlock();
    }

}



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

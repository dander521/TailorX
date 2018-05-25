//
//  UserCenterTableHeaderView.m
//  TailorX
//
//  Created by RogerChen on 16/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXUserCenterTableHeaderView.h"

@implementation TXUserCenterTableHeaderView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    TXUserCenterTableHeaderView * customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    customView.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    return customView;
}

- (void)configHeaderViewWithDictionary:(NSDictionary *)dic {
    
    NSString *photoStr = [NSString isTextEmpty:[TXModelAchivar getUserModel].photo] ? dic[@"photo"] : [TXModelAchivar getUserModel].photo;
    
    [self.userImageView sd_small_setImageWithURL:[NSURL URLWithString:photoStr] imageViewWidth:63 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    
    self.userImageView.layer.cornerRadius = 50;
    self.userImageView.layer.masksToBounds = true;
    self.userImageView.userInteractionEnabled = true;
    
    NSString *nameStr = [NSString isTextEmpty:[TXModelAchivar getUserModel].nickName] && [NSString isTextEmpty:dic[@"name"]] ? @"登录/注册" : ([NSString isTextEmpty:[TXModelAchivar getUserModel].nickName] ? dic[@"name"] : [TXModelAchivar getUserModel].nickName);
    
    self.userNameLabel.text = nameStr;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
    tapGesture.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
    tapImageGesture.numberOfTapsRequired = 1;
    [self.userImageView addGestureRecognizer:tapImageGesture];
    [self.userNameLabel addGestureRecognizer:tapGesture];
}

- (void)tapGestrueMethod:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(tapUserAvatarImageView)]) {
        [self.delegate tapUserAvatarImageView];
    }
}


@end

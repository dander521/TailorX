//
//  UserCenterTableHeaderView.h
//  TailorX
//
//  Created by RogerChen on 16/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXUserCenterTableHeaderViewDelegate <NSObject>

/**
 点击用户默认头像
 */
- (void)tapUserAvatarImageView;

@end

@interface TXUserCenterTableHeaderView : UIView


/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 代理 */
@property (nonatomic, assign) id <TXUserCenterTableHeaderViewDelegate> delegate;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

/**
 *  设置显示
 */
- (void)configHeaderViewWithDictionary:(NSDictionary *)dic;

@end


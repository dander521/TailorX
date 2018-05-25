//
//  TXCommentSuccessHeaderView.h
//  TailorX
//
//  Created by RogerChen on 2017/3/30.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TXCommentSuccessHeaderType) {
    TXCommentSuccessHeaderTypeContinue = 0, /** < 继续评论 */
    TXCommentSuccessHeaderTypeDefault /** < 无更多内容 */
};

@interface TXCommentSuccessHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *continueCommentView;
@property (nonatomic, assign) TXCommentSuccessHeaderType headerType;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end

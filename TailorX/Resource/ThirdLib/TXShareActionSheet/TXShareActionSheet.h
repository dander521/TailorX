//
//  TXShareActionSheet.h
//  TailorX
//
//  Created by Qian Shen on 9/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^WeChatBlock)(void);
typedef void(^FriendCircleBlock)(void);
typedef void(^QQBlock)(void);

@interface TXShareActionSheet : UIView

@property (nonatomic, copy) WeChatBlock weChatBlock;

@property (nonatomic, copy) FriendCircleBlock friendCircleBlock;

@property (nonatomic, copy) QQBlock qqBlock;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

/**
 * 显示
 */
- (void)showWithweChat:(WeChatBlock)weChat
          FriendCircle:(FriendCircleBlock)friendCircle
                    Qq:(QQBlock)qq;

@end

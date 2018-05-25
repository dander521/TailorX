//
//  TXCommentBottomView.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXCommentBottomViewDelegate <NSObject>

- (void)touchShowCommentDetail;

@end

@interface TXCommentBottomView : UIView

/** 代理 */
@property (nonatomic, assign) id<TXCommentBottomViewDelegate>delegate;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end

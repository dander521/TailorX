//
//  TXKeyboardView.h
//  TailorX
//
//  Created by liuyanming on 2017/3/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXQueueNoRequestParams.h"

@protocol TXKeyboardViewDelegate <NSObject>

@optional
- (void)keyboardSureBtnClick:(NSString *)price;

@end

@interface TXKeyboardView : UIView

- (void)show;
- (void)hidden;


@property (nonatomic, copy) TXQueueNoRequestParams *param;

@property (nonatomic, weak) id<TXKeyboardViewDelegate> delegate;
@end

//
//  CountdownView.h
//  iOS开发常见技术-每日一记
//
//  Created by Qian Shen on 2017/3/13.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^completeBlock)(void);


@interface TXCountdownView : UIView

/**小时*/
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
/**分钟*/
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
/**秒*/
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
/**描述*/
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/**第一个：*/
@property (weak, nonatomic) IBOutlet UILabel *space_firstLabel;
/**第二个：*/
@property (weak, nonatomic) IBOutlet UILabel *spce_twoLabel;


/**
 倒计时的总时间：这里计算成统一计算成秒
 */
@property (nonatomic, assign) int reverseTime;



/**
 快速创建 TXCountdownView

 @return self
 */
+ (instancetype)setupTXCountdownView;



/**
 类工厂方法创建 TXCountdownView

 @param reverseTime 倒计时的总时间
 @return self
 */
- (instancetype)initWithAllReverseTime:(int)reverseTime;


/**
 开始倒计时

 @param block 回调
 */
- (void)startTimeCompleteBlock:(completeBlock)block;


- (void)updateUI;

@end

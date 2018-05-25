//
//  TXDiscoverTopView.h
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXDiscoverTopViewDelegate <NSObject>

- (void)touchLatestBtn;

- (void)touchHeatBtn;

- (void)touchFilterBtn;

@end

@interface TXDiscoverTopView : UIView

@property (nonatomic, assign) id<TXDiscoverTopViewDelegate>delegate;


@end

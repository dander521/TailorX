//
//  TXAppointView.h
//  TailorX
//
//  Created by 程荣刚 on 2017/12/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TXAppointViewType) {
    TXAppointViewTypeStore,
    TXAppointViewTypeDesigner
};

@protocol TXAppointViewDelegate <NSObject>

- (void)touchSureButton;

@end

@interface TXAppointView : UIView

/** <#description#> */
@property (nonatomic, weak) id <TXAppointViewDelegate> delegate;

/** <#description#> */
@property (nonatomic, assign) TXAppointViewType appointType;

+ (instancetype)shareInstanceManager;

- (void)show;

- (void)hide;

@end

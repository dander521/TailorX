//
//  TXOrderHeaderView.h
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXOrderModel.h"

typedef NS_ENUM(NSUInteger, TXOrderHeaderType) {
    TXOrderHeaderTypeEnable = 0, /** <选择按钮可选 */
    TXOrderHeaderTypeDismiss, /** <无选择按钮 */
    TXOrderHeaderTypeDismissImage, /** <无选择按钮、无图片 */
};

typedef NS_ENUM(NSUInteger, TXOrderHeaderStoreType) {
    TXOrderHeaderStoreTypeDisable = 0, /** <不可跳转门店 */
    TXOrderHeaderStoreTypeEnable /** <可跳转门店 */
};

@protocol TXOrderHeaderViewDelegate <NSObject>
@optional
/**
 *  点击选择按钮
 */
- (void)touchHeaderViewButtonWithSelected:(BOOL)isSelected headerModel:(TXOrderHeaderModel *)headerModel;

/**
 *  点击选择按钮
 */
- (void)touchHeaderViewStoreButton;

@end

@interface TXOrderHeaderView : UIView
/** 状态标签 */
@property (weak, nonatomic) IBOutlet UILabel *rightStatusLabel;
/** 选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
/** 图标icon */
@property (weak, nonatomic) IBOutlet UIImageView *dressIcon;
/** 门店名 */
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
/** 显示类型 */
@property (nonatomic, assign) TXOrderHeaderType headerType;
/** 跳转门店类型 */
@property (nonatomic, assign) TXOrderHeaderStoreType headerStoreType;
/** 代理 */
@property (nonatomic, assign) id <TXOrderHeaderViewDelegate> delegate;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** icon */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

/**
 *  配置门店
 */
- (void)configStoreNameWithModel:(TXOrderModel *)order;

/**
 *  配置门店
 */
- (void)configHeaderStoreNameWithModel:(TXOrderHeaderModel *)orderHeader;

@end

//
//  TXSectionReusableView.h
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXSectionReusableView;

@protocol TXSectionReusableViewDelegate <NSObject>

@optional

- (void)sectionReusableView:(TXSectionReusableView*)reusableView clickofSection:(NSInteger)section;

@end

@interface TXSectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;
/** 向下箭头*/
@property (weak, nonatomic) IBOutlet UIImageView *markImgView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

/** 代理*/
@property (nonatomic, weak) id<TXSectionReusableViewDelegate> delegate;
/** 当前组*/
@property (nonatomic, assign) NSInteger section;

@end

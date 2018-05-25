//
//  TXDiscoverFilterView.h
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFindAllTagsModel.h"

typedef void(^SureBlock)(NSMutableDictionary *info);

@interface TXDiscoverFilterView : UIView

/** 筛选数据*/
@property (nonatomic, strong) TXFindAllTagsModel *tagModels;

@property (nonatomic, copy) SureBlock sureBlock;

- (void)showWithSure:(SureBlock)sureBlock;

@end

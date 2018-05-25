//
//  TXDesignerDetailController.h
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXDesignerDetailController : TXBaseViewController

/** 设计师ID*/
@property (nonatomic, strong) NSString *designerId;
/** 是否需要预约按钮*/
@property (nonatomic, assign) BOOL isHavaCommitBtn;
/** 点击店铺名字是否进入店铺详情 */
@property (nonatomic, assign) BOOL bEnterStoreDetail;

@end

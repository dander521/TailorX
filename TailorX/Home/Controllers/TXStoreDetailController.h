
//
//  TXStoreDetailController.h
//  TailorX
//
//  Created by Qian Shen on 16/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXStoreDetailController : TXBaseViewController<UINavigationControllerDelegate>

/** 门店ID*/
@property (nonatomic, strong) NSString *storeid;
/** 调整进入门店详情，是否隐藏预约按钮 */
@property (nonatomic, assign) BOOL isHidden;

@end

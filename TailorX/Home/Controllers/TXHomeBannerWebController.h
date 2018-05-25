//
//  TXHomeBannerWebController.h
//  TailorX
//
//  Created by Qian Shen on 1/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXHomeBannerWebController : TXBaseViewController

/** url*/
@property (nonatomic, strong) NSString *requestUrl;
/** 是否隐藏分享 */
@property (nonatomic, assign) BOOL isHideShare;

@end

//
//  TXSelectCityController.h
//  TailorX
//
//  Created by Qian Shen on 12/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"
#import "TXCityModel.h"

typedef void (^sureBlock)(TXCityModel *cityModel);

@interface TXSelectCityController : TXBaseViewController

/** blcok变量*/
@property (nonatomic, copy) sureBlock block;

@end

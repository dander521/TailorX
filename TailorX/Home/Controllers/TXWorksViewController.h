//
//  TXWorksViewController.h
//  TailorX
//
//  Created by Qian Shen on 6/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXWorksViewController : TXBaseViewController <ZJScrollPageViewChildVcDelegate>

/** 设计师ID*/
@property (nonatomic, strong) NSString *designerId;

/** <#description#> */
@property (nonatomic, assign) BOOL isCollection;

@end

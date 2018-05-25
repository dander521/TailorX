//
//  TXTransDetailController.h
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"
#import "ZJScrollPageViewDelegate.h"

@interface TXTransDetailController : TXBaseViewController <ZJScrollPageViewChildVcDelegate>
@property (copy, nonatomic) NSString *accountType;
@end

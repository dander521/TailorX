//
//  TXProcessNodeViewController.h
//  TailorX
//
//  Created by 程荣刚 on 2017/6/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAttributedLabel.h"
#import "ZJScrollPageViewDelegate.h"

@interface TXProcessNodeViewController : UIViewController<ZJScrollPageViewChildVcDelegate>

/** 订单号*/
@property (nonatomic, strong) NSString *orderNo;
/** Y:insert:64px*/
@property (nonatomic, assign) BOOL isInsert;


@end

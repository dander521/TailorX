//
//  TXAllDetailViewController.h
//  TailorX
//
//  Created by 程荣刚 on 2017/6/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageView.h"

@interface TXAllDetailViewController : UIViewController

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

/** 订单详情*/
@property (nonatomic, strong) UIViewController *orderDetailVc;
/** 订单编号*/
@property (nonatomic, strong) NSString *orderNo;

/** 选中的索引 */
@property (nonatomic, assign) NSInteger selectedIndex;



@end

//
//  TXInProductViewController.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXInProductDetailViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
/** 订单id */
@property (nonatomic, strong) NSString *orderId;
@end

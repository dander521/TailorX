//
//  TXForPayViewController.h
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXForPayDetailViewController : UIViewController<ZJScrollPageViewChildVcDelegate>

/** 订单id */
@property (nonatomic, strong) NSString *orderId;
/** 订单状态 */
@property (nonatomic, assign) NSUInteger orderStatus;

@end

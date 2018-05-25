//
//  TXInQueueOrderDetailViewController.h
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXInQueueOrderDetailViewController : UIViewController<ZJScrollPageViewChildVcDelegate>

/** 订单id */
@property (nonatomic, strong) NSString *orderId;

@end

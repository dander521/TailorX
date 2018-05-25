//
//  TabBarController.h
//  Tailorx
//
//  Created by   徐安超 on 16/7/18.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXNavigationViewController.h"

typedef NS_ENUM(NSUInteger, TXTabBarSelectIndex) {
    TXTabBarSelectIndexHome = 0, /**< 首页 */
    TXTabBarSelectIndexInformation, /**< 资讯 */
    TXTabBarSelectIndexQueueNo, /**< 排号 */
    TXTabBarSelectIndexStore /**< 门店 */
};

@interface TXTabBarController : UITabBarController
/** 首页导航控制器 */
@property (nonatomic, strong) TXNavigationViewController *homeNavCon;
/** 分类导航控制器 */
@property (nonatomic, strong) TXNavigationViewController *classifyNavCon;
/** 排号导航控制器 */
@property (nonatomic, strong) TXNavigationViewController *queueNoNavCon;
/** 店铺导航控制器 */
@property (nonatomic, strong) TXNavigationViewController *storeNavCon;

@end

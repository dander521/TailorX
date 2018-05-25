//
//  TailorxNavigationViewController.m
//  Tailorx
//
//  Created by 高习泰 on 16/7/31.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "TXNavigationViewController.h"
#import "UINavigationBar+Awesome.h"

@interface TXNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation TXNavigationViewController

+ (void)initialize
{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) { // 此时push进来的viewController是第二个子控制器
        // 自动隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 定义全局leftBarButtonItem
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_arrow"]
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:self
                                                                                      action:@selector(back)];
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    // 程荣刚：2017-3-21 4:10 修改pop页面直接到rootViewController 为 pop 当前页面
    [self popViewControllerAnimated:true];
}


@end

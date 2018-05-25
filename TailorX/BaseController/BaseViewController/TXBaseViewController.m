//
//  BaseViewController.m
//  TailorX
//
//  Created by RogerChen on 15/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXBaseViewController.h"
#import "AppDelegate.h"

@interface TXBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation TXBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置左侧button
    [self configLeftBarButtonItem];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"up"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    //设置阴影的高度
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    //设置透明度
    self.navigationController.navigationBar.layer.shadowOpacity = 0.08;
    self.navigationController.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationController.navigationBar.bounds].CGPath;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}

/**
 设置左侧button
 */
- (void)configLeftBarButtonItem {
    if(self.navigationController.viewControllers.count <= 1){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage new]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    }
}


- (void)dealloc {
    NSLog(@"-----------------------------------dealloc-----------------------------");
}

@end

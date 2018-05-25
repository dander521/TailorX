//
//  TXGuideLoginController.m
//  TailorX
//
//  Created by Qian Shen on 28/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXGuideLoginController.h"
#import "TXLoginController.h"
#import "TXRegisterController.h"

@interface TXGuideLoginController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopLayout;
/** 注册按钮*/
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation TXGuideLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5C"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 5S"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone SE"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 6s Plus"]) {
        self.navTopLayout.constant = 0;
    } else {
        self.navTopLayout.constant = -20;
    }
    
    self.registerBtn.layer.borderColor = RGB(52, 52, 55).CGColor;
    self.registerBtn.layer.borderWidth = 0.5f;
    self.registerBtn.layer.cornerRadius = 3.f;
    self.registerBtn.layer.masksToBounds = YES;
    NSString *imgName = @"";
    // plus
    if(SCREEN_HEIGHT > 700) {
        imgName = @"iOS_1242X2208_03";
    }
    // s
    else if (SCREEN_HEIGHT > 650) {
        imgName = @"iOS_750X1334_03";
    }
    // 5
    else if (SCREEN_HEIGHT > 500){
        imgName = @"iOS_640X1136_03";
    }
    // 4
    else {
        imgName = @"iOS_320X480_03";
    }
    self.bgView.image = [UIImage imageNamed:imgName];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - methods

- (void)customPopViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - events

/**
 *取消登录
 */
- (IBAction)back {
    [self customPopViewController];
}

/**
 *登录
 */
- (IBAction)respondsToLoginBtn:(UIButton *)sender {
    [self.navigationController pushViewController:[TXLoginController new] animated:YES];
    
}

/**
 *注册
 */
- (IBAction)respondsToRegisterBtn:(UIButton *)sender {
    [self.navigationController pushViewController:[TXRegisterController new] animated:YES];
}

@end

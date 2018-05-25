//
//  TXCustomTools.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCustomTools.h"
#import <sys/utsname.h>

@implementation TXCustomTools

/**
 调起系统拨打电话
 
 @param phoneNo 电话号码
 */
+ (void)callStoreWithPhoneNo:(NSString *)phoneNo target:(UIViewController *)target {
    if ([NSString isTextEmpty:phoneNo]) {
        [ShowMessage showMessage:@"该门店没有留下电话哦！" withCenter:kShowMessageViewFrame];
    }else {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"呼叫门店" style:UIAlertActionStyleDefault handler:nil];
        [TXCustomTools setActionTitleTextColor:RGB(26, 26, 26) action:callAction];
        callAction.enabled = NO;
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:phoneNo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@", phoneNo];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVc dismissViewControllerAnimated:true completion:nil];
        }];

        [alertVc addAction:callAction];
        [alertVc addAction:noAction];
        [alertVc addAction:cancelAction];
        
        [target presentViewController:alertVc animated:true completion:nil];
    }
}

/**
 跳转容器详情控制器
 
 @param parentVC    父控制器
 @param childVC     子控制器
 @param orderNo     订单编号
 */
+ (void)pushContainerVCWithParentVC:(UIViewController *)parentVC childVC:(UIViewController<ZJScrollPageViewChildVcDelegate> *)childVC orderNo:(NSString *)orderNo indexPage:(NSInteger)index {
    TXAllDetailViewController *vc = [TXAllDetailViewController new];
    vc.orderDetailVc = childVC;
    vc.orderNo = orderNo;
    vc.selectedIndex = index;
    [parentVC.navigationController pushViewController:vc animated:false];
}

/**
 设置alert按钮颜色
 
 @param color
 @param action
 */
+ (void)setActionTitleTextColor:(UIColor *)color action:(UIAlertAction *)action {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
        [action setValue:color forKey:@"titleTextColor"];
    }
}

+ (float)customPopBarItemX {
    if ([[TXCustomTools deviceModelName] isEqualToString:@"iPhone 6 Plus"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 6s Plus"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 7 Plus"] ||
        [[TXCustomTools deviceModelName] isEqualToString:@"iPhone 7s Plus"]) {
        return 9.0;
    } else {
        return 5.0;
    }
}

+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"] || [deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"] || [deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"] || [deviceModel isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,2"] || [deviceModel isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"] || [deviceModel isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    return deviceModel;
}

+ (void)customHeaderRefreshWithScrollView:(UIScrollView *)scrollView refreshingTarget:(id)target refreshingAction:(SEL)action {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 76; i++) {
        NSString *str;
        if (i <10) {
            str = [NSString stringWithFormat:@"loading_000%d", i];
        }else{
            str = [NSString stringWithFormat:@"loading_00%d", i];
        }
        UIImage *image = [UIImage imageNamed:str];
        [arr addObject:image];
    }
    
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    [gifHeader setImages:@[[UIImage imageNamed:@"loading_0000"]] forState:MJRefreshStatePulling];
    [gifHeader setImages:arr duration:1.0 forState:MJRefreshStateRefreshing];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    gifHeader.stateLabel.hidden = YES;
    scrollView.mj_header = gifHeader;
}

/**
 根据给定颜色 生成图片

 @param color
 @return 
 */
+ (UIImage*)createImageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//随机颜色
+ (UIColor *)randomColor {
    NSArray <UIColor *>*colorsArray = @[[UIColor colorWithRed:0.9 green:0.79 blue:0.74 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.86 blue:0.89 alpha:1.0],
                             [UIColor colorWithRed:0.89 green:0.88 blue:0.9 alpha:1.0],
                             [UIColor colorWithRed:0.85 green:0.89 blue:0.9 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.88 blue:0.86 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.84 blue:0.78 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.83 blue:0.77 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.8 blue:0.82 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.88 blue:0.87 alpha:1.0],
                             [UIColor colorWithRed:0.84 green:0.89 blue:0.9 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.75 blue:0.69 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.87 blue:0.85 alpha:1.0],
                             [UIColor colorWithRed:0.9 green:0.84 blue:0.83 alpha:1.0],
                             [UIColor colorWithRed:0.85 green:0.78 blue:0.9 alpha:1.0]];
    
    NSInteger index = arc4random()%14;
    
    return colorsArray[index];
}


@end

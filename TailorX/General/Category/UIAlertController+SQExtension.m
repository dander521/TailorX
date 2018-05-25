//
//  UITextView+TXPlaceholder.m
//  TailorX
//
//  Created by RogerChen on 23/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "UIAlertController+SQExtension.h"

@implementation UIAlertController (SQExtension)

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)target{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title ? title : @"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:sureAction];
    [target presentViewController:alertVc animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonAction:(void (^)())buttonAction target:(UIViewController *)target{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title ? title : @"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (buttonAction) {
            buttonAction();
        }
    }];
    [alertVc addAction:sureAction];
    [target presentViewController:alertVc animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message actionsMsg:(NSArray *)actionMsg buttonActions:(void (^)(NSInteger))buttonAction target:(UIViewController*)target{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title ? title : @"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [actionMsg enumerateObjectsUsingBlock:^(NSString*  _Nonnull actionMsgStr, NSUInteger index, BOOL * _Nonnull stop) {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (index != 0) {
            style = UIAlertActionStyleCancel;
        }
            UIAlertAction *actions = [UIAlertAction actionWithTitle:actionMsgStr style:style handler:^(UIAlertAction * _Nonnull action) {
                if (index == 0) {
                    if (buttonAction) {
                        buttonAction(index);
                    }
                }else {
                    [alertVc dismissViewControllerAnimated:YES completion:nil];
                    buttonAction(index);
                }
               
            }];
        
        if ([actions.title isEqualToString:@"取消"] || [actions.title isEqualToString:@"去注册"]) {
            [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:actions];
        }
            [alertVc addAction:actions];
    }];
    [target presentViewController:alertVc animated:YES completion:nil];
}

+(void)showAlertWithMessage:(NSString *)message target:(UIViewController *)target {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:sureAction];
    [target presentViewController:alertVc animated:YES completion:nil];
}

+ (void)showAlertWithPreferredStyle:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actionsMsg:(NSArray *)actionMsg buttonActions:(void (^)(NSInteger))buttonAction target:(UIViewController *)target {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    [actionMsg enumerateObjectsUsingBlock:^(NSString*  _Nonnull actionMsgStr, NSUInteger index, BOOL * _Nonnull stop) {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (index == 2) {
            style = UIAlertActionStyleCancel;
        }
        UIAlertAction *actions = [UIAlertAction actionWithTitle:actionMsgStr style:style handler:^(UIAlertAction * _Nonnull action) {
            if (index == 0) {
                if (buttonAction) {
                    buttonAction(index);
                }
            }else {
                    buttonAction(index);
            }
        }];
        if (index == 0) {
            [TXCustomTools setActionTitleTextColor:RGB(26, 26, 26) action:actions];
            actions.enabled = NO;
        }
        [alertVc addAction:actions];
    }];
    [target presentViewController:alertVc animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title msg:(NSString *)message actionsMsg:(NSArray *)actionMsg buttonActions:(void (^)(NSInteger))buttonAction target:(UIViewController*)target{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMessageStr addAttribute:NSForegroundColorAttributeName value: RGB(0, 0, 0) range:NSMakeRange(0,message.length)];
    [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,message.length)];
    [alertVc setValue:alertMessageStr forKey:@"attributedMessage"];
    
    [actionMsg enumerateObjectsUsingBlock:^(NSString*  _Nonnull actionMsgStr, NSUInteger index, BOOL * _Nonnull stop) {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (index != 0) {
            style = UIAlertActionStyleCancel;
        }
        UIAlertAction *actions = [UIAlertAction actionWithTitle:actionMsgStr style:style handler:^(UIAlertAction * _Nonnull action) {
            if (index == 0) {
                if (buttonAction) {
                    buttonAction(index);
                }
            }else {
                [alertVc dismissViewControllerAnimated:YES completion:nil];
                buttonAction(index);
            }
            
        }];
        [alertVc addAction:actions];
    }];
    [target presentViewController:alertVc animated:YES completion:nil];
}

+ (void)showAlertWithStyle:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actionsMsg:(NSArray *)actionMsg buttonActions:(void (^)(NSInteger))buttonAction target:(UIViewController *)target {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    [actionMsg enumerateObjectsUsingBlock:^(NSString*  _Nonnull actionMsgStr, NSUInteger index, BOOL * _Nonnull stop) {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (index == 2) {
            style = UIAlertActionStyleCancel;
        }
        UIAlertAction *actions = [UIAlertAction actionWithTitle:actionMsgStr style:style handler:^(UIAlertAction * _Nonnull action) {
            if (index == 0) {
                if (buttonAction) {
                    buttonAction(index);
                }
            }else {
                buttonAction(index);
            }
        }];
        [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:actions];;
        if (index == 2) {
            [TXCustomTools setActionTitleTextColor:[[ThemeManager shareManager]loadThemeColorWithName:@"theme_color"] action:actions];
        }
        [alertVc addAction:actions];
    }];
    [target presentViewController:alertVc animated:YES completion:nil];
}


@end

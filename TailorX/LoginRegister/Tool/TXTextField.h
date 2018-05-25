//
//  TXTextField.h
//  TailorX
//
//  Created by Qian Shen on 29/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXTextField : UIView

/** 注释信息*/
@property (nonatomic,copy)   NSString *placeholder;
/** 文本框 */
@property (nonatomic,strong) UITextField *textField;

- (void)changeFrameOfPlaceholder;

@end

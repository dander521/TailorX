//
//  TXKeyboardBar.h
//  TailorX
//
//  Created by liuyanming on 2017/3/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXKeyboardBar : UIView

@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet UIView  *midLine;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView  *rightMiddleView;

+ (instancetype)instanse;

@end

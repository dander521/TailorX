//
//  TXRulesView.h
//  TailorX
//
//  Created by Qian Shen on 29/6/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXRulesView : UIView

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

+ (instancetype)creationRulesView;

@end

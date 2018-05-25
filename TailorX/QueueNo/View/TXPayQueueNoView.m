//
//  TXPayQueueNoView.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPayQueueNoView.h"

@interface TXPayQueueNoView ()

@property (weak, nonatomic) IBOutlet UILabel *preNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *practicalMoneyLabel;

@end

@implementation TXPayQueueNoView

+ (instancetype)instanse {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    
}



@end

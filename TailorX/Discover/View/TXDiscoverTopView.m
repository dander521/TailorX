//
//  TXDiscoverTopView.m
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDiscoverTopView.h"

@interface TXDiscoverTopView ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
/** 最新发布*/
@property (weak, nonatomic) IBOutlet UIButton *latestBtn;
/** 热度优先*/
@property (weak, nonatomic) IBOutlet UIButton *heatBtn;
/** 筛选*/
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@end

@implementation TXDiscoverTopView

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (IBAction)touchLatestBtn:(id)sender {
    
    [self.latestBtn setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    [self.heatBtn setTitleColor:RGB(204, 204, 204) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomLine.frame = CGRectMake(15,48,60,2);
    }];
    
    if ([self.delegate respondsToSelector:@selector(touchLatestBtn)]) {
        [self.delegate touchLatestBtn];
    }
}

- (IBAction)touchHeatBtn:(id)sender {
    [self.heatBtn setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    [self.latestBtn setTitleColor:RGB(204, 204, 204) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomLine.frame = CGRectMake(122,48,60,2);
    }];
    if ([self.delegate respondsToSelector:@selector(touchHeatBtn)]) {
        [self.delegate touchHeatBtn];
    }
}

- (IBAction)touchFilterBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchFilterBtn)]) {
        [self.delegate touchFilterBtn];
    }
}

@end

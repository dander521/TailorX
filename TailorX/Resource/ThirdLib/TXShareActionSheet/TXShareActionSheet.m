//
//  TXShareActionSheet.m
//  TailorX
//
//  Created by Qian Shen on 9/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXShareActionSheet.h"

@interface TXShareActionSheet ()


/** 遮罩*/
@property (nonatomic, strong) UIView *bgView;

/** 可点击区域*/
@property (nonatomic, strong) UIView *clickView;

@end

@implementation TXShareActionSheet

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    TXShareActionSheet *sheet = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    sheet.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260);
    return sheet;
}

-(void)showWithweChat:(WeChatBlock)weChat FriendCircle:(FriendCircleBlock)friendCircle Qq:(QQBlock)qq {
    [self show];
    self.weChatBlock = weChat;
    self.friendCircleBlock = friendCircle;
    self.qqBlock = qq;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _bgView.alpha = 0;
    [window addSubview:_bgView];
    
    _clickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.bounds.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
    [_clickView addGestureRecognizer:tap];
    [window addSubview:_clickView];
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT + self.bounds.size.height, SCREEN_WIDTH, self.bounds.size.height);
    [window addSubview:self];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT-self.bounds.size.height, SCREEN_WIDTH, self.bounds.size.height);
        _bgView.alpha = 1;
    }completion:^(BOOL finished) {
    
    }];
}

- (void)dismissView {
    [self dismiss:0.35];
}

- (void)dismiss:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT + self.bounds.size.height, SCREEN_WIDTH, self.bounds.size.height);
        _bgView.alpha = 0;
    }completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_clickView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (IBAction)clickWxBtn:(UIButton *)sender {
    [self dismiss:0.2];
    if (self.weChatBlock) {
        self.weChatBlock();
    }
}

- (IBAction)clickPyqBtn:(UIButton *)sender {
    [self dismiss:0.2];
    if (self.friendCircleBlock) {
        self.friendCircleBlock();
    }
}

- (IBAction)clickQqBtn:(UIButton *)sender {
    [self dismiss:0.2];
    if (self.qqBlock) {
        self.qqBlock();
    }
}



@end

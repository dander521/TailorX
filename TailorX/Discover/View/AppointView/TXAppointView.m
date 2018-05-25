//
//  TXAppointView.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAppointView.h"

@interface TXAppointView () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;


@end

@implementation TXAppointView

+ (instancetype)shareInstanceManager {
    TXAppointView *instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    instance.backgroundColor = RGBA(0, 0, 0, 0.4);
    return instance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //代码
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

// 点击背景
- (void)tapGestrueMethod:(UITapGestureRecognizer *)gesture {
    [self hide];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag == 100) {
        return false;
    }
    return true;
}


- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.center = view.center;
    self.alpha = 0;
    self.showImageView.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.showImageView.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.showImageView.transform  = CGAffineTransformScale(self.transform, 0.1, 0.1);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setAppointType:(TXAppointViewType)appointType {
    _appointType = appointType;
    
    if (appointType == TXAppointViewTypeStore) {
        self.showImageView.image = [UIImage imageNamed:@"img_appoint_store"];
    } else {
        self.showImageView.image = [UIImage imageNamed:@"img_appoint_designer"];
    }
}


- (IBAction)touchSureBtn:(id)sender {
    [self hide];
    if ([self.delegate respondsToSelector:@selector(touchSureButton)]) {
        [self.delegate touchSureButton];
    }
}

@end

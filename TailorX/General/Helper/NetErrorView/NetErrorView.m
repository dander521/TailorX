
//  NetErrorView.m
//  iOS开发常见技术-每日一记
//
//  Created by Qian Shen on 2017/3/4.
//  Copyright © 2017年 Qian Shen. All rights reserved.
//

#import "NetErrorView.h"
#import "Masonry.h"

@interface NetErrorView ()


/**加载动画*/
@property (nonatomic,strong)UIImageView *animationImgView;
/**加载失败or断网*/
@property (nonatomic,strong)UILabel *contentL;
/**点击屏幕重新加载*/
@property (nonatomic, strong) UILabel *descL;
/**点击手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tap;
/**错误页容器*/
@property (nonatomic, strong) UIView *errorBgView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation NetErrorView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNotifation object:nil];
        
        [self setUpViews];
    }
    return self;
}

- (void)themeChangeAction {
    UIImage *img = [UIImage imageNamed:@"ic_main_default_wifi"];
    self.statusImgView.image = img;
}


- (void)setUpViews {
    
    self.errorBgView = [[UIView alloc] initWithFrame:self.bounds];
    self.errorBgView.userInteractionEnabled = YES;
    [self addSubview:self.errorBgView];
    self.errorBgView.hidden = YES;
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"ic_nav_arrow"] forState:UIControlStateNormal];
    self.backBtn.hidden = YES;
    [self.errorBgView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.errorBgView.mas_left).offset(0);
        make.top.mas_equalTo(self.errorBgView.mas_top).offset(0);
        make.width.mas_equalTo(@46);
        make.height.mas_equalTo(@84);
    }];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hanleTap:)];
    [self.errorBgView addGestureRecognizer:_tap];
    
    UIImage *img = [UIImage imageNamed:@"ic_main_default_wifi"];
    self.statusImgView = [[UIImageView alloc] initWithImage:img];
    [self.errorBgView addSubview:self.statusImgView];
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0).offset(-80);
    }];

    
    self.contentL = [[UILabel alloc]init];
    self.contentL.text = @"网络请求失败";
    self.contentL.font = [UIFont systemFontOfSize:15.0];
    self.contentL.textColor = RGB(153, 153, 153);
    [self.errorBgView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_statusImgView.mas_bottom).offset(20);
    }];

    
    self.descL = [[UILabel alloc]init];
    self.descL.text = @"请检查你的网络，点击屏幕，重新加载";
    self.descL.textColor = RGB(187, 187, 187);
    self.descL.font = [UIFont systemFontOfSize:14.0];
    [self.errorBgView addSubview:self.descL];
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_contentL.mas_bottom).offset(20);
    }];
    
    self.animationImgView= [[UIImageView alloc]init];
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
    self.animationImgView.animationImages = arr;
    self.userInteractionEnabled = YES;
    [self.animationImgView setAnimationDuration:1.0];
    [self.animationImgView setAnimationRepeatCount:0];
    [self.animationImgView startAnimating];
    [self addSubview:self.animationImgView];
    [self.animationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-30);
    }];
}

- (void)startAnimaiton {
    self.animationImgView.hidden = NO;
    [self.animationImgView startAnimating];
    self.errorBgView.hidden = YES;
}


- (void)stopNetViewLoadingFail:(BOOL)fail error:(BOOL)error {
    [self.animationImgView stopAnimating];
    self.containerView.userInteractionEnabled = true;
    self.animationImgView.hidden = YES;
    if (fail || error) {
        self.errorBgView.hidden = NO;
        if (fail) {
            self.contentL.text = @"网络请求失败";
            UIImage *img = [UIImage imageNamed:@"ic_main_default_wifi"];
            self.statusImgView.image = img;
        }else{
            self.contentL.text = @"加载数据失败";
            UIImage *img = [UIImage imageNamed:@"ic_main_audit_failure"];
            self.statusImgView.image = img;
        }
    }else{

        self.errorBgView.hidden = YES;
        [self removeFromSuperview];
    }
}

- (void)showAddedTo:(UIView *)view isClearBgc:(BOOL)isClearBgc {
    self.containerView = view;
    self.containerView.userInteractionEnabled = false;
    [view addSubview:self];
    if (isClearBgc) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
    
    [self startAnimaiton];
}

- (void)hanleTap:(UIGestureRecognizer*)gesture {
    [self startAnimaiton];
    if ([self.delegate respondsToSelector:@selector(reloadDataNetErrorView:)]) {
        [self.delegate reloadDataNetErrorView:self];
    }
}


@end








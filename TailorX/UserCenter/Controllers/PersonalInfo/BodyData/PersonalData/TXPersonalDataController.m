//
//  TXFavoriteViewController.m
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPersonalDataController.h"
#import "ZJScrollPageView.h"
#import "TXBodyDataDetialController.h"
#import "TXReferencePictureController.h"
@interface TXPersonalDataController () <ZJScrollPageViewDelegate>
@property(strong, nonatomic) NSArray<NSString *> *titles;
@property(strong, nonatomic) NSArray<UIViewController *> *childVcs;
@property(strong, nonatomic) ZJScrollPageView *scrollPageView;
@property(nonatomic, assign) NSInteger currentVcIndex;
@property(nonatomic, strong) UIButton *rightBtn;
@end

@implementation TXPersonalDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupscrollPageView];
    
    [self setUpChildVcs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollPageView.segmentView.scrollLine.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Config ViewControllers

- (void)setUpChildVcs {
    self.childVcs = [NSArray arrayWithObjects:[TXReferencePictureController new], [TXBodyDataDetialController new], nil];
}

- (void)setupscrollPageView {
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.titleBigScale = 1.f;;
    style.segmentHeight = 44;
    style.gradualChangeTitleColor = true;
    style.autoAdjustTitlesWidth = true;
    style.scrollTitle = false;
    style.titleFont = [UIFont boldSystemFontOfSize:17];
    style.normalTitleColor = RGB(204, 204, 204);
    style.selectedTitleColor = RGB(46, 46, 46);
    style.styleFrame = CGRectMake(SCREEN_WIDTH/2-100, 20, 200, 42);
    self.titles = @[@"参考图片",
                    @"量体数据",
                    ];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kTopHeight - 64, self.view.bounds.size.width, SCREEN_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    // 设置阴影
    scrollPageView.isShow = YES;
    [self.view addSubview:scrollPageView];
    
    [self setUpPopButton];
}

/**
 设置返回按钮
 */
- (void)setUpPopButton {
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(5.5, kTopHeight - 37, 34, 30);
    [popBtn setImage:[UIImage imageNamed:@"ic_nav_arrow"] forState:UIControlStateNormal];
    [popBtn setBackgroundColor:[UIColor clearColor]];
    [popBtn addTarget:self action:@selector(touchPopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
}

- (void)touchPopButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if (index == 0) {
        TXReferencePictureController *childVc = (TXReferencePictureController*)reuseViewController;
        if (childVc == nil) {
            childVc = (TXReferencePictureController *)self.childVcs[index];
        }
        return childVc;
    }
    else if (index == 1) {
        TXBodyDataDetialController *childVc = (TXBodyDataDetialController *)reuseViewController;
        if (childVc == nil) {
            childVc = (TXBodyDataDetialController *)self.childVcs[index];
        }
        
        return childVc;
    }
    return nil;
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}



@end

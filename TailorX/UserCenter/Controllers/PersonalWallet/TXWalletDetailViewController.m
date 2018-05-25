//
//  TXWalletDetailViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/6/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXWalletDetailViewController.h"
#import "ZJScrollPageView.h"
#import "TXTransDetailController.h"

@interface TXWalletDetailViewController () <ZJScrollPageViewDelegate>

@property(strong, nonatomic) NSArray<NSString *> *titles;
@property(strong, nonatomic) NSArray<UIViewController *> *childVcs;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@property (nonatomic, strong) UILabel *label2;

@end

@implementation TXWalletDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.scrollPageView.segmentView.scrollLine.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    
    [self.scrollPageView setSelectedIndex:_index animated:YES];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"明细";
    [self setupscrollPageView];
    [self setUpPopButton];
}

/**
 设置返回按钮
 */
- (void)setUpPopButton {
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake([TXCustomTools customPopBarItemX], kTopHeight - 37, 34, 30);
    [popBtn setImage:[UIImage imageNamed:@"ic_nav_arrow"] forState:UIControlStateNormal];
    [popBtn setBackgroundColor:[UIColor clearColor]];
    [popBtn addTarget:self action:@selector(touchPopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
}

- (void)touchPopButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)setupscrollPageView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    self.titles = @[@"余额明细",@"收益明细"];
    
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    self.scrollPageView.isShow = true;
    [self.view addSubview:self.scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if (index == 0) {
        TXTransDetailController *childVc = (TXTransDetailController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TXTransDetailController alloc] init];
        }
        childVc.accountType = @"022";
        return childVc;
    } else if (index == 1) {
        TXTransDetailController *childVc = (TXTransDetailController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TXTransDetailController alloc] init];
        }
        childVc.accountType = @"023";
        return childVc;
    }
    return nil;
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    _index = index;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


@end

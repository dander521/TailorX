//
//  TXAllDetailViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/6/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAllDetailViewController.h"
#import "UINavigationBar+Awesome.h"
#import "TXProcessNodeViewController.h"

@interface TXAllDetailViewController () <ZJScrollPageViewDelegate>

/** segment titles */
@property(strong, nonatomic) NSArray <NSString *>*titles;
/** 子控制器 */
@property(strong, nonatomic) NSArray <UIViewController *>*childVcs;

@end

@implementation TXAllDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器属性
    [self configViewController];
    // 设置controller容器
    [self setupscrollPageView];
    // 设置返回按钮
    [self setUpPopButton];
    
}

#pragma mark - Initial Method

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

/**
 设置控制器属性
 */
- (void)configViewController {
    self.view.backgroundColor = [UIColor whiteColor];
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

/**
 设置controller容器
 */
- (void)setupscrollPageView {
    self.automaticallyAdjustsScrollViewInsets = false;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.titleBigScale = 1.f;;
    style.segmentHeight = 44;
    style.gradualChangeTitleColor = true;
    style.autoAdjustTitlesWidth = true;
    style.scrollTitle = false;
    style.scrollLineColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    style.titleFont = [UIFont boldSystemFontOfSize:17];
    style.normalTitleColor = RGB(204, 204, 204);
    style.selectedTitleColor = RGB(46, 46, 46);
    style.styleFrame = CGRectMake(SCREEN_WIDTH/2-100, 20, 200, 42);
    self.titles = @[@"订单详情",
                    @"定制进度"];
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kTopHeight - 64, self.view.bounds.size.width, SCREEN_HEIGHT)
                                                     segmentStyle:style
                                                           titles:self.titles
                                             parentViewController:self
                                                         delegate:self];
    // 设置阴影
    self.scrollPageView.isShow = YES;
    [self.scrollPageView setSelectedIndex:self.selectedIndex animated:false];
    [self.view addSubview:self.scrollPageView];
}

#pragma mark - ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    TXProcessNodeViewController *nodeVc = [TXProcessNodeViewController new];
    nodeVc.orderNo = self.orderNo;
    NSArray *vwcArrays = @[self.orderDetailVc,nodeVc];
    return vwcArrays[index];;
}

#pragma mark - UIContainerViewControllerCallbacks

// 该方法返回NO则childViewController不会自动viewWillAppear和viewWillDisappear对应的方法
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

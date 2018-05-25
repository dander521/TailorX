//
//  TXProductCollectionViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductCollectionViewController.h"
#import "TXWorksViewController.h"
#import "TXProductionListViewController.h"

@interface TXProductCollectionViewController () <ZJScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;


@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation TXProductCollectionViewController

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
//    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupscrollPageView];
    [self setUpPopButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.titles = @[@"设计作品",@"成交作品"];
    
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
        TXWorksViewController *childVc = (TXWorksViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TXWorksViewController alloc] init];
        }
        childVc.designerId = self.designerId;
        childVc.isCollection = true;
        return childVc;
    } else if (index == 1) {
        TXProductionListViewController *childVc = (TXProductionListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TXProductionListViewController alloc] init];
        }
        childVc.designerId = self.designerId;
        childVc.isCollection = true;
        return childVc;
    }
    return nil;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    _index = index;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

@end

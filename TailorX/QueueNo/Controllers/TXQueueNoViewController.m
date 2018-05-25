//
//  QueueNoViewController.m
//  TailorX
//
//  Created by Roger on 17/3/14.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXQueueNoViewController.h"
#import "ZJScrollPageView.h"
#import "TXMyQueueNoController.h"
#import "TXTradeQueueNoController.h"
#import "TXTransRecordController.h"

@interface TXQueueNoViewController () <ZJScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation TXQueueNoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
     self.scrollPageView.segmentView.scrollLine.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];

    [self.scrollPageView setSelectedIndex:_index animated:YES];
    [TXKVPO setIsInfomation:@"0"];
    [TXKVPO setIsDiscover:@"0"];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"排号";
    [self setupscrollPageView];
    
    [self setUpRightButton];
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
    self.titles = @[@"我的排号",@"排号交易"];
    
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kTopHeight - 64, self.view.bounds.size.width, SCREEN_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];

    // 设置阴影
    self.scrollPageView.isShow = YES;
    [self.view addSubview:self.scrollPageView];
}

/**
 * 设置明细按钮
 */
- (void)setUpRightButton {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 46, kTopHeight - 37, 34, 30);
    [rightBtn setImage:[UIImage imageNamed:@"ic_nav_details"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemAuction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}


- (void)rightBarButtonItemAuction {
    if ([GetUserInfo.isLogin integerValue] == 1) {
        TXTransRecordController *vc = [[TXTransRecordController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [TXServiceUtil LoginController:(TXNavigationViewController *)self.navigationController];
    }
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if (index == 0) {
        TXMyQueueNoController *childVc = (TXMyQueueNoController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TXMyQueueNoController alloc] init];
        }
        childVc.isQuickProduce = self.isQuickProduce;
        return childVc;
    } else if (index == 1) {
        TXTradeQueueNoController *childVc = (TXTradeQueueNoController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TXTradeQueueNoController alloc] init];
        }
        childVc.isQuickProduce = self.isQuickProduce;
        return childVc;
    }
    return nil;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    _index = index;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    if (index == 1) {
//        _rightBtn.hidden = NO;
//    }else {
//        _rightBtn.hidden = YES;
//    }
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

@end

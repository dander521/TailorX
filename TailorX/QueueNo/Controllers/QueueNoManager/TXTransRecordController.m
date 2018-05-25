//
//  TXTransRecordController.m
//  TailorX
//
//  Created by liuyanming on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTransRecordController.h"
#import "ZJScrollPageView.h"
#import "TXTransRecordOutController.h"
#import "TXTransRecordIntoController.h"

@interface TXTransRecordController ()<ZJScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;

@end

@implementation TXTransRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器属性
    [self configViewController];
    
    [self setupscrollPageView];
    
    [self setUpPopButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Config ViewController

/**
 * 设置控制器属性
 */
- (void)configViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"交易记录";
}

/**
 * 设置返回按钮
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
    style.styleFrame = CGRectMake(SCREEN_WIDTH/2-65, 20, 130, 42);
    self.titles = @[@"买入",
                    @"卖出",
                    ];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kTopHeight - 64, self.view.bounds.size.width, SCREEN_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    // 设置阴影
    scrollPageView.isShow = YES;
    [self.view addSubview:scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}


- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if (index == 0) {
        TXTransRecordIntoController *childVc = (TXTransRecordIntoController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TXTransRecordIntoController alloc] init];
        }
        return childVc;
        
    } else if (index == 1) {
        TXTransRecordOutController *childVc = (TXTransRecordOutController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[TXTransRecordOutController alloc] init];
        }
        return childVc;
    }
    return nil;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

@end

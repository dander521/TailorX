//
//  TXAllDesignerViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/8/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAllDesignerViewController.h"
#import "TXDesignerListViewController.h"

@interface TXAllDesignerViewController ()<ZJScrollPageViewDelegate>

@property(strong, nonatomic) NSArray<NSString *> *titles;
@property(strong, nonatomic) NSArray<UIViewController *> *childVcs;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation TXAllDesignerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部设计师";
    [self setupscrollPageView];
}

- (void)setupscrollPageView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.titleBigScale = 1.f;;
    style.segmentHeight = 44;
    style.gradualChangeTitleColor = true;
    style.autoAdjustTitlesWidth = true;
    style.scrollTitle = false;
    style.showLine = true;
    style.adjustCoverOrLineWidth = true;
    style.scrollLineColor = RGB(46, 46, 46);
    style.titleFont = [UIFont boldSystemFontOfSize:15];
    style.normalTitleColor = RGB(204, 204, 204);
    style.selectedTitleColor = RGB(46, 46, 46);
    self.titles = @[@"推荐",@"好评",@"人气"];
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kTopHeight, self.view.bounds.size.width, SCREEN_HEIGHT-kTopHeight) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view addSubview:self.scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    UIViewController <ZJScrollPageViewChildVcDelegate>*resultVC = nil;
    if (index == 0) {
        TXDesignerListViewController *vwcDesignerList = [TXDesignerListViewController new];
        vwcDesignerList.designerType = TXDesignerOrderTypeRecommand;
        vwcDesignerList.isSelect = self.isSelect;
        resultVC = vwcDesignerList;
    } else if (index == 1) {
        TXDesignerListViewController *vwcDesignerList = [TXDesignerListViewController new];
        vwcDesignerList.designerType = TXDesignerOrderTypeLike;
        vwcDesignerList.isSelect = self.isSelect;
        resultVC = vwcDesignerList;
    } else {
        TXDesignerListViewController *vwcDesignerList = [TXDesignerListViewController new];
        vwcDesignerList.designerType = TXDesignerOrderTypeFavorite;
        vwcDesignerList.isSelect = self.isSelect;
        resultVC = vwcDesignerList;
    }
    return resultVC;
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

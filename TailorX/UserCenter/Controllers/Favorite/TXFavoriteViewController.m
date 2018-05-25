//
//  TXFavoriteViewController.m
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFavoriteViewController.h"
#import "TXGradientLabel.h"
#import "ZJScrollSegmentView.h"
#import "TXFavoriteChoiceViewController.h"
#import "TXFavoriteDesigneViewController.h"
#import "TXFromTransition.h"
#import "TXInformationDetailViewController.h"
#import "TXDiscoverDetailCollectionViewController.h"

@interface TXFavoriteViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate>

/** 内容scrollView*/
@property (nonatomic,strong)UIScrollView *contentScrollView;
/** 标题*/
@property(nonatomic,strong)NSArray *titles;
/** 标题*/
@property (nonatomic, weak) ZJScrollSegmentView *segmentView;
/** 当前脚标*/
@property (assign, nonatomic) NSInteger currentIndex;
/** 原脚标*/
@property (assign, nonatomic) NSInteger oldIndex;
/** 原偏移量*/
@property (assign, nonatomic) CGFloat oldOffSetX;
/** 处理ZJScrollSegmentView滚动的计算*/
@property (assign, nonatomic) BOOL forbidTouchToAdjustPosition;
/** 收藏资讯*/
@property (nonatomic, strong) TXFavoriteChoiceViewController *informationView;
/** 收藏图片*/
@property (nonatomic, strong) TXFavoriteChoiceViewController *pictureView;
/** 收藏设计师*/
@property (nonatomic, strong) TXFavoriteDesigneViewController *designeView;

@end


@implementation TXFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController.delegate) {
        self.navigationController.delegate = nil;
    }
}

- (void)cancelNavigationControllerDelegate {
    if (self.navigationController.delegate) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark - init

- (void)initializeDataSource {
    self.titles = @[@"时尚资讯",@"精选图片"];
    self.forbidTouchToAdjustPosition = NO;
    self.currenCollectionView = self.informationView.mainCollectionView;
}

- (void)initializeInterface {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    weakSelf(self);
    ZJScrollSegmentView *segmentView = [[ZJScrollSegmentView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, 60)  segmentStyle:style delegate:nil titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
        weakSelf.forbidTouchToAdjustPosition = YES;
        [weakSelf.contentScrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:NO];
        if (index == 0) {
            weakSelf.currenCollectionView = weakSelf.informationView.mainCollectionView;
        }else if (index == 1) {
            weakSelf.currenCollectionView = weakSelf.pictureView.mainCollectionView;
        }
    }];
    self.segmentView = segmentView;
    [self.view addSubview:self.segmentView];
    
    [self setupContentScrollView];
    
    [self setupContentViews];
}

- (void)setupContentScrollView {
    UIScrollView *contentScrollView = [[UIScrollView alloc]init];
    contentScrollView.frame = CGRectMake(0,CGRectGetMaxY(self.segmentView.frame),SCREEN_WIDTH , SCREEN_HEIGHT - 124);
    contentScrollView.bounces = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.contentSize = CGSizeMake(self.titles.count*SCREEN_WIDTH, 0);
    contentScrollView.backgroundColor = [UIColor redColor];
    self.contentScrollView = contentScrollView;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];
}

- (void)setupContentViews {
    [self.contentScrollView addSubview:self.informationView];
    [self.contentScrollView addSubview:self.pictureView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.forbidTouchToAdjustPosition || scrollView.contentOffset.x <= 0 ||
        scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
        return;
    }
    CGFloat tempProgress = scrollView.contentOffset.x / SCREEN_WIDTH;
    NSInteger tempIndex = tempProgress;
    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - _oldOffSetX;
    if (deltaX > 0) {
        if (progress == 0.0) {
            return;
        }
        self.currentIndex = tempIndex+1;
        self.oldIndex = tempIndex;
    }else if (deltaX < 0) {
        progress = 1.0 - progress;
        self.oldIndex = tempIndex+1;
        self.currentIndex = tempIndex;
    }else {
        return;
    }
    [self contentViewDidMoveFromIndex:_oldIndex toIndex:_currentIndex progress:progress];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x / SCREEN_WIDTH);
    if (currentIndex == 0) {
        self.currenCollectionView = self.informationView.mainCollectionView;
    }else if (currentIndex == 1) {
        self.currenCollectionView = self.pictureView.mainCollectionView;
    }
    [self contentViewDidMoveFromIndex:currentIndex toIndex:currentIndex progress:1.0];
    [self adjustSegmentTitleOffsetToCurrentIndex:currentIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldOffSetX = scrollView.contentOffset.x;
    self.forbidTouchToAdjustPosition = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UINavigationController *navi = (UINavigationController *)self.parentViewController.parentViewController;
    if ([navi isKindOfClass:[UINavigationController class]] && navi.interactivePopGestureRecognizer) {
        navi.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[TXInformationDetailViewController class]]) {
        return [[TXFromTransition alloc]initWithTransitionType:TransitionFavoriteInformation];
    }else if (fromVC == self && [toVC isKindOfClass:[TXDiscoverDetailCollectionViewController class]]){
        return [[TXFromTransition alloc]initWithTransitionType:TransitionFavoritePicture];
    }else {
        return nil;
    }
}

#pragma mark - private helper

- (void)contentViewDidMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.segmentView adjustUIWithProgress:progress oldIndex:fromIndex currentIndex:toIndex];
}

- (void)adjustSegmentTitleOffsetToCurrentIndex:(NSInteger)index {
    [self.segmentView adjustTitleOffSetToCurrentIndex:index];
}


#pragma mark - setters

- (TXFavoriteChoiceViewController *)informationView {
    if (!_informationView) {
        _informationView = [[TXFavoriteChoiceViewController alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-124) viewType:TXWaterfallColCellTypeInformation];
    }
    return _informationView;
}

- (TXFavoriteChoiceViewController *)pictureView {
    if (!_pictureView) {
        _pictureView = [[TXFavoriteChoiceViewController alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-124)viewType:TXWaterfallColCellTypeDiscover];
    }
    return _pictureView;
}


@end

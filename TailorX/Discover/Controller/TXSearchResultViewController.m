//
//  TXSearchResultViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSearchResultViewController.h"
#import "TXSearchTopView.h"
#import "TXHotSearchView.h"
#import "TXHeatViewController.h"
#import "TXDiscoverDetailCollectionViewController.h"
#import "TXFromTransition.h"

@interface TXSearchResultViewController ()<TXSearchTopViewDelegate, UITextFieldDelegate, TXHotSearchViewDelegate, TXHeatViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) TXHotSearchView *hotView;
@property (nonatomic, strong) TXSearchTopView *topView;
@property (nonatomic, strong) UITextField *topSearchTF;
@property (nonatomic, strong) TXHeatViewController *heatView;

@end

@implementation TXSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.snapshotView];
    [self.view addSubview:self.hotView];
    [self.view addSubview:self.topView];
}

- (void)textFieldDidChanged {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TXSearchTopViewDelegate

- (void)touchCancelButton {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([NSString isTextEmpty:textField.text]) {
        [ShowMessage showMessage:@"请输入搜索内容"];
        return false;
    }
    
    [self.topSearchTF resignFirstResponder];
    self.hotView.hidden = true;
    self.heatView.keyString = textField.text;
    self.topView.viewType = TXSearchTopViewTypeSearch;
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 114);
    weakSelf(self);
    self.heatView.sizeBlock = ^(NSInteger size) {
        weakSelf.topView.resultLabel.text = [NSString stringWithFormat:@"搜索结果共%zd条", size];
    };
    self.currenCollectionView = self.heatView.collectionView;
    [self.view insertSubview:self.heatView belowSubview:self.topView];
    return true;
}

#pragma mark - TXHotSearchViewDelegate

- (void)didSelectItemWithString:(NSString *)searchString {
    self.hotView.hidden = true;
    self.heatView.keyString = searchString;
    self.topView.viewType = TXSearchTopViewTypeSearch;
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 114);
    weakSelf(self);
    self.heatView.sizeBlock = ^(NSInteger size) {
        weakSelf.topView.resultLabel.text = [NSString stringWithFormat:@"搜索结果共%zd条", size];
    };
    self.currenCollectionView = self.heatView.collectionView;
    [self.view insertSubview:self.heatView belowSubview:self.topView];
}

#pragma mark - TXHeatViewDelegate

- (void)scrollHeatScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

}

- (void)scrollHeatScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)touchHeatDesignerButtonWithDesignerId:(NSString *)designerId {
    
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([fromVC isKindOfClass:[TXSearchResultViewController class]] && [toVC isKindOfClass:[TXDiscoverDetailCollectionViewController class]]) {
        return [[TXFromTransition alloc] initWithTransitionType:TransitionSearch];
    }else {
        return nil;
    }
}

#pragma mark - Lazy

- (TXSearchTopView *)topView {
    if (!_topView) {
        _topView = [TXSearchTopView instanceView];
        _topView.delegate = self;
        _topView.viewType = TXSearchTopViewTypeOrigin;
        self.topSearchTF = _topView.searchTF;
        self.topSearchTF.delegate = self;
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
    }
    
    return _topView;
}

- (TXHotSearchView *)hotView {
    if (!_hotView) {
        _hotView = [TXHotSearchView instanceView];
        _hotView.dataSource = @[@"长腿", @"少女", @"设计感", @"显瘦", @"简单", @"时髦", @"休闲", @"大衣", @"百搭", @"个性"];
        _hotView.delegate = self;
        _hotView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight);
    }
    return _hotView;
}

- (TXHeatViewController *)heatView {
    if (!_heatView) {
        _heatView = [[TXHeatViewController alloc] initWithFrame:CGRectMake(0, 50 + kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - kTopHeight) heatType:TXHeatViewTypeSearch];
        _heatView.delegate = self;
    }
    return _heatView;
}
 

@end

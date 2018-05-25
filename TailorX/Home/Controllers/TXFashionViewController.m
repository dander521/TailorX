//
//  TXFashionViewController.m
//  TailorX
//
//  Created by Qian Shen on 15/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFashionViewController.h"
#import "XRWaterfallLayout.h"
#import "TXInformationListModel.h"
#import "TXWaterfallColCell.h"
#import "TXInformationDetailViewController.h"
#import "TXFromTransition.h"

static NSString *cellID = @"TXWaterfallColCell";

@interface TXFashionViewController ()<XRWaterfallLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NetErrorViewDelegate,TXWaterfallColCellDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>

/** 自定义布局 */
@property (nonatomic, strong) XRWaterfallLayout *waterfall;
/** 模糊查询资讯列表数组 */
@property (nonatomic, strong) NSMutableArray<TXInformationListModel*> *informationListDataAry;
/** 返回顶部的按钮*/
@property (nonatomic, strong) UIButton *returnTopBtn;
/** 保存之前的偏移量*/
@property (nonatomic, assign) CGFloat oldOffset;
/** 上拉刷新*/
@property (nonatomic, assign, getter=isPullUp) BOOL pullUp;
/** 下拉加载*/
@property (nonatomic, assign, getter=isPullDown) BOOL pullDown;
/** 初始化页码*/
@property (nonatomic, assign) NSInteger page;
/** 每一页的总条数*/
@property (nonatomic, assign) NSInteger dataCount;
/** 每页条数*/
@property (nonatomic, assign) NSInteger pageLength;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;

@end

@implementation TXFashionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsScrollViewInsets_NO(self.collectionView, self);
    [self initializeDataSource];
    
    [self initializeInterface];
}


#pragma mark - init

- (void)initializeDataSource {
    
    self.informationListDataAry = [@[]mutableCopy];
    
    self.pullUp = NO;
    self.pullDown = NO;
    self.page = 0;
    self.pageLength = 10;
    self.dataCount = 0;
    
    [self loadData];
}

- (void)initializeInterface {
    
    self.navigationItem.title = [NSString isTextEmpty:self.naviTitle] ? @"专区详情" : self.naviTitle;
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.returnTopBtn];
    [self.returnTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
    }];
    
    [self.view addSubview:self.errorView];
    // 用户成功登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationLoginSuccess  object:nil];
    // 退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginstatusChanged) name:kNSNotificationLogout object:nil];
    
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

- (void)userLoginstatusChanged {
    [self loadNewData];
}

#pragma mark - methods

- (void)loadData {
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:@(_page) forKey:@"page"];
    [dict setValue:@(_pageLength) forKey:@"pageLength"];
    [dict setValue:self.infoGroupId forKey:@"infoGroupId"];
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strInformationGroupInfo completion:^(id responseObject, NSError *error) {
        if (error) {
            if (self.isPullUp || self.isPullDown) {
                [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            }else {
                [self.errorView stopNetViewLoadingFail:YES error:NO];
            }
            [self stopRefreshing];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                NSArray *dicArr = responseObject[kData][kData];
                if (self.isPullDown && !self.isPullUp) {
                    [self.informationListDataAry removeAllObjects];
                }
                self.dataCount = dicArr.count;
                [self.informationListDataAry addObjectsFromArray:[TXInformationListModel mj_objectArrayWithKeyValuesArray:dicArr]];
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                [self.collectionView reloadData];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    [ShowMessage showMessage:responseObject[kMsg] withCenter:self.view.center];
                }else{
                    [self.errorView stopNetViewLoadingFail:NO error:YES];
                }
            }
            [self stopRefreshing];
        }
    }isLogin:^{
        [self stopRefreshing];
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)loadNewData {
    _page = 0;
    self.pullDown = YES;
    self.pullUp = NO;
    [self loadData];
}
- (void)loadMoreData {
    _page += 1;
    self.pullUp = YES;
    self.pullDown = NO;
    if (self.dataCount < self.pageLength) {
        [self stopRefreshing];
        [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

- (void)stopRefreshing {
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark - XRWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    TXInformationListModel *model = self.informationListDataAry[indexPath.row];
    CGFloat imgHeight = model.height == 0 ? 3000 : model.height;
    CGFloat imgWidth = model.width == 0 ? 2000 :model.width;
    return imgHeight / imgWidth * width + 100;
}

/**
 * 行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

/**
 * 垂直间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XRWaterfallLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.informationListDataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXInformationListModel *model = self.informationListDataAry[indexPath.row];
    TXWaterfallColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.infomationModel = model;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXInformationListModel *model = self.informationListDataAry[indexPath.row];
    TXInformationDetailViewController *vc = [[TXInformationDetailViewController alloc]init];
    TXWaterfallColCell *cell = (TXWaterfallColCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    vc.informationNo = model.informationNo;
    vc.coverUrl = model.coverUrl;
    vc.coverImgWidth = model.width;
    vc.coverImgHeight = model.height;
    vc.isFavorited = model.isLiked;
    vc.currenIndexPath = indexPath;
    vc.shareBlock = ^ () {
        model.shareCount += 1;
        if (model.shareCount >= 1000) {
            cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%0.1fk",model.shareCount/1000.0];
        }else {
            cell.amountOfReadingLabel.text = [NSString stringWithFormat:@"%@",@(model.shareCount)];
        }
    };
    vc.favoriteChangedBlock = ^ (BOOL isFavorite) {
        model.isLiked = isFavorite;
        if (isFavorite == true) {
            model.popularity += 1;
        }else {
            model.popularity > 0 ? (model.popularity -= 1) : (model.popularity = 0);
        }
        if (model.popularity >= 1000) {
            cell.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",model.popularity/1000.0];
        }else {
            cell.popularityLabel.text = [NSString stringWithFormat:@"%@",@(model.popularity)];
        }
        if (model.isLiked == 0) {
            [cell.likedBtn setImage:[UIImage imageNamed:@"ic_main_big"] forState:UIControlStateNormal];
        }else if (model.isLiked == 1) {
            [cell.likedBtn setImage:[UIImage imageNamed:@"ic_main_big-1"] forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [cell.contentView layoutIfNeeded];
        [cell layoutIfNeeded];
        [collectionView layoutIfNeeded];
    });
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[TXInformationDetailViewController class]]) {
        return [[TXFromTransition alloc]initWithTransitionType:TransitionInformation];
    }else {
        return nil;
    }
}

#pragma mark - TXWaterfallColCellDelegate

- (void)waterfallColCell:(TXWaterfallColCell *)waterfallColCell clickLikedBtn:(UIButton *)sender ofInformationModel:(TXInformationDetailModel *)model {
    // 取消收藏
    if (model.isLiked == YES) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *dict = [@{}mutableCopy];
        [dict setValue:model.informationNo forKey:@"infoNos"];
        [TXNetRequest informationRequestMethodWithParams:dict relativeUrl:strInformationDeleteFavoriteInfo completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    model.isLiked = false;
                    model.popularity > 0 ? (model.popularity -= 1) : (model.popularity = 0);
                    [sender setImage:[UIImage imageNamed:@"ic_main_big"] forState:UIControlStateNormal];
                    if (model.popularity >= 1000) {
                        waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",model.popularity/1000.0];
                    }else {
                        waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%@",@(model.popularity)];
                    }
                    [ShowMessage showMessage:@"已取消关注" withCenter:kShowMessageViewFrame];
                    [MBProgressHUD hideHUDForView:self.view];
                } else {
                    [ShowMessage showMessage:@"取消关注失败" withCenter:kShowMessageViewFrame];
                    [MBProgressHUD hideHUDForView:self.view];
                }
            } else {
                [ShowMessage showMessage:error.description withCenter:kShowMessageViewFrame];
                [MBProgressHUD hideHUDForView:self.view];
            }
        }isLogin:^{
            [MBProgressHUD hideHUDForView:self.view];
            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        }];
    }
    // 增加收藏
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *dict = [@{}mutableCopy];
        [dict setValue:model.informationNo forKey:@"infoNo"];
        [TXNetRequest informationRequestMethodWithParams:dict relativeUrl:strInformationAddFavoriteInfo completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    model.isLiked = YES;
                    model.popularity += 1;
                    [sender setImage:[UIImage imageNamed:@"ic_main_big-1"] forState:UIControlStateNormal];
                    if (model.popularity >= 1000) {
                        waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%0.1fk",model.popularity/1000.0];
                    }else {
                        waterfallColCell.popularityLabel.text = [NSString stringWithFormat:@"%@",@(model.popularity)];
                    }
                    [ShowMessage showMessage:@"关注成功" withCenter:kShowMessageViewFrame];
                    [MBProgressHUD hideHUDForView:self.view];
                } else {
                    [ShowMessage showMessage:@"关注失败" withCenter:kShowMessageViewFrame];
                    [MBProgressHUD hideHUDForView:self.view];
                }
            } else {
                [ShowMessage showMessage:error.description withCenter:kShowMessageViewFrame];
                [MBProgressHUD hideHUDForView:self.view];
            }
        }isLogin:^{
            [MBProgressHUD hideHUDForView:self.view];
            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        }];
    }
}


#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.waterfall = [[XRWaterfallLayout alloc]init];
        self.waterfall.delegate = self;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) collectionViewLayout:self.waterfall];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        [TXCustomTools customHeaderRefreshWithScrollView:_collectionView refreshingTarget:self refreshingAction:@selector(loadNewData)];
        _collectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _collectionView;
}

- (UIButton *)returnTopBtn {
    if (!_returnTopBtn) {
        _returnTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnTopBtn.hidden = YES;
        [_returnTopBtn setImage:[UIImage imageNamed:@"ic_main_stick_top_3.2.0"] forState:UIControlStateNormal];
    }
    return _returnTopBtn;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
}

@end

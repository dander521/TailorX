//
//  TXDiscoverDetailCollectionViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDiscoverDetailCollectionViewController.h"
#import "TXDiscoverDetailCollectionViewCell.h"
#import "XRWaterfallLayout.h"
#import "TXToTransition.h"
#import "TXFromTransition.h"
#import "TXDiscoveViewController.h"
#import "TXFavoriteViewController.h"
#import "TXDiscoverBottomView.h"
#import "TXReservaDesingerViewController.h"
#import "TXShareActionSheet.h"
#import "TXSearchResultViewController.h"
#import "TXAppointView.h"

static NSString *cellID = @"TXDiscoverDetailCollectionViewCell";

#define collectionImg [UIImage imageNamed:@"ic_nav_press_collection_3.2.1"]
#define notCollectionImg [UIImage imageNamed:@"ic_nav_default_collection_3.2.1"]

@interface TXDiscoverDetailCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TXDiscoverBottomViewDelegate, TXAppointViewDelegate>

/** 瀑布流布局*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/** 首图高度*/
@property (nonatomic, assign) CGFloat coverImgHeight;
/** 自定义导航条*/
@property (nonatomic, strong) TXDiscoverBottomView *bottomView;

@end

@implementation TXDiscoverDetailCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cacheDictionary = [NSMutableDictionary new];
    self.toSelectedId = self.fromSelectedId + 1;
    [self.view addSubview:self.collectionView];
    adjustsScrollViewInsets_NO(self.collectionView, self);
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    
    _bottomView.favoriteBtn.normalImg = self.model.favorite ? collectionImg : notCollectionImg;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoadDataSuccess) name:kNotificationDiscoverAutoLoadDataSuccess object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    self.headerView.hidden = true;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController.delegate) {
        self.navigationController.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification

- (void)autoLoadDataSuccess {
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pictureDetailArray.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXDiscoverDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.isHeat = self.isHeat;
    cell.fromSelectedId = self.toSelectedId + indexPath.row;
    cell.pictureDetailArray = self.pictureDetailArray;
    cell.superViewController = self;
    cell.model = self.pictureDetailArray[indexPath.row];
    return cell;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if (scrollView.contentOffset.y <= 10 && scrollView.contentOffset.y > 0) {
        self.bottomView.shadowView.hidden = YES;
    }else{
        self.bottomView.shadowView.hidden = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    self.currenIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.model = [self.pictureDetailArray objectAtIndex:self.currenIndex];
    [self.headerView.coverImgView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl]];
    self.bottomView.favoriteBtn.normalImg = self.model.favorite ? collectionImg : notCollectionImg;
    
    if (self.pictureDetailArray.count - self.currenIndex == 5) {
        // 上一级页面通知通知
        NSString *notificationName = self.isHeat ? kNotificationDiscoverItemPanHeat : kNotificationDiscoverItemPanLatest;
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self.model userInfo:nil];
        // 详情页当前通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDiscoverDetailItemPan object:self.model userInfo:@{@"from":[NSString stringWithFormat:@"%zd", self.fromSelectedId]}];
    }
    
    // 上一级页面通知通知
    NSString *notificationName = self.isHeat ? kNotificationDiscoverItemScrollHeat : kNotificationDiscoverItemScrollLatest;
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self.model userInfo:@{@"from":[NSString stringWithFormat:@"%zd", self.fromSelectedId]}];
    // 详情页当前通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDiscoverDetailItemScroll object:self.model userInfo:@{@"from":[NSString stringWithFormat:@"%zd", self.fromSelectedId]}];
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    self.model = [self.pictureDetailArray objectAtIndex:self.currenIndex];
    
    if (fromVC == self && [toVC isKindOfClass:[TXDiscoveViewController class]]) {
        return [[TXToTransition alloc] initWithTransitionType:TransitionPicture currenIndexPath:self.model.indexPath];
    }else if (fromVC == self && [toVC isKindOfClass:[TXFavoriteViewController class]]) {
        return [[TXToTransition alloc] initWithTransitionType:TransitionFavoritePicture currenIndexPath:self.model.indexPath];
    }else if (fromVC == self && [toVC isKindOfClass:[TXSearchResultViewController class]]) {
        return [[TXToTransition alloc] initWithTransitionType:TransitionSearch currenIndexPath:self.model.indexPath];
    }else {
        if (operation == UINavigationControllerOperationPush) {
            if (fromVC == self && [toVC isKindOfClass:[TXDiscoverDetailCollectionViewController class]]) {
                return [[TXFromTransition alloc] initWithTransitionType:TransitionRecommend];
            }
        }else {
            if ([toVC isKindOfClass:[TXDiscoverDetailCollectionViewController class]] && fromVC == self) {
                return [[TXToTransition alloc] initWithTransitionType:TransitionRecommend currenIndexPath:self.model.indexPath];
            }
        }
        return nil;
    }
}

#pragma mark - TXDiscoverBottomViewDelegate

- (void)respondsToFavoriteBtn:(TXFavoriteButton *)favoriteBtn {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        // 取消收藏
        if (self.model.favorite == YES) {
            [favoriteBtn dismissAnimation];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSMutableDictionary *dict = [@{}mutableCopy];
            [dict setValue:self.model.ID forKey:@"pictureId"];
            [TXNetRequest informationRequestMethodWithParams:dict relativeUrl:strUserCenterAddOrCancelFavoritePicture completion:^(id responseObject, NSError *error) {
                if (responseObject) {
                    if ([responseObject[@"success"] boolValue]) {
                        self.model.favorite = false;
                        self.model.favoriteCount > 0 ? ( self.model.favoriteCount -= 1) : (self.model.favoriteCount = 0);
                        [ShowMessage showMessage:@"已取消收藏" withCenter:kShowMessageViewFrame];
                        if (self.favoriteBlock) {
                            self.favoriteBlock(false);
                        }
                        [MBProgressHUD hideHUDForView:self.view];
                        TXDiscoverDetailCollectionViewCell *cell = (TXDiscoverDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currenIndex inSection:0]];
                        cell.reusableHeaderView.pictureDetailModel = [self.model transformListModelToDetailModel];
                    } else {
                        [ShowMessage showMessage:@"取消收藏失败" withCenter:kShowMessageViewFrame];
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
            [favoriteBtn showAnimation];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSMutableDictionary *dict = [@{}mutableCopy];
            [dict setValue:self.model.ID forKey:@"pictureId"];
            [TXNetRequest informationRequestMethodWithParams:dict relativeUrl:strUserCenterAddOrCancelFavoritePicture completion:^(id responseObject, NSError *error) {
                if (responseObject) {
                    if ([responseObject[@"success"] boolValue]) {
                        self.model.favorite = YES;
                        self.model.favoriteCount += 1;
                        [ShowMessage showMessage:@"收藏成功" withCenter:kShowMessageViewFrame];
                        if (self.favoriteBlock) {
                            self.favoriteBlock(true);
                        }
                        [MBProgressHUD hideHUDForView:self.view];
                        TXDiscoverDetailCollectionViewCell *cell = (TXDiscoverDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currenIndex inSection:0]];
                        cell.reusableHeaderView.pictureDetailModel = [self.model transformListModelToDetailModel];
                    } else {
                        [ShowMessage showMessage:@"收藏失败" withCenter:kShowMessageViewFrame];
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
}

- (void)respondsToBackBtn:(UIButton*)sender {
    self.headerView.hidden = NO;
    TXDiscoverDetailCollectionViewCell *cell = (TXDiscoverDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currenIndex inSection:0]];
    [cell.collectionView setContentOffset:CGPointMake(0, 0)];
    self.collectionView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToSharBtn:(UIButton*)sender {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        NSMutableDictionary *dict = [@{}mutableCopy];
        [dict setValue:self.model.ID forKey:@"pictureId"];
        [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strDiscoverSharePicture completion:^(id responseObject, NSError *error) {
            if (error) {
                return;
            }
            if (responseObject) {
                if ([responseObject[kSuccess] boolValue]) {
                    self.model.shareCount += 1;
                    if (self.shareBlock) {
                        self.shareBlock();
                    }
                    
                    TXDiscoverDetailCollectionViewCell *cell = (TXDiscoverDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currenIndex inSection:0]];
                    cell.reusableHeaderView.pictureDetailModel = [self.model transformListModelToDetailModel];
                }
            }
        }isLogin:^{
            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        }];
        [self shareAction];
    }
}

- (void)respondsToAppointmentBtn:(UIButton*)sender {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        [TXKVPO setIsInfomation:@"1"];
        TXInformationClassModel *model = [TXInformationClassModel sharedTXInformationClassModel];
        
        model.pictureID = self.model.ID;
        model.infoPicUrl = self.model.imgUrl;
        
        if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
            TXAppointView *appointView = [TXAppointView shareInstanceManager];
            appointView.delegate = self;
            appointView.appointType = TXAppointViewTypeDesigner;
            [appointView show];
        }
    }
}

#pragma mark - TXAppointViewDelegate

- (void)touchSureButton {
    TXReservaDesingerViewController *vc = [TXReservaDesingerViewController new];
    vc.isHeadImgBtnClick = YES;
    vc.designerId = self.model.designerId;
    vc.customType = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareAction {
    TXShareActionSheet *actionSheet = [TXShareActionSheet instanceView];
    [actionSheet showWithweChat:^{
        [self shareContentWithPlatform:UMSocialPlatformType_WechatSession];
    } FriendCircle:^{
        [self shareContentWithPlatform:UMSocialPlatformType_WechatTimeLine];
    } Qq:^{
        [self shareContentWithPlatform:UMSocialPlatformType_QQ];
    }];
}

-(void)shareContentWithPlatform:(UMSocialPlatformType) platform {
    NSString *url = [NSString stringWithFormat:@"%@%@",strDiscoverShareUrl,self.model.ID];
    NSString *title = self.model.desc;
    NSString *content = self.model.designerIntroduction;
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:self.model.imgUrl];
    //设置网页地址
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"分享失败"];
        } else {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

#pragma mark - getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        self.flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[TXDiscoverDetailCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currenIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    }
    return _collectionView;
}

- (TXInfomationHeadView *)headerView {
    if (!_headerView) {
        _headerView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXInfomationHeadView" owner:nil options:nil] lastObject];
        CGFloat height = self.model.height == 0 ? 3000 : self.model.height;
        CGFloat width = self.model.width == 0 ? 2000 : self.model.width;
        self.coverImgHeight = height / width * SCREEN_WIDTH+16;
        _headerView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, self.coverImgHeight);
        [_headerView.coverImgView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl]];
    }
    return _headerView;
}

- (TXDiscoverBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXDiscoverBottomView" owner:nil options:nil] lastObject];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
        [_bottomView.shareBtn addTarget:self action:@selector(respondsToSharBtn:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.delegate = self;
        [_bottomView.appointmentBtn addTarget:self action:@selector(respondsToAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.backBtn addTarget:self action:@selector(respondsToBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.shadowView.hidden = YES;
        _bottomView.favoriteBtn.normalImg = self.model.favorite ? collectionImg : notCollectionImg;
    }
    return _bottomView;
}

@end

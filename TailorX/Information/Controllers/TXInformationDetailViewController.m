//
//  TXInformationDetailViewController.m
//  TailorX
//
//  Created by 温强 on 2017/4/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInformationDetailViewController.h"
#import "TXFavoriteViewController.h"
// V
#import "TXInformationDetailCell.h"
#import "SDCycleScrollView.h"
#import "NetErrorView.h"
#import "TXInformationCommentTableViewCell.h"
#import "TXReservaDesingerViewController.h"
#import "TXDesignerDetailController.h"
#import "TXInfomationDescTabCell.h"
#import "TXInfomationHeaderTabCell.h"
#import "TXInfomationHeadView.h"
#import "TXInformationBottomView.h"
#import "TXPublishedView.h"
#import "ReachabilityUtil.h"

// M
#import "TXInformationDetailModel.h"
#import "TXInformationDetailDesListModel.h"
#import "MSSBrowseModel.h"

// C
#import "TXInformationDataTool.h"

#import "TXInformationMoreCommentViewController.h"
#import "MSSBrowseNetworkViewController.h"
#import "IQKeyboardManager.h"

#import "TXShareActionSheet.h"
#import "TXToTransition.h"

#import "TXFashionViewController.h"
#import "TXIndicatorView.h"
#import "TXAppointView.h"
// T

#define kTotalWords 200

#define collectionImg [UIImage imageNamed:@"ic_nav_press_collection_3.2.1"]
#define notCollectionImg [UIImage imageNamed:@"ic_nav_default_collection_3.2.1"]


@interface TXInformationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NetErrorViewDelegate,TXInformationOrderDelegate,UIGestureRecognizerDelegate,TXInformationBottomViewDelegate,TXInfomationHeadViewDelegate, TXAppointViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SDCycleScrollView *bannerView;
/** 网络状态页 */
@property (nonatomic, strong) NetErrorView *errorView;
/** 资讯详情模型 */
@property (nonatomic, strong) TXInformationDetailModel *informationDetailModel;
/** 头图高度*/
@property (nonatomic, assign) CGFloat imageOriginHight;
/** 顶部点赞视图*/
@property (nonatomic, strong) TXInformationBottomView *bottomView;
/** 遮罩*/
@property (nonatomic, strong) TXIndicatorView *maskView;


@end

static NSString * InformationDetailCellID = @"TXInformationDetailCell";
static NSString * InformationCommentCellID = @"TXInformationCommentTableViewCell";
static NSString * InfomationDescTabCellID = @"TXInfomationDescTabCell";
static NSString * InfomationHeaderTabCellID = @"TXInfomationHeaderTabCell";

@implementation TXInformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeInterface];
    
    [self initializeDataSource];
    
    // 接收登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuceess:) name:kNSNotificationLoginSuccess  object:nil];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bottomView.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.bottomView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

#pragma mark - init

- (void)initializeDataSource {
    
    [self.maskView showMaskIndicatorViewTopLayout:_imageOriginHight + 70 inView:self.view];
    [self loadData];
}

- (void)initializeInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.errorView];
    
    [self.headerView.photoImgView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.view.mas_left).offset(16);
     }];
    
    [self.view addSubview:self.bottomView];
}

#pragma mark - methods

- (void)loadData {
    // 加载资讯详情
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.informationNo forKey:@"informationNo"];
    [TXNetRequest informationRequestMethodWithParams:params relativeUrl:strInformationGetInformationDetail completion:^(id responseObject, NSError *error) {
        [self.maskView hiddenMaskIndicatorView];
        if (responseObject) {
          if ([responseObject[@"success"] boolValue]) {
              self.informationDetailModel = [TXInformationDataTool getInformationDetailModelFromData:responseObject];
              NSArray<TagsCommonInfo*> *tagInfos = [TagsCommonInfo mj_objectArrayWithKeyValuesArray:self.informationDetailModel.commonList];
              if (tagInfos.count == 0) {
                  self.informationDetailModel.tags = @"";
              }
              NSMutableString *tempStr = [NSMutableString string];
              for (NSInteger i = 0; i < tagInfos.count; i ++) {
                  if (![NSString isTextEmpty:tagInfos[i].tagName]) {
                      if (i != tagInfos.count-1) {
                          [tempStr appendString:[NSString stringWithFormat:@"%@、",tagInfos[i].tagName]];
                      }else {
                          [tempStr appendString:[NSString stringWithFormat:@"%@",tagInfos[i].tagName]];
                      }
                  }
              }
              self.informationDetailModel.tags = [tempStr copy];
              self.headerView.informationModel = self.informationDetailModel;
              [UIView performWithoutAnimation:^{
                  CGPoint offset = self.tableView.contentOffset;
                  [self.tableView reloadData];
                  [self.tableView layoutIfNeeded]; // 强制更新
                  [self.tableView setContentOffset:offset];
              }];
          } else {
              [ShowMessage showMessage:responseObject[kMsg]];
          }
        } else {
          [ShowMessage showMessage:error.localizedDescription];
        }
      }isLogin:^{
          [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.informationDetailModel) {
        return 0;
    }else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.informationDetailModel.desList.count;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // 标签
        case 0: {
            TXInfomationHeaderTabCell *cell = [tableView dequeueReusableCellWithIdentifier:InfomationHeaderTabCellID];
            cell.informationDetailModel = self.informationDetailModel;
            return cell;
        }
        // 设计师相关信息
        case 1: {
            TXInfomationDescTabCell *cell = [tableView dequeueReusableCellWithIdentifier:InfomationDescTabCellID];
            [cell.favoriteBtn addTarget:self action:@selector(respondsToFavoriteDesingerBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.headBtn addTarget:self action:@selector(respondsToHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.model = self.informationDetailModel;
            return cell;
        }
        // 详情
        case 2: {
            NSArray *listAry = self.informationDetailModel.desList;
            TXInformationDetailDesListModel *model = listAry[indexPath.row];
            TXInformationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationDetailCellID forIndexPath:indexPath];
            cell.model = model;
            cell.index = indexPath.row;
            cell.delegate = self;
            return cell;
        }
        default:
            return nil;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if (scrollView.contentOffset.y <= 10) {
        self.bottomView.shadowView.hidden = YES;
    }else {
        self.bottomView.shadowView.hidden = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(scrollView.contentOffset.y <= -70) {
        [self respondsToBackBtn:nil];
    }
}

#pragma mark - TXInfomationHeadViewDelegate

- (void)infomationHeadView:(TXInfomationHeadView *)headView clickHeadImgView:(UIImageView *)imgView {
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
    browseItem.bigImageUrl = self.coverUrl;// 加载网络图片大图地址\
    browseItem.smallImageView = imgView;
    [browseItemArray addObject:browseItem];
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:0];
    [vwcBrowse showBrowseViewController];
}

#pragma mark - event

- (void)respondsToBackBtn:(UIButton*)sender {
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    NSLog(@"%@--",NSStringFromCGRect(self.headerView.frame));
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToSharBtn:(UIButton*)sender {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        NSMutableDictionary *dict = [@{}mutableCopy];
        [dict setValue:self.informationDetailModel.informationNo forKey:@"informationNo"];
        [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strShareInformation completion:^(id responseObject, NSError *error) {
            if (error) {
                return;
            }
            if (responseObject) {
                if ([responseObject[kSuccess] boolValue]) {
                    if (self.shareBlock) {
                        self.shareBlock();
                    }
                }
            }
        }isLogin:^{
            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        }];
        [self shareAction];
    }
}

- (void)respondsToCommentBtn:(UIButton*)sender {
    TXInformationMoreCommentViewController *vc = [[TXInformationMoreCommentViewController alloc] init];
    vc.informationNo = self.informationNo;
    weakSelf(self);
    vc.commentSuccessBlock = ^{
        [weakSelf loadData];
    };
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;// 可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:vc animated:false];
}

- (void)respondsToFavoriteDesingerBtn:(UIButton*)sender {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        if (![ReachabilityUtil checkCurrentNetworkState]) {
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            return;
        }
        //参数0则进行取消，参数1则收藏。 默认为1
        NSString *stuta = self.informationDetailModel.favoriteDesigner ? @"0" : @"1";
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:stuta forKey:@"stutas"];
        [dict setValue:@(self.informationDetailModel.designerId) forKey:@"designerId"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeLikeOrabolishDesigner completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                if ([responseObject[kSuccess] boolValue]) {
                    if ([stuta isEqualToString:@"0"]) {
                        [ShowMessage showMessage:@"已取消关注" withCenter:self.view.center];
                        self.informationDetailModel.favoriteDesigner = false;
                    } else {
                        [ShowMessage showMessage:@"关注成功" withCenter:self.view.center];
                        self.informationDetailModel.favoriteDesigner = true;
                    }
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                } else {
                    [ShowMessage showMessage:responseObject[kMsg] withCenter:self.view.center];
                }
            } else {
                [ShowMessage showMessage:kErrorTitle withCenter:self.view.center];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }isLogin:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        }];
    }
}

- (void)respondsToHeadBtn:(UIButton*)sender {
    TXDesignerDetailController *designerDetailVc = [[TXDesignerDetailController alloc] init];
    designerDetailVc.bEnterStoreDetail = YES;
    designerDetailVc.designerId = [NSString stringWithFormat:@"%ld",(long)self.informationDetailModel.designerId];
    designerDetailVc.isHavaCommitBtn = YES;
    [self.navigationController pushViewController:designerDetailVc animated:YES];
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

- (void)shareContentWithPlatform:(UMSocialPlatformType)platform {
    NSString *url = [NSString stringWithFormat:@"%@%@",strInfomationShareUrl,self.informationDetailModel.informationNo];
    NSString *title = self.informationDetailModel.name;
    NSString *content = self.informationDetailModel.desc;
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:self.coverUrl];
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

#pragma mark - Favorite

- (void)addFavorite {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:self.informationNo forKey:@"infoNo"];
    [TXNetRequest informationRequestMethodWithParams:dic relativeUrl:strInformationAddFavoriteInfo completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            if ([responseObject[@"success"] boolValue]) {
                self.informationDetailModel.popularity += 1;
                if (self.favoriteChangedBlock) {
                    self.favoriteChangedBlock(YES);
                }
                self.isFavorited = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationFavoriteInformationChanged object:nil];
                [ShowMessage showMessage:@"收藏成功"];
                [MBProgressHUD hideHUDForView:self.view];
            } else {
                [ShowMessage showMessage:@"收藏失败"];
                [MBProgressHUD hideHUDForView:self.view];
            }
        } else {
                [ShowMessage showMessage:error.description];
                [MBProgressHUD hideHUDForView:self.view];
        }
    }isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)cancelFavorite {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest informationRequestMethodWithParams:@{@"infoNos" : self.informationNo} relativeUrl:strInformationDeleteFavoriteInfo completion:^(id responseObject, NSError *error) {
        if (responseObject) {
            if ([responseObject[@"success"] boolValue]) {
                self.informationDetailModel.popularity > 0 ? (self.informationDetailModel.popularity -= 1) : (self.informationDetailModel.popularity = 0);
                if (self.favoriteChangedBlock) {
                    self.favoriteChangedBlock(NO);
                }
                self.isFavorited = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationFavoriteInformationChanged object:nil];
                [ShowMessage showMessage:@"已取消收藏"];
                [MBProgressHUD hideHUDForView:self.view];
            } else {
                [ShowMessage showMessage:@"取消收藏失败"];
                 [MBProgressHUD hideHUDForView:self.view];
            }
        } else {
             [ShowMessage showMessage:error.description];
             [MBProgressHUD hideHUDForView:self.view];
        }
    }isLogin:^{
         [MBProgressHUD hideHUDForView:self.view];
         [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - TXInformationOrderDelegate

-(void)orderButtonActionDelegate:(NSDictionary *)info {
    [self.view endEditing:YES];
    [TXKVPO setIsInfomation:@"1"];
    TXInformationClassModel *model = [TXInformationClassModel sharedTXInformationClassModel];
    model.infoPicID = [info[@"infoPicID"] integerValue];
    model.infoPicUrl = info[@"infoPicUrl"];
    model.informationNo = self.informationNo;
    model.tags = self.informationDetailModel.tags;
    
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        TXAppointView *appointView = [TXAppointView shareInstanceManager];
        appointView.delegate = self;
        appointView.appointType = TXAppointViewTypeDesigner;
        [appointView show];
    }
}

#pragma mark - TXAppointViewDelegate

- (void)touchSureButton {
    TXReservaDesingerViewController *vc = [TXReservaDesingerViewController new];
    vc.isHeadImgBtnClick = YES;
    vc.designerId = [NSString stringWithFormat:@"%ld",self.informationDetailModel.designerId];
    vc.customType = NO;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)browseBigImageWithIndex:(NSInteger)index {
    [self.view endEditing:YES];
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    NSArray *listArray = self.informationDetailModel.desList;

    for(int i = 0;i < [listArray count];i++) {
        TXInformationDetailDesListModel *model = listArray[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = model.infoPic;// 加载网络图片大图地址
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    vwcBrowse.dismissAnimation = NO;
    vwcBrowse.dismissBlock = ^(NSIndexPath *currenIndexPath) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currenIndexPath.row inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    };
    [vwcBrowse showBrowseViewController];
}

#pragma mark - TXInformationBottomViewDelegate

- (void)respondsToFavoriteBtn:(TXFavoriteButton *)favoriteBtn {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        if (!self.isFavorited) {
            [favoriteBtn showAnimation];
            [self addFavorite];
        } else {
            [favoriteBtn dismissAnimation];
            [self cancelFavorite];
        }
    }
}

#pragma mark - netErrorView delegate

-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self loadData];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[TXFashionViewController class]]) {
        return [[TXToTransition alloc]initWithTransitionType:TransitionInformation currenIndexPath:self.currenIndexPath];
    }else if (fromVC == self && [toVC isKindOfClass:[TXFavoriteViewController class]]) {
        return [[TXToTransition alloc]initWithTransitionType:TransitionFavoriteInformation currenIndexPath:self.currenIndexPath];
    }else {
        return nil;
    }
}

#pragma mark - notify

- (void)userLoginSuceess:(NSNotification *)notification {
    [self loadData];
}

#pragma mark - getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView tableWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight) style:UITableViewStyleGrouped superView:self.view];
        _tableView.estimatedRowHeight = 10;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:InformationDetailCellID bundle:nil] forCellReuseIdentifier:InformationDetailCellID];
        [_tableView registerNib:[UINib nibWithNibName:InformationCommentCellID bundle:nil] forCellReuseIdentifier:InformationCommentCellID];
        [_tableView registerNib:[UINib nibWithNibName:InfomationDescTabCellID bundle:nil] forCellReuseIdentifier:InfomationDescTabCellID];
        [_tableView registerNib:[UINib nibWithNibName:InfomationHeaderTabCellID bundle:nil] forCellReuseIdentifier:InfomationHeaderTabCellID];
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    return _tableView;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,LayoutH(248.4)) delegate:nil placeholderImage:[UIImage imageNamed:@"ic_main_not_loaded_out_widther"]];
        _bannerView.pageDotImage = [UIImage imageNamed:@"ic_main_by_switching_circle.png"];
        _bannerView.currentPageDotImage = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_main_by_switching"];
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _bannerView.backgroundColor = RGB(240, 240, 240);
        _bannerView.showPageControl = NO;
    }
    return _bannerView;
}

- (NetErrorView *)errorView {
    if (_errorView == nil) {
        //_errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.backBtn.hidden = YES;
        _errorView.delegate = self;
    }
    return _errorView;
}

- (TXInfomationHeadView *)headerView {
    if (!_headerView) {
        _headerView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXInfomationHeadView" owner:nil options:nil] lastObject];
        CGFloat height = self.coverImgHeight == 0 ? 3000 : self.coverImgHeight;
        CGFloat width = self.coverImgWidth == 0 ? 2000 : self.coverImgWidth;
        _imageOriginHight = height / width * SCREEN_WIDTH + 15;
        _headerView.frame = CGRectMake(0, -_imageOriginHight, SCREEN_WIDTH, _imageOriginHight);
        [_headerView.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:self.coverUrl] imageViewWidth:0 placeholderImage:nil];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (TXInformationBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXInformationBottomView" owner:nil options:nil] lastObject];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
        [_bottomView.commentBtn addTarget:self action:@selector(respondsToCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.delegate = self;
        [_bottomView.shareBtn addTarget:self action:@selector(respondsToSharBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.backBtn addTarget:self action:@selector(respondsToBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.shadowView.hidden = YES;
        _bottomView.favoriteBtn.normalImg = self.isFavorited ? collectionImg : notCollectionImg;
    }
    return _bottomView;
}

- (TXIndicatorView *)maskView {
    if (!_maskView) {
        _maskView = [[[NSBundle mainBundle] loadNibNamed:@"TXIndicatorView" owner:nil options:nil] lastObject];
        _maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_maskView.backBtn addTarget:self action:@selector(respondsToBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

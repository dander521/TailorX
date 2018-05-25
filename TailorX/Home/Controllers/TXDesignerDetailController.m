//
//  TXDesignerDetailController.m
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignerDetailController.h"
#import "TXReservaDesingerViewController.h"
#import "MSSBrowseNetworkViewController.h"
#import "TXStoreDetailController.h"
#import "TXProductCollectionViewController.h"
#import "TXProductionListViewController.h"
#import "TXProductDetailViewController.h"

#import "TXDesignerHeaderCell.h"
#import "TXDesingerInfoTabCell.h"
#import "TXDesingerContactTabCell.h"
#import "TXDesignerCommentTabCell.h"
#import "TXCustomNavView.h"

#import "TXDesignerDetailModel.h"
#import "TXDesignerProductionListModel.h"
#import "TXDesignerCommentListModel.h"

#import "ReachabilityUtil.h"
#import "UINavigationBar+Awesome.h"
#import "TXWorksViewController.h"

#import "TXDesingerDetailTopView.h"
#import "TXSelectCommentTabCell.h"
#import "TXArthorInfoItemCell.h"

#import "UIButton+WebCache.h"

#import "TXAppointView.h"

#define kBtnHeight 49

#define collectionImg [UIImage imageNamed:@"ic_nav_press_collection_3.2.1"]
#define notCollectionImg [UIImage imageNamed:@"ic_nav_default_collection_3.2.1"]

static NSString *designerHeaderCellID = @"TXDesignerHeaderCell";
static NSString *desingerInfoCellID = @"TXDesingerInfoTabCell";
static NSString *desingerContactCellID = @"TXDesingerContactTabCell";
static NSString *designerCommentTabCellID = @"TXDesignerCommentTabCell";
static NSString *selectCommentTabCellcellID = @"TXSelectCommentTabCell";

typedef NS_ENUM(NSInteger, TXTabViewCellType) {
    TXTabViewCellHeader = 0,
    TXTabViewCellInfo, 
    TXTabViewCellContact,
    TXTabViewCellSelectComment,
    TXTabViewCellPraise
};

@interface TXDesignerDetailController ()<UITableViewDataSource,UITableViewDelegate,TXDesingerInfoTabCellDelegate,NetErrorViewDelegate,TXDesignerCommentTabCellDelegate,TXDesignerHeaderCellDelegate,TXDesingerDetailTopViewDelegate, TXAppointViewDelegate>

/** 列表*/
@property (nonatomic, strong) UITableView *tableView;
/** 设计师详情信息*/
@property (nonatomic, strong) TXDesignerDetailModel *designerDetailModel;
/** 作品信息(查看大图的数据源)*/
@property (nonatomic, strong) NSArray<TXDesignerProductionListModel*> *authorInfoArr;
/** 评论数*/
@property (nonatomic, strong) NSMutableArray<TXDesignerCommentListModel*> *praiseArr;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** 上拉加载*/
@property (nonatomic, assign, getter=isPullUp) BOOL pullUp;
/** 下拉刷新*/
@property (nonatomic, assign, getter=isPullDown) BOOL pullDown;
/** 初始化页码*/
@property (nonatomic, assign) NSInteger page;
/** 每一页的总条数*/
@property (nonatomic, assign) NSInteger dataCount;
/** 每页条数*/
@property (nonatomic, assign) NSInteger pageLength;
/** 评论的总条数*/
@property (nonatomic, strong) NSString *totalSize;
/** 设计师地址*/
@property (nonatomic, strong) NSString *designerAddress;
/** 自定义导航条*/
@property (nonatomic, strong) TXDesingerDetailTopView *topView;
@property (nonatomic, strong) NSMutableArray<TXProductListModel*> *productListArray;
@end

@implementation TXDesignerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    
    [self initializeInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - init 

- (void)initializeDataSource {
    
    self.praiseArr = [@[]mutableCopy];
    self.pullUp = NO;
    self.pullDown = NO;
    self.page = 0;
    self.dataCount = 0;
    self.pageLength = 10;
    
    [self loadData];
}

- (void)initializeInterface {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kTopHeight);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
    
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.errorView];
}

#pragma mark - methods

-(void)loadData {
    // 通过设计师ID查询设计师详情
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.designerId forKey:@"designerId"];
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeGetDesigner completion:^(id responseObject, NSError *error) {
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
                NSDictionary *dic = responseObject[kData];
                self.designerDetailModel = [TXDesignerDetailModel mj_objectWithKeyValues:dic];
                // 1:已收藏 ，0:未收藏
                if (self.designerDetailModel.isliked == 1) {
                    self.topView.favoriteBtn.normalImg = collectionImg;
                }else {
                    self.topView.favoriteBtn.normalImg = notCollectionImg;
                }
                self.designerAddress = self.designerDetailModel.storeAddress;
                // 根据设计师id查询所制作的作品
                [self getDesignerProductionList];
                // 获取成交作品
                [self loadDealProductData];
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

- (void)loadDealProductData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@(_page) forKey:@"page"];
    [params setValue:@(_pageLength) forKey:@"pageLength"];
    [params setValue:self.designerId forKey:@"designerId"];
    [TXNetRequest homeRequestMethodWithParams:params relativeUrl:strFindRecommendDesignerWorkList completion:^(id responseObject, NSError *error) {
        if (error) {
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                
                TXProductListCollectionModel *collectionModel = [TXProductListCollectionModel mj_objectWithKeyValues:responseObject];
                self.productListArray = [NSMutableArray arrayWithArray:collectionModel.data];
                [self.tableView reloadData];
            }else{
                [ShowMessage showMessage:responseObject[kMsg]];
            }
        }
    }isLogin:^{
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/**
 * 根据设计师id查询所制作的作品
 */
- (void)getDesignerProductionList {
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.designerId forKey:@"id"];
    [dict setValue:@"0" forKey:@"page"];
    [dict setValue:@"10" forKey:@"pageLength"];
    [TXNetRequest homeRequestMethodWithParams:dict
                                  relativeUrl:strHomeGetDesignerProductionList
                                   completion:^(id responseObject, NSError *error)
     {
         if (error) {
             if (self.isPullUp || self.isPullDown) {
                 [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
                 if (self.isPullUp) {
                     _page -= 1;
                 }
             }else {
                 [self.errorView stopNetViewLoadingFail:YES error:NO];
             }
             [self stopRefreshing];
             return;
         }
         if (responseObject) {
             if ([responseObject[kSuccess] boolValue]) {
                 NSArray *dicArr = responseObject[kData][kData];
                 self.authorInfoArr = [TXDesignerProductionListModel mj_objectArrayWithKeyValuesArray:dicArr];
                 // 获取评论
                 [self getDesignerCommentList];
             }else{
                 if (self.isPullUp || self.isPullDown) {
                     //不做处理
                 }else {
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

/**
 * 根据设计师ID查询评论
 */
- (void)getDesignerCommentList {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.page] forKey:@"page"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.pageLength] forKey:@"pageLength"];
    [dict setValue:self.designerId forKey:@"designerId"];

    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeGetDesignerCommentList completion:^(id responseObject, NSError *error) {
        if (error) {
            if (self.isPullUp || self.isPullDown) {
                [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
                if (self.isPullUp) {
                    _page -= 1;
                }
            }else {
                [self.errorView stopNetViewLoadingFail:YES error:NO];
            }
            [self stopRefreshing];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                if (self.isPullDown && !self.isPullUp) {
                    [self.praiseArr removeAllObjects];
                }
                NSArray *dicArr = responseObject[kData][kData];
                self.dataCount = dicArr.count;
                self.totalSize = [responseObject[kData][@"totalSize"] stringValue];
                [self.praiseArr addObjectsFromArray:[TXDesignerCommentListModel mj_objectArrayWithKeyValuesArray:dicArr]];
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                [self.tableView reloadData];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    //不做处理
                    _page = 0;
                }else {
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

- (void)stopRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

#pragma mark - events

- (void)respondsToReservationBtn:(UIButton*)sender {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        
        TXAppointView *appointView = [TXAppointView shareInstanceManager];
        appointView.delegate = self;
        appointView.appointType = TXAppointViewTypeDesigner;
        [appointView show];
    };
}

- (void)respondsToBackBtn:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 拨打门店电话
 */
- (void)respondsToCallBtn:(UIButton*)sender {
    [sender setAcceptClickInterval:2];
    NSString *phone = self.designerDetailModel.storePhone;
    if ([NSString isTextEmpty:phone]) {
        [ShowMessage showMessage:@"没有门店电话哦！" withCenter:self.view.center];
    }else {
        [UIAlertController showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet Title:nil message:nil actionsMsg:@[@"呼叫门店",phone,@"取消"] buttonActions:^(NSInteger i) {
            if (i==1) {
                NSString *allString = [NSString stringWithFormat:@"telprompt:%@",phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            }
        } target:self];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == TXTabViewCellPraise ? self.praiseArr.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // 头像
        case TXTabViewCellHeader: {
            TXDesignerHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:designerHeaderCellID forIndexPath:indexPath];
            cell.model = self.designerDetailModel;
            cell.delegate = self;
            return cell;
        }
            break;
        // 作品
        case TXTabViewCellInfo: {
            TXDesingerInfoTabCell *cell = [tableView dequeueReusableCellWithIdentifier:desingerInfoCellID forIndexPath:indexPath];
            cell.dataSource = self.authorInfoArr;
            cell.productDataSource = self.productListArray;
            cell.delegate = self;
            return cell;
        }
            break;
        // 联系方式
        case TXTabViewCellContact: {
            TXDesingerContactTabCell *cell = [tableView dequeueReusableCellWithIdentifier:desingerContactCellID forIndexPath:indexPath];
            cell.model = self.designerDetailModel;
            return cell;
        }
            break;
        // 精选评论
        case TXTabViewCellSelectComment: {
            TXSelectCommentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCommentTabCellcellID forIndexPath:indexPath];
            cell.numLabel.text = [NSString stringWithFormat:@"(%@条评论)",self.totalSize];
            [cell showSubViews:self.praiseArr.count > 0 ? YES : NO];
            return cell;
        }
            break;
        // 评论列表
        case TXTabViewCellPraise: {
            TXDesignerCommentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:designerCommentTabCellID forIndexPath:indexPath];
            for (UIView *view in cell.contentView.subviews) {
                if (view.tag == 1000) {
                    for (UIView *subView in view.subviews) {
                        [subView removeFromSuperview];
                    }
                }
            }
            cell.model = self.praiseArr[indexPath.row];
            cell.section = indexPath.row;
            cell.delegate = self;
            if (indexPath.row == self.praiseArr.count-1) {
                cell.bottomView.hidden = YES;
                
            }else {
                cell.bottomView.hidden = NO;
            }
            return  cell;
        }
            break;
        default:
            return [UITableViewCell  new];
            break;
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)judgeResultCount {
    return MAX(self.authorInfoArr.count, self.productListArray.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TXTabViewCellInfo) {
        return [self judgeResultCount] > 0 ? [self calculateLineHeight] + 72.5 + 49 : 0;
    }else if (indexPath.section == TXTabViewCellContact) {
        return self.designerDetailModel.usedCount > 0 ? UITableViewAutomaticDimension : 16;
    }else if (indexPath.section == TXTabViewCellSelectComment) {
        return self.praiseArr.count > 0 ? UITableViewAutomaticDimension : 8;
    }else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)calculateLineHeight {
    if ([self judgeResultCount] == 0) {
        return 0;
    }else if ([self judgeResultCount] > 0 && [self judgeResultCount] < 4) {
        if ([self judgeResultCount] % 2 == 0) {
            return [self judgeResultCount] / 2 * LayoutH(216) + ([self judgeResultCount] / 2 - 1 ) * 10 + 1;
        }else{
            return ([self judgeResultCount] / 2.0 + 0.5) * LayoutH(216) + [self judgeResultCount] / 2 * 10 + 1;
        }
    }else {
        return 4 / 2 * LayoutH(216) + (4 / 2 - 1 ) * 10 + 1;
    }
}

#pragma mark - TXAppointViewDelegate

- (void)touchSureButton {
    TXReservaDesingerViewController *vc = [TXReservaDesingerViewController new];
    vc.designerId = self.designerId;
    vc.isHeadImgBtnClick = NO;
    vc.customType = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TXDesignerCommentTabCellDelegate 

/**
 * 查看评论图片
 */
- (void)designerCommentTabCell:(TXDesignerCommentTabCell *)designerCommentTabCell didSelectOfSection:(NSInteger)section ofIndex:(NSInteger)index {
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [designerCommentTabCell.pictures count];i++)
    {
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = designerCommentTabCell.pictures[i];// 加载网络图片大图地址
        
        if (i == 0) {
            browseItem.smallImageView = designerCommentTabCell.firstImageView;
        } else if (i == 1) {
            browseItem.smallImageView = designerCommentTabCell.secondImageView;
        } else {
            browseItem.smallImageView = designerCommentTabCell.thirdImageView;
        }
           
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    [vwcBrowse showBrowseViewController];
}

#pragma mark - TXDesignerHeaderCellDelegate

/**
 * 点击头像
 */
- (void)designerHeaderCell:(TXDesignerHeaderCell *)designerHeaderCell clickHeadImgBtn:(UIButton *)btn {
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
    browseItem.bigImageUrl = self.designerDetailModel.photo;// 加载网络图片大图地址
    browseItem.smallImageView = designerHeaderCell.photoImgView;
    [browseItemArray addObject:browseItem];
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:0];
    [vwcBrowse showBrowseViewController];
}

#pragma mark - TXDesingerInfoTabCellDelegate 

/**
 * 查看作品图
 */
- (void)desingerInfoTabCell:(TXDesingerInfoTabCell *)desingerInfoTabCell didSelectOfIndex:(NSInteger)index type:(TXDesingerInfoTabCellType)cellType {
    if (cellType == TXDesingerInfoTabCellTypeDesign) {
        // 处理数据源 与 cell 内部统一
        NSMutableArray *resultArray = nil;
        if (self.authorInfoArr.count > 4) {
            resultArray = [NSMutableArray new];
            for (int i = 0; i < 4; i++) {
                [resultArray addObject:self.authorInfoArr[i]];
            }
        } else {
            resultArray = [NSMutableArray arrayWithArray:self.authorInfoArr];
        }
        
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        for(int i = 0;i < [resultArray count];i++) {
            TXArthorInfoItemCell *collectionViewCell = (TXArthorInfoItemCell *)[desingerInfoTabCell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            TXDesignerProductionListModel *model = self.authorInfoArr[i];
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            browseItem.smallImageView = collectionViewCell.coverImgView;
            browseItem.bigImageUrl = model.productionImg;// 加载网络图片大图地址
            [browseItemArray addObject:browseItem];
        }
        MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
        [vwcBrowse showBrowseViewController];
    } else {
        TXProductListModel *model = self.productListArray[index];
        TXProductDetailViewController *vwcProduct = [TXProductDetailViewController new];
        vwcProduct.workId = model.ID;
        [self.navigationController pushViewController:vwcProduct animated:true];
    }
    
}

/**
 * 查看全部作品图
 */
- (void)desingerInfoTabCell:(TXDesingerInfoTabCell *)desingerInfoTabCell clickAllBtn:(UIButton *)btn type:(TXDesingerInfoTabCellType)cellType {
    TXProductCollectionViewController *vwcProductCollection = [TXProductCollectionViewController new];
    vwcProductCollection.designerId = self.designerId;
    if (cellType == TXDesingerInfoTabCellTypeDesign) {
        vwcProductCollection.index = 0;
    } else {
        vwcProductCollection.index = 1;
    }
    
    [self.navigationController pushViewController:vwcProductCollection animated:YES];
}

/**
 * 收藏设计师
 */
- (void)respondsToFavoriteBtn:(TXFavoriteButton *)favoriteBtn {
    NSInteger isLike = self.designerDetailModel.isliked;
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        if (![ReachabilityUtil checkCurrentNetworkState]) {
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            return;
        }
        NSString *stuta;
        //参数0则进行取消，参数1则收藏。 默认为1
        if (isLike == 0) {
            stuta = @"1";
        }else {
            stuta = @"0";
        }
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:stuta forKey:@"stutas"];
        [dict setValue:self.designerId forKey:@"designerId"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeLikeOrabolishDesigner completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                if ([responseObject[kSuccess] boolValue]) {
                    if ([stuta integerValue] == 1) {
                        self.designerDetailModel.isliked = 1;
                        [favoriteBtn showAnimation];
                    }else {
                        self.designerDetailModel.isliked = 0;
                        [favoriteBtn dismissAnimation];
                    }
                    if ([stuta isEqualToString:@"0"]) {
                        [ShowMessage showMessage:@"已取消关注" withCenter:self.view.center];
                    } else {
                        [ShowMessage showMessage:@"关注成功" withCenter:self.view.center];
                    }
                } else {
                    [ShowMessage showMessage:responseObject[kMsg] withCenter:self.view.center];
                }
            }else {
                [ShowMessage showMessage:kErrorTitle withCenter:self.view.center];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }isLogin:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if (scrollView.contentOffset.y <= 10) {
        self.topView.shadowView.hidden = YES;
    }else {
        self.topView.shadowView.hidden = NO;
    }
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - getters

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:designerHeaderCellID bundle:nil] forCellReuseIdentifier:designerHeaderCellID];
        [_tableView registerNib:[UINib nibWithNibName:desingerInfoCellID bundle:nil] forCellReuseIdentifier:desingerInfoCellID];
        [_tableView registerNib:[UINib nibWithNibName:desingerContactCellID bundle:nil] forCellReuseIdentifier:desingerContactCellID];
        [_tableView registerNib:[UINib nibWithNibName:designerCommentTabCellID bundle:nil] forCellReuseIdentifier:designerCommentTabCellID];
        [_tableView registerNib:[UINib nibWithNibName:selectCommentTabCellcellID bundle:nil] forCellReuseIdentifier:selectCommentTabCellcellID];
        _tableView.backgroundColor = RGB(255, 255, 255);
        [TXCustomTools customHeaderRefreshWithScrollView:_tableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _errorView.backBtn.hidden = YES;
        _errorView.delegate = self;
    }
    return _errorView;
}

- (TXDesingerDetailTopView *)topView {
    if (!_topView) {
        _topView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXDesingerDetailTopView" owner:nil options:nil] lastObject];
        if (!_isHavaCommitBtn) {
            [_topView.appointmentBtn removeFromSuperview];
        }
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
        [_topView.callBtn addTarget:self action:@selector(respondsToCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        _topView.delegate = self;
        [_topView.appointmentBtn addTarget:self action:@selector(respondsToReservationBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.backBtn addTarget:self action:@selector(respondsToBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        _topView.shadowView.hidden = YES;
    }
    return _topView;
}


@end

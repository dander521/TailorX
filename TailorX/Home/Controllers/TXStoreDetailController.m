//
//  TXStoreDetailController.m
//  TailorX
//
//  Created by Qian Shen on 16/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStoreDetailController.h"
#import "TXDesignerDetailController.h"
#import "MSSBrowseNetworkViewController.h"
#import "TXReservaDesingerViewController.h"
#import "TXStoreAlbumController.h"

#import "SDCycleScrollView.h"
#import "TXStoreDetailTabCell.h"
#import "TXInDesignTabCell.h"
#import "TxDesignerCollectionCell.h"

#import "TXStoreDetailModel.h"
#import "TXGetStoreDesignerListModel.h"
#import "MSSBrowseModel.h"

#import "TXDesignerProductionListModel.h"

#import "TXDiscoverBottomView.h"
#import "TXStoreDetailLabelView.h"

#import "TXBMapViewController.h"
#import "TXAppointView.h"

static NSString *inDesignCellID = @"TXInDesignTabCell";
static NSString *detailCellID = @"TXStoreDetailTabCell";
static NSString *cellID = @"TXCheckBigPictureCollCell";

#define kImageOriginHight (LayoutH(272))

@interface TXStoreDetailController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,NetErrorViewDelegate,TXInDesignTabCellDelegate, TXStoreDetailTabCellDelegate, TXAppointViewDelegate>

/** 列表*/
@property (nonatomic, strong) UITableView *tableView;
/** 入驻设计师的数据源*/
@property (nonatomic, strong) NSMutableArray<TXGetStoreDesignerListModel*> *inDesigerArr;
/** banner*/
@property (nonatomic, strong) SDCycleScrollView *bannerView;
/** 门店详情信息*/
@property (nonatomic, strong) TXStoreDetailModel *storeDetailModel;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
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
/** 入驻设计师总数*/
@property (nonatomic, strong) NSString *totalSize;
/** 设计师作品图*/
@property (nonatomic, strong) NSArray<TXDesignerProductionListModel*> *authorInfoArr;
/** 头图*/
@property (nonatomic, strong) UIImageView *headImageView;
/** 自定义导航条*/
@property (nonatomic, strong) TXDiscoverBottomView *bottomView;
/** 显示多少张*/
@property (nonatomic, strong) TXStoreDetailLabelView *lableView;


@end

@implementation TXStoreDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    
    [self initializeInterface];
}

- (void)dealloc {
    _bannerView.delegate = nil;
    _bannerView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [TXKVPO setIsInfomation:@"0"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - init

- (void)initializeDataSource {
    self.inDesigerArr = [@[]mutableCopy];
    self.pullUp = NO;
    self.pullDown = NO;
    self.page = 0;
    self.pageLength = 10;
    self.dataCount = 0;
    
    [self loadData];
}

- (void)initializeInterface {

    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.errorView];
    
    [self.view addSubview:self.bottomView];
}

#pragma mark - methods 

- (void)loadData {
    weakSelf(self);
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.storeid forKey:@"storeId"];
    [dict setValue:GetUserInfo.longitude forKey:@"longitude"];
    [dict setValue:GetUserInfo.latitude forKey:@"latitude"];
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeGetStoreDetail completion:^(id responseObject, NSError *error) {
        if (error) {
            if (weakSelf.isPullUp || weakSelf.isPullDown) {
                [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            }else {
                [weakSelf.errorView stopNetViewLoadingFail:YES error:NO];
            }
            [weakSelf stopRefreshing];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                NSDictionary *dict = responseObject[kData];
                self.storeDetailModel = [TXStoreDetailModel mj_objectWithKeyValues:dict];
                [weakSelf.headImageView sd_small_setImageWithURL:[NSURL URLWithString:self.storeDetailModel.coverImage]  placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
                    weakSelf.lableView.hidden = NO;
                }];
                if (self.storeDetailModel.pictures.count == 0) {
                    self.lableView.hidden = YES;
                }else {
                    self.lableView.hidden = NO;
                    self.lableView.numLabel.text = [NSString stringWithFormat:@"%zd张",self.storeDetailModel.pictures.count];
                }
                
                [weakSelf getStoreDesignerList];
            }else{
                if (weakSelf.isPullUp || weakSelf.isPullDown) {
                    [ShowMessage showMessage:responseObject[kMsg] withCenter:self.view.center];
                }else{
                    [weakSelf.errorView stopNetViewLoadingFail:NO error:YES];
                }
            }
            [weakSelf stopRefreshing];
        }
    }isLogin:^{
        [weakSelf stopRefreshing];
        [weakSelf.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
    }];
}

/**
 * 获取入驻设计师
 */
- (void)getStoreDesignerList {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.storeid forKey:@"storeId"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.page] forKey:@"page"];
    [dict setValue:[NSString stringWithFormat:@"%zd",self.pageLength] forKey:@"pageLength"];

    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeGetStoreDesignerList completion:^(id responseObject, NSError *error) {
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
            if ([responseObject[kSuccess] boolValue] == true) {
                if (self.isPullDown && !self.isPullUp) {
                    [self.inDesigerArr removeAllObjects];
                }
                NSArray *dicArr = responseObject[kData][kData];
                self.dataCount = dicArr.count;
                self.totalSize = responseObject[kData][@"totalSize"];
                [self.inDesigerArr addObjectsFromArray:[TXGetStoreDesignerListModel mj_objectArrayWithKeyValuesArray:dicArr]];
                for (TXGetStoreDesignerListModel *model in self.inDesigerArr) {
                    model.goodStyle = [model.goodStyle stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
                [self.errorView stopNetViewLoadingFail:NO error:NO];
                [self.tableView reloadData];
                [self stopRefreshing];
            }else{
                if (self.isPullUp || self.isPullDown) {
                    //不做处理
                    _page = 0;
                }else {
                    [self.errorView stopNetViewLoadingFail:NO error:YES];
                }
                [self stopRefreshing];
            }
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
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
    
}

- (void)stopRefreshing {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - events

- (void)respondsToCallBtn:(UIButton*)sender {
    [sender setAcceptClickInterval:2];
    if ([NSString isTextEmpty:self.storeDetailModel.phone]) {
        [ShowMessage showMessage:@"该门店没有留下电话哦！" withCenter:kShowMessageViewFrame];
    }else {
        [UIAlertController showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet Title:nil message:nil actionsMsg:@[@"呼叫门店",self.storeDetailModel.phone,@"取消"] buttonActions:^(NSInteger i) {
            if (i==1) {
                NSString *allString = [NSString stringWithFormat:@"telprompt:%@",self.storeDetailModel.phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            }
        } target:self];
    }
}

- (void)respondsToReservationBtn:(ThemeButton*)sender {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        TXAppointView *appointView = [TXAppointView shareInstanceManager];
        appointView.delegate = self;
        appointView.appointType = TXAppointViewTypeStore;
        [appointView show];
    }
}

- (void)respondsToBackBtn:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToHeadImgTap {
    if (self.storeDetailModel.pictures == 0) {
        return;
    }
    TXStoreAlbumController *vc = [TXStoreAlbumController new];
    vc.dataSource = self.storeDetailModel.pictures;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.inDesigerArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TXStoreDetailTabCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.storeDetailModel;
        cell.inDesignerNumLabel.text = [NSString stringWithFormat:@"入驻设计师（%@）",self.totalSize];
        return cell;
    }else {
        TXInDesignTabCell *cell = [tableView dequeueReusableCellWithIdentifier:inDesignCellID forIndexPath:indexPath];
        cell.index = indexPath.row;
        cell.delegate = self;
        cell.model = self.inDesigerArr[indexPath.row];
        cell.dataSource = self.inDesigerArr[indexPath.row].designerProductions;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = (SCREEN_WIDTH - 32 - 3 * 7.5) / 4.0 + LayoutH(24);
    CGFloat cellHeight = 0;
    if (indexPath.section != 0) {
        if (self.inDesigerArr[indexPath.row].designerProductions.count==0) {
            cellHeight = 117;
        }else {
            cellHeight = 117 + h;
        }
    }
    return indexPath.section == 0 ? UITableViewAutomaticDimension : cellHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }else{
        if (self.storeDetailModel.status == 0) {
            [UIAlertController showAlertWithMessage:@"门店装修中，敬请期待" target:self];
        }else {
            TXDesignerDetailController *vc = [TXDesignerDetailController new];
            vc.designerId = [NSString stringWithFormat:@"%zd",self.inDesigerArr[indexPath.row].designerId];
            vc.isHavaCommitBtn = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - TXAppointViewDelegate

- (void)touchSureButton {
    TXReservaDesingerViewController *vc = [TXReservaDesingerViewController new];
    vc.customType = YES;
    vc.storeDetailModel = self.storeDetailModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if (scrollView.contentOffset.y > 10) {
        self.bottomView.shadowView.hidden = NO;
    }else {
        self.bottomView.shadowView.hidden = YES;
    }
}

#pragma mark - TXInDesignTabCellDelegate

- (void)didSelectedInDesignTabCell:(TXInDesignTabCell *)inDesignTabCell ofIndex:(NSInteger)index atItem:(NSInteger)item {
    if (self.storeDetailModel.status == 0) {
        [UIAlertController showAlertWithMessage:@"门店装修中，敬请期待" target:self];
    }else {
        NSArray *dataSource = self.inDesigerArr[index].designerProductions;
        
        NSMutableArray *resultArray = nil;
        if (dataSource.count > 4) {
            resultArray = [NSMutableArray new];
            for (int i = 0; i < 4; i++) {
                [resultArray addObject:dataSource[i]];
            }
        } else {
            resultArray = [NSMutableArray arrayWithArray:dataSource];
        }
        
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        
        for(int i = 0;i < [resultArray count];i++) {
            TXDesignerProductionListModel *model = dataSource[i];
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            browseItem.bigImageUrl = model.productionImg;// 加载网络图片大图地址
            
            TxDesignerCollectionCell *cell = (TxDesignerCollectionCell *)[inDesignTabCell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            browseItem.smallImageView = cell.productImageView;
            [browseItemArray addObject:browseItem];
        }
        MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:item];
        [vwcBrowse showBrowseViewController];
    }
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - TXStoreDetailTabCellDelegate

- (void)touchAddressButton {
    TXBMapViewController *vwcMap = [TXBMapViewController new];
    vwcMap.storeDetailModel = self.storeDetailModel;
    [self.navigationController pushViewController:vwcMap animated:true];
}

#pragma mark - getters

-(UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewRect = self.isHidden == YES ? CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) : CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight);
        _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:inDesignCellID bundle:nil] forCellReuseIdentifier:inDesignCellID];
        [_tableView registerNib:[UINib nibWithNibName:detailCellID bundle:nil] forCellReuseIdentifier:detailCellID];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 10;
        [TXCustomTools customHeaderRefreshWithScrollView:_tableView refreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *headView = [[UIView alloc]init];
        headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kImageOriginHight);
        [headView addSubview:self.headImageView];
        [headView addSubview:self.lableView];
        [self.lableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_left);
            make.bottom.mas_equalTo(self.headImageView.mas_bottom);
            make.right.mas_equalTo(self.headImageView.mas_right);
            make.height.mas_equalTo(@40);
        }];
        self.tableView.tableHeaderView = headView;
    }
    return _tableView;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(16, 16, SCREEN_WIDTH-2*16, LayoutW(280)) delegate:self placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        _bannerView.pageDotImage = [UIImage imageNamed:@"ic_main_by_switching_circle.png"];
        _bannerView.currentPageDotImage = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_main_by_switching"];
        _bannerView.delegate = self;
        _bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bannerView.backgroundColor = RGB(240, 240, 240);
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _bannerView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _errorView.delegate = self;
        _errorView.backBtn.hidden = YES;
    }
    return _errorView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView= [[UIImageView alloc]init];
        _headImageView.frame = CGRectMake(16, 16,SCREEN_WIDTH-32,kImageOriginHight-16);
        _headImageView.image = [TXCustomTools createImageWithColor:[TXCustomTools randomColor]];
        _headImageView.layer.cornerRadius = 4;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToHeadImgTap)]];
    }
    return _headImageView;
}

- (TXDiscoverBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXDiscoverBottomView" owner:nil options:nil] lastObject];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
        _bottomView.favoriteBtnBgView.hidden = YES;
        [_bottomView.shareBtn addTarget:self action:@selector(respondsToCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.shareBtn setImage:[UIImage imageNamed:@"ic_nav_tel_3.2.1"] forState:UIControlStateNormal];
        [_bottomView.appointmentBtn addTarget:self action:@selector(respondsToReservationBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.backBtn addTarget:self action:@selector(respondsToBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.shadowView.hidden = YES;
    }
    return _bottomView;
}

- (TXStoreDetailLabelView *)lableView {
    if (!_lableView) {
        _lableView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXStoreDetailLabelView" owner:nil options:nil] lastObject];
        _lableView.hidden = YES;
    }
    return _lableView;
}


@end

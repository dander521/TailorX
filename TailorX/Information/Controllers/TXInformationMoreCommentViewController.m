//
//  TXInformationMoreCommentViewController.m
//  TailorX
//
//  Created by 温强 on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInformationMoreCommentViewController.h"
#import "TXInformationAllCommentCell.h"
#import "NetErrorView.h"
#import "TXInformationDataTool.h"
#import "TXPublishedView.h"

@interface TXInformationMoreCommentViewController ()<UITableViewDelegate,UITableViewDataSource,NetErrorViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) UITableView *mainTabView;
@property (nonatomic, strong) NetErrorView *netErrorView;
@property (nonatomic, strong) TXPublishedView *publishedView;
@property (nonatomic, strong) NSMutableArray *commentDataAry;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, assign) BOOL isPullUp;
@property (nonatomic, assign) BOOL isPullDown;
/** 空页面*/
@property (nonatomic, strong) TXBlankView *blankView;

@end

static NSString *InformationCommentCellID = @"TXInformationAllCommentCell";

@implementation TXInformationMoreCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部评论";
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

#pragma mark - init

- (void)initializeDataSource {
    _page = 0;
    _pageLength = 10;
    _dataCount = 0;
    
    [self loadData];
}

- (void)initializeInterface {
    
    self.mainTabView = [UITableView tableWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight-50)
                                             style:UITableViewStylePlain
                                         superView:self.view];
    self.mainTabView.estimatedRowHeight = 10;
    self.mainTabView.rowHeight = UITableViewAutomaticDimension;
    self.mainTabView.delegate = self;
    self.mainTabView.dataSource = self;
    self.mainTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [TXCustomTools customHeaderRefreshWithScrollView:self.mainTabView refreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainTabView.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.mainTabView registerNib:[UINib nibWithNibName:InformationCommentCellID bundle:nil] forCellReuseIdentifier:InformationCommentCellID];
    
    [self.view addSubview:self.publishedView];
    [self.publishedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    
    [self.view addSubview:self.netErrorView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_nav_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
}

- (void)back {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:false];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat height = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.publishedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-height);
        }];
        [self.publishedView.superview layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.publishedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        [self.publishedView.superview layoutIfNeeded];
    }];
}

#pragma mark - loadData

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.informationNo forKey:@"infoNo"];
    [param setValue:@(_page) forKey:@"page"];
    [param setValue:@(_pageLength) forKey:@"pageLength"];
    [TXNetRequest userCenterRequestMethodWithParams:param relativeUrl:strInformationfindFeedbackList success:^(id responseObject) {
        if ([responseObject[@"success"] boolValue]) {
         NSArray *dataAry = [TXInformationDataTool getInformationCommentDataAryFrom:responseObject];
         self.dataCount = dataAry.count;
             if (self.dataCount) {
                 // 普通请求或下拉刷新
                 if (!self.isPullUp) {
                     [self.commentDataAry removeAllObjects];
                     [self.commentDataAry addObjectsFromArray:dataAry];
                 }
                 // 上拉加载更多
                 else {
                     [self.commentDataAry addObjectsFromArray:dataAry];
                 }
                 [self.netErrorView stopNetViewLoadingFail:NO error:NO];
                 [self.mainTabView reloadData];
                 
             }else {
                 [self.netErrorView stopNetViewLoadingFail:NO error:NO];
             }
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 if (_isShowKeyBoard == YES) {
                     [_publishedView.inputTextView becomeFirstResponder];
                 }
                 _isShowKeyBoard = NO;
             });
            }  else {
             [self checkNetStaus];
             [self.netErrorView stopNetViewLoadingFail:NO error:YES];
            }
            self.commentDataAry.count == 0 ? [self showBlankView] : [self dismissBlankView];
            [self.mainTabView.mj_header endRefreshing];
            [self.mainTabView.mj_footer endRefreshing];
     } failure:^(NSError *error) {
         [self checkNetStaus];
         [self.netErrorView stopNetViewLoadingFail:YES error:NO];
         [self.mainTabView.mj_header endRefreshing];
         [self.mainTabView.mj_footer endRefreshing];
     } isLogin:^{
         [self.netErrorView stopNetViewLoadingFail:YES error:NO];
         [self.mainTabView.mj_header endRefreshing];
         [self.mainTabView.mj_footer endRefreshing];
     }];
}

- (void)checkNetStaus {
    if (_isPullDown || _isPullUp) {
        [ShowMessage showMessage:kErrorTitle withCenter:self.view.center];
    }
    if (_isPullUp) {
        _page -= 1;
    }
    _isPullUp = NO;
    _isPullDown = NO;
}

- (void)loadNewData {
    _page = 0;
    _isPullUp = NO;
    _isPullDown = YES;
    self.dataCount = 0;
    [self loadData];
    [self.mainTabView.mj_footer endRefreshing];
    [self.mainTabView.mj_footer setState:MJRefreshStateIdle];
}

- (void)loadMoreData {
    _page += 1;
    _isPullUp = YES;
    _isPullDown = NO;
    if (_dataCount < _pageLength) {
        [self.mainTabView.mj_footer setState:MJRefreshStateNoMoreData];
    }else {
        [self loadData];
    }
}

- (void)showBlankView {
    [self.view addSubview:self.blankView];
    [self.view insertSubview:self.publishedView aboveSubview:self.blankView];
}

- (void)dismissBlankView {
    [self.blankView removeFromSuperview];
}

/**
 * 提交评论
 */
- (void)submit {
    weakSelf(self);
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        // 判断是不是全是空格或者回车
        NSString * strLent = [weakSelf.publishedView.inputTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        strLent = [strLent stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([NSString isTextEmpty:strLent]) {
            [ShowMessage showMessage:@"请输入有效的评论内容！" withCenter:kShowMessageViewFrame];
            return;
        }
        [weakSelf.view endEditing:YES];
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setValue:weakSelf.informationNo forKey:@"infoNo"];
        [param setValue:[NSString disableEmoji:strLent] forKey:@"content"];
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [TXNetRequest informationRequestMethodWithParams:param relativeUrl:strInformationAddFeedBack completion:^(id responseObject, NSError *error) {
            if (responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    [ShowMessage showMessage:@"提交成功!" withCenter:weakSelf.view.center];
                    [MBProgressHUD hideHUDForView:weakSelf.view];
                    // 评论成功后不再缓存之前的数据
                    if (self.commentSuccessBlock) {
                        self.commentSuccessBlock();
                    }
                    weakSelf.publishedView.inputTextView.text = nil;
                    weakSelf.publishedView.inputTextView.frame = CGRectMake(weakSelf.publishedView.inputTextView.frame.origin.x, weakSelf.publishedView.inputTextView.frame.origin.y, CGRectGetWidth(weakSelf.publishedView.inputTextView.frame), 34);
                    [weakSelf.publishedView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(@(50));
                    }];
                    [weakSelf.mainTabView.mj_header beginRefreshing];
                } else {
                    [ShowMessage showMessage:@"提交失败,请重试" withCenter:weakSelf.view.center];
                    [MBProgressHUD hideHUDForView:weakSelf.view];
                }
            }else {
                [ShowMessage showMessage:error.description withCenter:weakSelf.view.center];
                [MBProgressHUD hideHUDForView:weakSelf.view];
            }
        }isLogin:^{
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [TXServiceUtil loginViewControllerWithTarget:weakSelf.navigationController];
        }];
    }
}

#pragma mark - events

- (void)respondsToPublishBtn:(UIButton*)sender {
    [self.view endEditing:YES];
    [self submit];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXInformationCommetModel *commentModel = self.commentDataAry[indexPath.row];
    TXInformationAllCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:InformationCommentCellID forIndexPath:indexPath];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    commentCell.model = commentModel;
    return commentCell;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [UIView textView:textView maxLength:200 showEmoji:false];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 文本内容
    NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@"\n"]) {
        [self submit];
        [textView resignFirstResponder];
        return NO;
    }else if (newStr.length > 200) {
        [ShowMessage showMessage:@"输入内容要在200字以内哦！" withCenter:self.view.center];
        return NO;
    }else {
        CGFloat textViewW = CGRectGetWidth(textView.frame);
        // 动态计算文本高度
        CGSize size = [self heightForString:newStr fontSize:14 andWidth:textViewW];
        if (size.height < 34) {
            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textViewW, 34);
            size.height = 34;
        }else if (size.height > 100) {
            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textViewW, 100);
            size.height = 100;
        }else {
            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textViewW, size.height);
        }
        [self.publishedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(size.height + 16));
        }];
        return YES;
    }
}

- (CGSize)heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

#pragma mark - netErrorView delegate

-(void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self.netErrorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark lazy

- (NetErrorView *)netErrorView {
    if (!_netErrorView) {
        _netErrorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        _netErrorView.delegate = self;
    }
    return _netErrorView;
}

- (NSMutableArray *)commentDataAry {
    if (!_commentDataAry) {
        _commentDataAry = [NSMutableArray array];
    }
    return _commentDataAry;
}

- (TXPublishedView *)publishedView {
    if (!_publishedView) {
        _publishedView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXPublishedView" owner:nil options:nil] lastObject];
        _publishedView.inputTextView.delegate = self;
        [_publishedView.publishBtn addTarget:self action:@selector(respondsToPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishedView;
}

- (TXBlankView *)blankView {
    if (!_blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
        [_blankView createBlankViewWithImage:@"ic_main_screening_not" title:@"暂无相关评论"];
    }
    return _blankView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

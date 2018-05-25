//
//  TXAbaoutUsViewController.m
//  TailorX
//
//  Created by 温强 on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXAbaoutUsViewController.h"
#import "TXCellStyleModel.h"
#import "TXUserFeedBackViewController.h"
#import "TXShowWebViewController.h"
#import "TXHomeBannerWebController.h"

static NSString *const kScore = @"去评分";
static NSString *const kFeedback = @"意见反馈";
static NSString *const kVersion = @"当前版本";
static NSString *const kMore = @"了解更多";

@interface TXAbaoutUsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *cellModels;
@end

@implementation TXAbaoutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpmainTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - UI
- (void)setUpmainTableView {
    
    NSArray *typeAry = @[@[kScore,kVersion,kMore]];
    self.cellModels = [TXCellStyleModel createCellModels:typeAry];
    // tableView
    self.mainTableView = [UITableView tableWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)
                                               style:UITableViewStylePlain
                                           superView:self.view];
    self.mainTableView.backgroundColor = RGBA(245, 245, 245, 0.9);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    // 顶部视图
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LayoutH(192.0))];
    topView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.tableHeaderView = topView;
    
    // logo 图
    UIImageView * logoImage = [[UIImageView alloc] initWithImage:[[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_about_us"]];
    [topView addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(topView).offset(28);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    // logo Label
    UILabel *logoLabel = [UILabel labelWithframe:CGRectZero
                                            text:@"TailorX"
                                            font:25.0
                                       textColor:RGB(29, 29, 38)];
    [topView addSubview:logoLabel];
    
    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImage.mas_bottom).offset(15);
        make.centerX.equalTo(topView);
    }];
    
    
    // 底部背景图
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - [self.cellModels[0] count] *LayoutH(50) - LayoutH(192)- 10.0) ];
    bottomView.backgroundColor = RGBA(245, 245, 245, 0.9);
    self.mainTableView.tableFooterView = bottomView;
    
    // 协议button
    UIButton * btn = [UIButton buttonWithTitle:@"《TailorX用户服务协议》"
                                     textColor:RGB(102, 102, 102)
                                          font:14.0
                                        action:@selector(protocolBtnClicked)
                                         frame:CGRectZero source:self];
    [bottomView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.bottom.equalTo(bottomView).offset(-LayoutH(61));
    }];

}

#pragma mark - tableView delegate/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellModels[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"aboutUsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
     TXCellStyleModel *styleModel = self.cellModels[indexPath.section][indexPath.row];
    
    cell.textLabel.text = styleModel.cellType;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    if (styleModel.cellType == kVersion) {
        
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        UILabel *contentLab = [UILabel labelWithFont:14.0 textColor:RGB(189, 190, 192) text:currentVersion superView:cell.contentView];
        [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-20);
        }];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = RGB(51, 51, 51);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LayoutH(50.0);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0)];
    sectionHeaderView.backgroundColor = RGBA(245, 245, 245, 0.9);
    return sectionHeaderView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    } else return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXCellStyleModel *styleModel = self.cellModels[indexPath.section][indexPath.row];
    if (styleModel.cellType == kScore) {
        // 去评分
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1154348037"];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"1154348037"];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }else if (styleModel.cellType == kFeedback) {
        // 意见反馈
        [self.navigationController pushViewController:[[TXUserFeedBackViewController alloc] init] animated:YES];
    }else if (styleModel.cellType == kMore) {
        // 了解更多
        TXHomeBannerWebController *vwcShow = [TXHomeBannerWebController new];
        vwcShow.requestUrl = @"http://www.tailorx.cn/app/about-us.html";
        vwcShow.isHideShare = true;
        [self.navigationController pushViewController:vwcShow animated:true];
    }
}


#pragma mark - userProtocol 

- (void)protocolBtnClicked {
    TXShowWebViewController *vwcShow = [TXShowWebViewController new];
    vwcShow.naviTitle = @"TailorX用户服务协议";
    vwcShow.webViewUrl = @"http://cdn.tailorx.cn/ui/pc/tailorx/H5/agreement/agreement.html";
    [self.navigationController pushViewController:vwcShow animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

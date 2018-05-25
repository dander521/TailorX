//
//  TXPhoneBindViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXPhoneBindViewController.h"
#import "TXPhoneBingView.h"

@interface TXPhoneBindViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray <NSString *>*cellTitles;
@property (nonatomic, strong) UITableView *phoneBindTableView;

@end

@implementation TXPhoneBindViewController

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置控制器
    [self configViewController];
    // 初始化自控制器的标签(tableViewcell的内容)
    [self setUpArrays];
    // 初始化tableView
    [self setUpContentTableView];
}

#pragma mark - Initial

/**
 配置控制器
 */
- (void)configViewController {
    self.navigationItem.title = LocalSTR(@"Str_PhoneBind");
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 * 初始化自控制器的标签(tableViewcell的内容)
 */
- (void)setUpArrays {
    self.cellTitles = @[LocalSTR(@"Str_BindPhone"), LocalSTR(@"Str_BindTime")];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.phoneBindTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.scrollEnabled = false;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.phoneBindTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([TXModelAchivar getUserModel].phone) {
        return 2;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    TXSeperateLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TXSeperateLineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.cellLineType = indexPath.row != 1 ? TXCellSeperateLinePositionType_Single : TXCellSeperateLinePositionType_None;
    cell.cellLineRightMargin = TXCellRightMarginType16;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _cellTitles[indexPath.row];
    cell.textLabel.font = FONT(15);
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.detailTextLabel.font = FONT(14);
    cell.detailTextLabel.textColor = RGB(153, 153, 153);
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString seperateTelephoneString:[TXModelAchivar getUserModel].phone];
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = [NSString formatDateToSecond:[TXModelAchivar getUserModel].mobileBindDate/1000];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 152.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TXPhoneBingView *headerView = [TXPhoneBingView instanceView];
    headerView.phoneImageView.image = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_main_phone_binding"];
    if ([TXModelAchivar getUserModel].phone) {
        headerView.phoneStatusLabel.text = @"手机号已绑定";
    } else {
        headerView.phoneStatusLabel.text = @"手机号未绑定";
    }
    
    return headerView;
}

// Setup your cell margins:
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, TableViewDefaultOriginX, 0, 0)];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

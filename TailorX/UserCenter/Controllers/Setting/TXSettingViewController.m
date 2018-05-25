//
//  TXSettingViewController.m
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSettingViewController.h"
#import "TXCellStyleModel.h"
#import "SDImageCache.h"
#import "TXAbaoutUsViewController.h"
#import "TXCommonProblemViewController.h"
#import "TXPushServiceSettingViewController.h"
#import "AppDelegate.h"
#import "EMSDImageCache.h"
static NSString *const kPushSerVice = @"实时状态推送";
//static NSString *const kChangeTheme = @"主题切换";
static NSString *const kClearCache = @"清除缓存";
static NSString *const kAboutUs = @"关于我们";
static NSString *const kCommonProblem = @"常见问题";

@interface TXSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *cellModels;
@property (nonatomic, strong) NSArray *themeArr;
@property (nonatomic, strong) UIButton * blackBtn;
@property (nonatomic, strong) UIButton * redBtn;
@property (nonatomic, strong) UILabel *cacheLabel;
@property (nonatomic, strong) UISwitch *pushSwitch;


@end
@implementation TXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpMmainTableView];

    // 设置控制器属性
    [self configViewController];
}

#pragma mark --mainTableView

- (void)setUpMmainTableView {
    
    //根据需求，临时隐藏切换主题功能 kChangeTheme
    //NSArray *typeAry = @[@[kPushSerVice,kChangeTheme,kClearCache,kAboutUs,kCommonProblem]];
    NSArray *typeAry = @[@[kPushSerVice,kClearCache,kAboutUs]];
    
    self.cellModels = [TXCellStyleModel createCellModels:typeAry];
    
    self.mainTableView = [UITableView tableWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)
                                               style:UITableViewStylePlain
                                           superView:self.view];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
}
#pragma mark --tableView delegate/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellModels[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TXCellStyleModel *styleModel = self.cellModels[indexPath.section][indexPath.row];
    cell.textLabel.text = styleModel.cellType;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    if (styleModel.cellType == kClearCache ) {
        // 清除缓存
        [self setUpCacheSize:cell];
    } else if (styleModel.cellType == kAboutUs || styleModel.cellType == kCommonProblem || styleModel.cellType == kPushSerVice) {
        // 关于我们|常见问题
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    cell.textLabel.textColor = RGB(51, 51, 51);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TXCellStyleModel *styleModel = self.cellModels[indexPath.section][indexPath.row];
    if (styleModel.cellType == kPushSerVice) {
        // 程荣刚：2017-4-14 个人推送设置需要 进行 登录判断
        // 登录
        if (![TXServiceUtil LoginController:(TXNavigationViewController *)self.navigationController]) {
            return;
        }
        [self.navigationController pushViewController:[[TXPushServiceSettingViewController alloc] init] animated:YES];
    }else if (styleModel.cellType == kClearCache ) {
      // 清除缓存
       dispatch_async(dispatch_get_main_queue(), ^{
           [UIAlertController  showAlertWithTitle:@"温馨提示" message:@"确定要清理缓存吗" actionsMsg:@[@"确定",@"取消"] buttonActions:^(NSInteger index) {
               if (index == 0) {
                   [self cleanCache];
               }
           } target:self];
       });
   } else if (styleModel.cellType == kAboutUs) {
       // 关于我们
        [self.navigationController pushViewController:[[TXAbaoutUsViewController alloc] init] animated:YES];
    } else if (styleModel.cellType == kCommonProblem) {
        // 常见问题
        [self.navigationController pushViewController:[[TXCommonProblemViewController alloc] init] animated:YES];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LayoutH(50);
}

#pragma mark --主题切换

- (void)blackBtnClicked {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"redTheme"];
    [ThemeManager shareManager].theName = self.themeArr[0];
    //3.发通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kThemeDidChangeNotifation object:nil];
    //4.保存主题
    [[ThemeManager shareManager] saveTheme];
    _blackBtn.selected = YES;
    _redBtn.selected = NO;
}

- (void)redBtnClicked {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"redTheme"];
    [ThemeManager shareManager].theName = self.themeArr[1];
    //3.发通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kThemeDidChangeNotifation object:nil];
    //4.保存主题
    [[ThemeManager shareManager]saveTheme];
    _blackBtn.selected = NO;
    _redBtn.selected = YES;
   
}


#pragma mark --UITabelView UIstyle

// 推送设置
- (void)setUpPushSwith:(UITableViewCell *)cell {
    
    _pushSwitch = [[UISwitch alloc] init];
    _pushSwitch.onTintColor = RGB(255, 51, 102);
    [cell.contentView addSubview:_pushSwitch];
    [_pushSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
    }];
}

// 切换主题
- (void)setUpChangeThemeBtns:(UITableViewCell *)cell {

    _blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_blackBtn addTarget:self action:@selector(blackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _blackBtn.backgroundColor = RGB(51, 51, 15);
    _blackBtn.layer.cornerRadius = 10;
    _blackBtn.layer.masksToBounds = YES;
    [cell.contentView addSubview:_blackBtn];
    [_blackBtn setImage:[UIImage imageNamed:@"ic_mian_select_yes_black"] forState:UIControlStateSelected];
    [_blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_redBtn addTarget:self action:@selector(redBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _redBtn.backgroundColor = RedColor;
    _redBtn.layer.cornerRadius = 10;
    _redBtn.layer.masksToBounds = YES;
    [cell.contentView addSubview:_redBtn];
    [_redBtn setImage:[UIImage imageNamed:@"ic_mian_select_yes_red"] forState:UIControlStateSelected];
    [_redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(_blackBtn.mas_left).offset(-12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    NSString *themeName = [ThemeManager shareManager].theName;
    if ([themeName isEqualToString:@"red"]) {
        
        _redBtn.selected = YES;
    } else {
        
        _blackBtn.selected = YES;
    }
}

// 缓存
-(void)setUpCacheSize:(UITableViewCell *)cell {
    
    _cacheLabel = [[UILabel alloc] init];
    _cacheLabel.textAlignment = NSTextAlignmentRight;
    NSUInteger size = 0;
//#if TX_Environment == 0
//    size = [[SDImageCache sharedImageCache] getSize];
//#else
//    size = [[EMSDImageCache sharedImageCache] getSize];
//#endif
    size = [[EMSDImageCache sharedImageCache] getSize];
    _cacheLabel.text = [NSString stringWithFormat:@"%.2f MB", size/1024.0/1024.0];
    _cacheLabel.font = [UIFont systemFontOfSize:14.0];
    _cacheLabel.textColor = RGB(189, 190, 192);
    [cell.contentView addSubview:_cacheLabel];
    [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (void)cleanCache {
    
    NSString *homeDir = NSHomeDirectory();
    
    //图片缓存的路径
    NSString *cachePath = nil;
//#if TX_Environment == 0
//    cachePath = @"Library/Caches/default/com.hackemist.SDWebImageCache.default";
//#else
//    cachePath = @"Library/Caches/com.hackemist.SDWebImageCache.default";
//#endif
    cachePath = @"Library/Caches/com.hackemist.SDWebImageCache.default";
    //完整的路径
    //拼接路径
    NSString *fullPath = [homeDir stringByAppendingPathComponent:cachePath];
    //使用文件管家，删除路径下的缓存文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager removeItemAtPath:fullPath error:nil];
    
    if (isSuccess) {
        self.cacheLabel.text = @"0.00M";
        [[EMSDImageCache sharedImageCache] clearMemory];
        [[EMSDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [ShowMessage showMessage:@"清理缓存成功！" withCenter:self.view.center];
    } else {
        [ShowMessage showMessage:@"清理缓存失败！" withCenter:self.view.center];
    }
}

#pragma mark - Config ViewController

/**
 设置控制器属性
 */
- (void)configViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = LocalSTR(@"Str_Setting");
}

#pragma mark --lazy

- (NSArray *)themeArr {
    
    if (_themeArr == nil) {
        _themeArr = [NSArray arrayWithObjects:@"black",@"red", nil];
    }
    return _themeArr;
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

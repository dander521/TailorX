//
//  TXSelectCityController.m
//  TailorX
//
//  Created by Qian Shen on 12/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSelectCityController.h"
#import "PinYinForObjc.h"
#import "TXCityModel.h"
#import "TXPersonalInfoTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

static NSString *cellID = @"cellID";
#define KCNSSTRING_ISEMPTY(str) (str == nil || [str isEqual:[NSNull null]] || str.length <= 0)

@interface TXSelectCityController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, NetErrorViewDelegate>

/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** 搜索框*/
@property (nonatomic, strong) UITextField *searchTextField;
/** 取消按钮*/
@property (nonatomic, strong) UIButton *cancelBtn;
/** 列表视图*/
@property (nonatomic, strong) UITableView *tableView;
/** 首字母*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 城市*/
@property (nonatomic, strong) NSMutableArray *citySourceArray;
/** 数据源*/
@property (nonatomic, strong) NSMutableDictionary *allKeysDict;
/** 筛选后的数据源*/
@property (nonatomic, strong) NSMutableArray *littleArray;
/** 是否处于搜索状态*/
@property (nonatomic, assign, getter=isSearch) BOOL search;
/** 历史搜索城市*/
@property (nonatomic, strong) NSArray *searchHistoryCitys;
/** 没有数据时的提示图标*/
@property (nonatomic, strong) UIView *notDataTipsView;
/** 城市模型 */
@property (nonatomic, strong) TXCityCollectionModel *cityCollectionModel;

@end

@implementation TXSelectCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeInterface];
    [self.view addSubview:self.errorView];
    [self initializeDataSource];
}

#pragma mark - Initial Methods

/**
 * 初始化数据源
 */

- (void)initializeDataSource {
    self.dataSource = [@[] mutableCopy];
    // 获取门店所在城市
    [self getDataFromServer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextField:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}

/**
 * 初始化用户界面
 */
- (void)initializeInterface {
    UIView *customNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight)];
    customNavView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customNavView];
    [customNavView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(SCREEN_WIDTH - 80));
        make.centerY.mas_equalTo(customNavView.centerY).offset(10);
        make.height.mas_equalTo(@44);
        make.left.mas_equalTo(customNavView.mas_left).offset(16);
    }];
    
    [customNavView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(64));
        make.centerY.mas_equalTo(customNavView.centerY).offset(10);
        make.height.mas_equalTo(@44);
        make.right.mas_equalTo(customNavView.mas_right);
    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.7, SCREEN_WIDTH, 0.3)];
    lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [customNavView addSubview:lineView];
    
    [self.view addSubview:self.tableView];
    
    UIView *currentCityBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    currentCityBgView.backgroundColor = [UIColor whiteColor];
    UILabel *currentCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-16, 50)];
    currentCityLabel.font = [UIFont systemFontOfSize:15];
    currentCityLabel.textColor = RGB(51, 51, 51);
    
    currentCityLabel.text = [TXModelAchivar getUserModel].currentCity == nil ? @"定位地址失败" : [NSString stringWithFormat:@"当前定位城市：%@", [TXModelAchivar getUserModel].currentCity];
    [currentCityBgView addSubview:currentCityLabel];
    self.tableView.tableHeaderView = currentCityBgView;
    
    [self.tableView addSubview:self.notDataTipsView];
}

#pragma mark - Net Request

- (void)getDataFromServer {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil relativeUrl:findStoreCity success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            self.cityCollectionModel = [TXCityCollectionModel mj_objectWithKeyValues:responseObject];
            for (TXCityModel *cityModel in self.cityCollectionModel.data) {
                if (![NSString isTextEmpty:cityModel.name]) {
                    [self.dataSource addObject:cityModel.name];
                }
            }
            self.citySourceArray = [NSMutableArray arrayWithArray:self.dataSource];
            _allKeysDict =  [[self createCharacter:self.dataSource] mutableCopy];
            
            self.dataSource = [[self.allKeysDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString *letter1 = obj1;
                NSString *letter2 = obj2;
                if (KCNSSTRING_ISEMPTY(letter2)) {
                    return NSOrderedDescending;
                }else if ([letter1 characterAtIndex:0] < [letter2 characterAtIndex:0]) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
            }] mutableCopy];
            [self.tableView reloadData];
            [self.errorView stopNetViewLoadingFail:NO error:NO];
        } else {
            [self.errorView stopNetViewLoadingFail:NO error:YES];
            [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
        }
        
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [self.errorView stopNetViewLoadingFail:YES error:NO];
        [ShowMessage showMessage:error.description withCenter:self.view.center];
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}


#pragma mark - Target Methods

- (void)respondsToCancelBtn {
    [self.view endEditing:YES];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:false];
}

#pragma mark - Privater Methods

- (NSDictionary *)createCharacter:(NSMutableArray *)strArr {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *stringdict in strArr) {
        NSString *string = stringdict;
        if ([string length]) {
            NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:string];
            
            if (CFStringTransform((__bridge CFMutableStringRef)mutableStr, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            if (CFStringTransform((__bridge CFMutableStringRef)mutableStr, 0, kCFStringTransformStripDiacritics, NO)) {
                NSString *str = [NSString stringWithString:mutableStr];
                str = [str uppercaseString];
                NSMutableArray *subArray = [dict objectForKey:[str substringToIndex:1]];
                if (!subArray) {
                    subArray = [NSMutableArray array];
                    [dict setObject:subArray forKey:[str substringToIndex:1]];
                }
                [subArray addObject:string];
            }
        }
    }
    return dict;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.isSearch) {
        return self.dataSource.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isSearch) {
        self.notDataTipsView.hidden = YES;
        return [(NSArray*)self.allKeysDict[self.dataSource[section]] count];
    }else{
        if (_littleArray.count!=0) {
            self.notDataTipsView.hidden = YES;
            return [_littleArray count];
        }else{
            self.notDataTipsView.hidden = NO;
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXPersonalInfoTableViewCell *infoCell = [TXPersonalInfoTableViewCell cellWithTableView:tableView];
    infoCell.cellLineRightMargin = TXCellRightMarginType0;
    infoCell.cellTitleLabel.textColor = RGB(51, 51, 51);
    infoCell.cellTitleLabel.font = FONT(15);
    if (!self.isSearch) {
        infoCell.cellTitleLabel.text = [self.allKeysDict[self.dataSource[indexPath.section]] objectAtIndex:indexPath.row];
        if (((NSArray *)self.allKeysDict[self.dataSource[indexPath.section]]).count == 1 ||
            (((NSArray *)self.allKeysDict[self.dataSource[indexPath.section]]).count > 1 &&
             ((NSArray *)self.allKeysDict[self.dataSource[indexPath.section]]).count == indexPath.row + 1)) {
            infoCell.cellLineType = TXCellSeperateLinePositionType_None;
        } else {
            infoCell.cellLineType = TXCellSeperateLinePositionType_Single;
        }
        
    }else{
        infoCell.cellTitleLabel.text = [self.littleArray objectAtIndex:indexPath.row];
        
        if (self.littleArray.count == indexPath.row + 1) {
            infoCell.cellLineType = TXCellSeperateLinePositionType_None;
        } else {
            infoCell.cellLineType = TXCellSeperateLinePositionType_Single;
        }
    }
    return infoCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.isSearch) {
        return self.dataSource[section];
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = RGB(153, 153, 153);
    header.contentView.backgroundColor = RGB(247, 247, 247);
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!self.isSearch) {
        return self.dataSource;
    }else{
        return @[];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self showTipsWithTitle:title];
    return index;
}

- (void)showTipsWithTitle:(NSString*)title
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *tipsView;
    if (!tipsView) {
        //添加字母提示框
        tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        tipsView.center = window.center;
        tipsView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.8];
        //设置提示框圆角
        tipsView.layer.masksToBounds = YES;
        tipsView.layer.cornerRadius  = tipsView.frame.size.width/20;
        tipsView.layer.borderColor   = [UIColor whiteColor].CGColor;
        tipsView.layer.borderWidth   = 2;
        [window addSubview:tipsView];
    }
    UILabel *tipsLab;
    if (!tipsLab) {
        //添加提示字母lable
        tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tipsView.frame.size.width, tipsView.frame.size.height)];
        //设置背景为透明
        tipsLab.backgroundColor = [UIColor clearColor];
        tipsLab.font = [UIFont boldSystemFontOfSize:50];
        tipsLab.textAlignment = NSTextAlignmentCenter;
        
        [tipsView addSubview:tipsLab];
    }
    tipsLab.text = title;//设置当前显示字母
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            tipsView.alpha = 0;
        } completion:^(BOOL finished) {
            [tipsView removeFromSuperview];
        }];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!self.isSearch) {
        return 44;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self showAlertVc];
    }else {
        if (self.block) {
            if (!self.isSearch) {
                NSString *cityName = [self.allKeysDict[self.dataSource[indexPath.section]] objectAtIndex:indexPath.row];
                for (TXCityModel *model in self.cityCollectionModel.data) {
                    if ([model.name isEqualToString:cityName]) {
                        self.block(model);
                        break;
                    }
                }
            }else{
                if (self.littleArray.count >= indexPath.section) {
                    NSString *cityName = [self.littleArray objectAtIndex:indexPath.row];
                    for (TXCityModel *model in self.cityCollectionModel.data) {
                        if ([model.name isEqualToString:cityName]) {
                            self.block(model);
                            break;
                        }
                    }
                }
            }
        }
        CATransition* transition = [CATransition animation];
        transition.duration = 0.2f;
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;//可更改为其他方式
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:false];
    }
}

- (void)showAlertVc {
    [UIAlertController showAlertWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务"
                               actionsMsg:@[@"设置",@"取消"] buttonActions:^(NSInteger index) {
        if (index == 0) {
            //打开定位设置
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }else {
            
        }
    } target:self];
}

#pragma mark - UITextFieldDelegate 

- (void)changeTextField:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    NSLog(@"textField.text = %@", textField.text);
    if (textField.hasText) {
        self.search = YES;
        NSString *new_text_str = textField.text;
        // 输入不包含汉字
        self.littleArray = [NSMutableArray new];
        for (int i = 0; i < self.citySourceArray.count; i++) {
            // 数据源包含汉字
            if (![TXSelectCityController isIncludeChineseInString:new_text_str]) {
                new_text_str = [new_text_str lowercaseString];
                // 汉字首字母
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:self.citySourceArray[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:new_text_str options:NSCaseInsensitiveSearch];
                
                // 汉字全拼
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:self.citySourceArray[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:new_text_str options:NSCaseInsensitiveSearch];
                
                if (titleHeadResult.length > 0) {
                    [self.littleArray addObject:self.citySourceArray[i]];
                }else if (titleResult.length > 0 && [tempPinYinStr hasPrefix:new_text_str]) {
                    [self.littleArray addObject:self.citySourceArray[i]];
                }
            }
            // 输入包含汉字
            else{
                NSRange titleResult= [self.citySourceArray[i] rangeOfString:new_text_str options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [self.littleArray addObject:self.citySourceArray[i]];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }else {
        self.search = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.hasText) {
        self.search = YES;
        NSString *new_text_str = textField.text;
        // 输入不包含汉字
        self.littleArray = [NSMutableArray new];
        for (int i = 0; i < self.citySourceArray.count; i++) {
            // 数据源包含汉字
            if (![TXSelectCityController isIncludeChineseInString:new_text_str]) {
                new_text_str = [new_text_str lowercaseString];
                // 汉字首字母
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:self.citySourceArray[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:new_text_str options:NSCaseInsensitiveSearch];
                
                // 汉字全拼
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:self.citySourceArray[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:new_text_str options:NSCaseInsensitiveSearch];
                
                if (titleHeadResult.length > 0) {
                    [self.littleArray addObject:self.citySourceArray[i]];
                } else if (titleResult.length > 0 && [tempPinYinStr hasPrefix:new_text_str]) {
                    [self.littleArray addObject:self.citySourceArray[i]];
                }
            }
            // 输入包含汉字
            else{
                NSRange titleResult= [self.citySourceArray[i] rangeOfString:new_text_str options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [self.littleArray addObject:self.citySourceArray[i]];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }else {
        self.search = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.search = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    return YES;
}

/**
 * @method 检查字符串是否含有汉字
 *
 * @param inputString 传入的字符串
 */
+ (BOOL)isIncludeChineseInString:(NSString *)inputString
{
    for (int i = 0; i < [inputString length]; i++) {
        unichar ch = [inputString characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self getDataFromServer];
}

#pragma mark - Setter Getter Methods

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = ({
            UITextField *textField = [[UITextField alloc]init];
            textField.placeholder = @"请输入搜索城市";
            textField.font = [UIFont systemFontOfSize:14];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField;
        });
    }
    return _searchTextField;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(respondsToCancelBtn) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _cancelBtn;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        _tableView.rowHeight = 50;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionIndexColor = RGB(0, 122, 255);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)notDataTipsView {
    if (!_notDataTipsView) {
        _notDataTipsView = ({
            UIView *view = [[UIView alloc]initWithFrame:self.tableView.bounds];
            view.backgroundColor = [UIColor whiteColor];
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = [UIImage imageNamed:@"ic_main_screening_not"];
            imageView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 90, 80, 180, 159);
            [view addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(CGRectGetMidX(imageView.frame) - 80 , CGRectGetMaxY(imageView.frame) + 44, 160, 44);
            label.text = @"未查找到相关城市";
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = RGB(29, 29, 38);
            [view addSubview:label];
            view.hidden = YES;
            view;
        });
    }
    return _notDataTipsView;
}

@end

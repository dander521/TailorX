//
//  TXPersonalInfoViewController.m
//  TailorX
//
//  Created by 倩倩 on 17/3/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPersonalInfoViewController.h"
#import "TXAvatarTableViewCell.h"
#import "TXPersonalMinusMarginTableViewCell.h"
#import "TXSetupNicknameViewController.h"
#import "TXAddressManagerViewController.h"
#import "TXAccountViewController.h"
#import "TXThirdBindViewController.h"
#import "TXPersonalDataController.h"

#define AvatarImageCornerRadius 25

@interface TXPersonalInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *personalInfoTableView;
@property (nonatomic, strong) NSArray <NSArray <NSString *>*>*cellTitles;

@end

@implementation TXPersonalInfoViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加通知
    [self addUserInfoNotification];
    // 设置控制器属性
    [self configViewController];
    // 初始化自控制器的标签
    [self setUpArrays];
    // 初始化tableview
    [self setUpContentTableView];
    // 网络请求获取订单列表
    [self getAllDataFromServer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification Method

/**
 添加通知
 */
- (void)addUserInfoNotification {
    // 实名认证
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationVerifyUserRealName object:nil];
    // 头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationChangeUserAvatar object:nil];
    // 昵称
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationChangeUserNickName object:nil];
    // 性别
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationChangeUserGender object:nil];
    // 量体数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotification:) name:kNSNotificationChangeUserBodyData object:nil];
    // 地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserAddressNotification:) name:kNSNotificationChangeUserAddress object:nil];
}

#pragma mark - Initial

/**
 设置控制器属性
 */
- (void)configViewController {
    self.view.backgroundColor = RGB(247, 247, 247);
    self.navigationItem.title = LocalSTR(@"Str_Personal_Info");
}

/**
 * 初始化自控制器的标签(tableViewcell的内容)
 */
- (void)setUpArrays {
    self.cellTitles = @[@[LocalSTR(@"Str_Avatar"),
                          LocalSTR(@"Str_Nickname"),
                          LocalSTR(@"Str_Sex"),
                          LocalSTR(@"Str_Bodydata"),
                          LocalSTR(@"Str_Address")],
                        @[LocalSTR(@"Str_AccountSecurity"),
                          // LocalSTR(@"Str_ThirdBind")
                          ],
                        @[LocalSTR(@"Str_Logout")]];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.personalInfoTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.scrollEnabled = false;
        tableView.backgroundColor = [UIColor clearColor];
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.personalInfoTableView];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cell = nil;

    if (indexPath.section == 0 && indexPath.row == 0) {
        TXAvatarTableViewCell *avatarCell = [TXAvatarTableViewCell cellWithTableView:tableView];
        
        avatarCell.cellTitleLabel.text = self.cellTitles[indexPath.section][indexPath.row];
        [avatarCell.avatarImageView sd_small_setImageWithURL:[NSURL URLWithString:[TXModelAchivar getUserModel].photo] imageViewWidth:40 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
        avatarCell.avatarImageView.layer.cornerRadius = AvatarImageCornerRadius;
        avatarCell.avatarImageView.layer.masksToBounds = true;
        avatarCell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell = avatarCell;
    } else {
        TXPersonalMinusMarginTableViewCell *infoCell = [TXPersonalMinusMarginTableViewCell cellWithTableView:tableView];
        infoCell.cellTitleLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    
        if ((indexPath.section == 0 && indexPath.row == 4) ||
            (indexPath.section == 1 && indexPath.row == 0) ||
            indexPath.section == 2) {
            infoCell.cellLineType = TXCellSeperateLinePositionType_None;
        } else {
            infoCell.cellLineType = TXCellSeperateLinePositionType_Single;
        }
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 1:
                {
                    [infoCell configPersonalInfoCellWithContent:self.cellTitles[0][indexPath.row] detailContent:[TXModelAchivar getUserModel].nickName == nil ? @"未设置" : [TXModelAchivar getUserModel].nickName];
                }
                    break;
                    
                case 2:
                {
                    [infoCell configPersonalInfoCellWithContent:self.cellTitles[0][indexPath.row] detailContent:[TXModelAchivar getUserModel].gender == 1 ? @"男" : @"女"];
                }
                    break;
                    
                case 3:
                {
                    [infoCell configPersonalInfoCellWithContent:self.cellTitles[0][indexPath.row] detailContent:[TXModelAchivar getUserModel].hasBodyData ? @"已设置" : @"未设置"];
                }
                    break;
                    
                case 4: {
                    [infoCell configPersonalInfoCellWithContent:self.cellTitles[0][indexPath.row] detailContent:@""];
                }
                    break;
                    
                default:
                    break;
            }
        }
        cell = infoCell;
    }
    cell.cellLineRightMargin = TXCellRightMarginType16;
    cell.accessoryView = [cell setCustomAccessoryView];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) return 70.0;
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

/**
 * 在此跳转子控制器
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    // 修改头像
                    [self touchChangeAvatarCell];
                }
                    break;
                    
                case 1: {
                    // 修改昵称
                    [self touchChangeNickNameCell];
                }
                    break;
                    
                case 2: {
                    // 修改性别
                    [self touchChangeSexCell];
                }
                    break;
                    
                case 3: {
                    // 量体数据
                    [self touchChangeBodydataCell];
                }
                    break;
                    
                case 4: {
                    // 地址
                    [self touchChangeAddressCell];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    // 账号安全
                    [self touchAccountSecurityCell];
                }
                    break;
                    
                case 1: {
                    // 第三方绑定
                    [self touchThirdBindCell];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2: {
            // 退出登录
            [self touchLogoutCell];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Custom Method

/**
 修改用户信息通知方法

 @param notification
 */
- (void)changeUserAddressNotification:(NSNotification *)notification {
    // 修改删除默认地址 MBProgressHUD 重复显示 不消失问题
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getAllDataFromServer) object:nil];
    [self performSelector:@selector(getAllDataFromServer) withObject:nil afterDelay:0.5];
}

/**
 修改用户信息通知方法
 
 @param notification
 */
- (void)changeUserInfoNotification:(NSNotification *)notification {
    [self.personalInfoTableView reloadData];
}

/**
 *  修改头像
 */
- (void)touchChangeAvatarCell {
    // 查看上传头像限制
    [self getUploadAvatarLimit];
}

/**
 *  昵称
 */
- (void)touchChangeNickNameCell {
    // 获取修改昵称限制时间
    [self getChangeNickNameLimit];
}

/**
 *  性别
 */
- (void)touchChangeSexCell {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Male") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf changeUserGender:1];
    }];

    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Female") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf changeUserGender:0];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:maleAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:femaleAction];
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    
    [avatarAlert addAction:maleAction];
    [avatarAlert addAction:femaleAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

/**
 *  量体数据
 */
- (void)touchChangeBodydataCell {
    [self.navigationController pushViewController:[TXPersonalDataController new] animated:true];
}

/**
 *  地址
 */
- (void)touchChangeAddressCell {
    TXAddressManagerViewController *vwcManager = [TXAddressManagerViewController new];
    vwcManager.isEditAddress = true;
    [self.navigationController pushViewController:vwcManager animated:true];
}

/**
 *  账号安全
 */
- (void)touchAccountSecurityCell {
    [self.navigationController pushViewController:[TXAccountViewController new] animated:true];
}

/**
 *  第三方绑定
 */
- (void)touchThirdBindCell {
    [self.navigationController pushViewController:[TXThirdBindViewController new] animated:true];
}

/**
 * 退出登录
 */
- (void)touchLogoutCell {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:LocalSTR(@"Str_Logout") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *homeDir = NSHomeDirectory();
        //图片缓存的路径
        NSString *cachePath = @"Library/Caches/default/com.hackemist.SDWebImageCache.default";
        //完整的路径
        //拼接路径
        NSString *fullPath = [homeDir stringByAppendingPathComponent:cachePath];
        //使用文件管家，删除路径下的缓存文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fullPath error:nil];
        [TXServiceUtil logout];
        SaveUserInfo(password, nil);
        [ShowMessage showMessage:@"退出成功" withCenter:self.view.center];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationLogout object:nil];
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:logoutAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:cancelAction];

    [avatarAlert addAction:logoutAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

/**
 * 显示修改头像
 */
- (void)showChangeAvatarActionSheet {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Camera") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            // 上传头像
            [weakSelf setAvatarImage:image];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showPhotoLibraryWithViewController:weakSelf handler:^(UIImage *image) {
            // 上传头像
            [weakSelf setAvatarImage:image];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:cameraAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:albumAction];
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    
    [avatarAlert addAction:cameraAction];
    [avatarAlert addAction:albumAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}


/**
 上传图片

 @param image
 */
- (void)setAvatarImage:(UIImage *)image{
    /*
     headPic	file	是	头像文件
     deviceType	string	是	设备类型：1.安卓、2.ios、4.pc
     */
    NSData *imageData = UIImageJPEGRepresentation([self imageWithImage:image scaledToSize:CGSizeMake(162, 162)], 0.5);

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterUploadAvatarWithParams:@{@"deviceType" : @"2"} pictureKey:@[@"headPic"] pictures:@[imageData] success:^(id responseObject) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if ([dic[kSuccess] boolValue]) {
            [MBProgressHUD hideHUDForView:self.view];
            [self getAllDataFromServer];
        } else {
            [ShowMessage showMessage:dic[ServerResponse_msg] withCenter:self.view.center];
        }
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [ShowMessage showMessage:error.description withCenter:self.view.center];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 照片的处理 -
- (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Net Request

/**
 * 网络请求获取订单列表
 */
- (void)getAllDataFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                   relativeUrl:strUserCenterGetCustomerPersonalInfo
                                    success:^(id responseObject) {
                                        if ([responseObject[ServerResponse_success] boolValue]) {
                                            TXUserModel *model = [TXUserModel defaultUser];
                                            model = [model initWithDictionary:responseObject[ServerResponse_data]];
                                            [TXModelAchivar achiveUserModel];
                                            [self.personalInfoTableView reloadData];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserAvatar object:nil];
                                        } else {
                                            [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                        }
                                        
                                        [MBProgressHUD hideHUDForView:self.view];
                                    } failure:^(NSError *error) {
                                        [ShowMessage showMessage:error.description withCenter:self.view.center];
                                        [MBProgressHUD hideHUDForView:self.view];
                                    } isLogin:^{
                                        [MBProgressHUD hideHUDForView:self.view];
                                        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                    }];
}

/**
 获取修改头像限制时间
 */
- (void)getUploadAvatarLimit {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterGetChangeAvatarTime
                                         success:^(id responseObject) {
                                             if ([responseObject[ServerResponse_code] isEqualToString:@"100000"]) {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             } else {
                                                 [self showChangeAvatarActionSheet];
                                             }
                                             
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

/**
 * 获取修改昵称限制时间
 */
- (void)getChangeNickNameLimit {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterGetChangeNicknameTime
                                         success:^(id responseObject) {
                                             if ([responseObject[ServerResponse_code] isEqualToString:@"100000"]) {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             } else {
                                                 [self.navigationController pushViewController:[TXSetupNicknameViewController new] animated:true];
                                             }
                                             
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

- (void)changeUserGender:(NSInteger)gender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:@{@"gender" : [NSString stringWithFormat:@"%ld", (long)gender]}
                                        relativeUrl:strUserCenterModifyCustomSex
                                         success:^(id responseObject) {
                                             if ([responseObject[ServerResponse_success] boolValue]) {
                                                 [TXModelAchivar updateUserModelWithKey:@"gender" value:[NSString stringWithFormat:@"%ld", (long)gender]];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeUserGender object:nil];
                                             } else {
                                                 [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                             }
                                             
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [MBProgressHUD hideHUDForView:self.view];
                                             [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                         }];
}

#pragma mark - Custom SeperateLine

// Setup your cell margins:
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, TableViewDefaultOriginX, 0, 0)];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Memory Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  TXNameVerifyViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXNameVerifyViewController.h"
#import "TXModifySecretTableViewCell.h"
#import "TXPersonalMinusMarginTableViewCell.h"
#import "TXIDAddressTableViewCell.h"
#import "TXIDCardTableViewCell.h"
#import "CMImagePickerManager.h"
#import "TXCardTypeModel.h"
#import "TXSingleComponentPickerView.h"
#import "pickerControl.h"
#import "TKCVideoRealViewController.h"
#import "TXShowWebViewController.h"

@interface TXNameVerifyViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UINavigationControllerDelegate, TXModifySecretTableViewCell, TXIDAddressTableViewCellDelegate, NetErrorViewDelegate>

/** tableview */
@property (nonatomic, strong) UITableView *verifyTableView;
/** gender	int	是	性别：1男性 0女性 */
@property (nonatomic, strong) NSString *gender;
/** 证件类型 */
@property (nonatomic, strong) NSMutableArray *cardTypeArray;
@property (nonatomic, strong) NSString *idCardName;
@property (nonatomic, assign) NSInteger credentialsType;
/** 身份证截至日期 */
@property (nonatomic, strong) NSString *upToDate;
/** 姓名 */
@property (nonatomic, strong) NSString *nameString;
/** 身份证号 */
@property (nonatomic, strong) NSString *cardString;
/** 身份证地址 */
@property (nonatomic, strong) NSString *addressString;
/** 身份证正反面图片 */
@property (nonatomic, strong) NSMutableArray *idCardImageArray;
/** 记录身份证正反面图片所在的row */
@property (nonatomic, assign) NSInteger sign;
/** 存放图片 (data）正反面图片*/
@property(nonatomic, strong)NSMutableDictionary *imgURLDic;
/** 存放图片 正反面图片 */
@property(nonatomic, strong)NSMutableDictionary *showImageDic;
/** 上传到第几张图片 */
@property (nonatomic, assign) NSInteger item;
/** 无数据提示页面 */
@property (nonatomic, strong) TXBlankView *blankView;
/** 实名认证状态 */
@property (nonatomic, strong) TXCardTypeModel *verifyStatus;
/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 底部按钮 */
@property (strong, nonatomic) ThemeButton *bottomButton;
/** 保存按钮 */
@property (strong, nonatomic) UIButton *rightButton;
@end

@implementation TXNameVerifyViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sign = 0;
    _item = 0;
    _imgURLDic = [[NSMutableDictionary alloc]init];
    _showImageDic = [[NSMutableDictionary alloc] init];
    
    // 配置控制器
    [self configViewController];
    // 初始化tableView
    [self setUpContentTableView];
    // 设置底部视图
//    [self setupBottomButton];
    // 获取实名认证状态
    [self checkRealNameStatus];
    // 证件选择的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(certificateTypeChoose:) name:@"value" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUpLoadSuccess) name:kNSNotificationVerifyVedioSuccess object:nil];
}

#pragma mark - Initial

- (void)videoUpLoadSuccess {
    [self.verifyTableView reloadData];
}

/**
 配置控制器
 */
- (void)configViewController {
    self.navigationItem.title = LocalSTR(@"Str_NameVerify");
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nameString = nil;
    self.cardString = nil;
    self.addressString = nil;
    // 保存按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 30, 30);
    [_rightButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    
    [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = FONT(14);
    _rightButton.contentMode = UIViewContentModeScaleAspectFill;
    [_rightButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right_Button = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -8;//此处修改到边界的距离
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,right_Button];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.verifyTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.hidden = true;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.verifyTableView];
}

/**
 设置底部视图
 */
- (void)setupBottomButton {
    _bottomButton = [TailorxFactory setBlackThemeBtnWithTitle:@"保存"];
    _bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    _bottomButton.titleLabel.font = FONT(17);
    [_bottomButton addTarget:self action:@selector(saveVerifyInfo:) forControlEvents:UIControlEventTouchUpInside];
    _bottomButton.hidden = true;
    [self.view addSubview:_bottomButton];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 6;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cell = nil;
    
    if ([self isTextFieldCellWithIndex:indexPath]) {
        // TextField 类型
        TXModifySecretTableViewCell *textFieldCell = [TXModifySecretTableViewCell cellWithTableView:tableView];
        textFieldCell.delegate = self;
        if (indexPath.row == 0) {
            textFieldCell.cellLabel.text = LocalSTR(@"Str_RealName");
            textFieldCell.cellTextField.placeholder = LocalSTR(@"Prompt_Input_RealName");
            textFieldCell.cellTextField.secureTextEntry = NO;
            textFieldCell.cellTextField.tag = 100;
            textFieldCell.cellTextField.text = self.nameString;
        } else {
            textFieldCell.cellLabel.text = LocalSTR(@"Str_IDCode");
            textFieldCell.cellTextField.placeholder = LocalSTR(@"Prompt_InputIDNum");
            textFieldCell.cellTextField.tag = 200;
            textFieldCell.cellTextField.text = self.cardString;
        }
        textFieldCell.cellTextField.textColor = RGB(76, 76, 76);
        textFieldCell.cellLineType = TXCellSeperateLinePositionType_Single;
        textFieldCell.cellTextField.secureTextEntry = NO;
        cell = textFieldCell;
    } else if (indexPath.section == 0 && indexPath.row == 5) {
        // TextView 类型
        TXIDAddressTableViewCell *textViewCell = [TXIDAddressTableViewCell cellWithTableView:tableView];
        textViewCell.delegate = self;
        textViewCell.cardIDTextView.text = self.addressString;
        textViewCell.cardIDTextView.textColor = RGB(76, 76, 76);
        textViewCell.cellLineType = TXCellSeperateLinePositionType_None;
        cell = textViewCell;
    } else if (indexPath.section == 1) {
        NSArray *keys = [_imgURLDic allKeys];
        // ImageView 类型
        TXIDCardTableViewCell *idCell = [TXIDCardTableViewCell cellWithTableView:tableView];
        
        if (indexPath.row == 0) {
            idCell.cardImageView.hidden = true;
            idCell.cardDesLabel.text = @"证件照正面";
            if ([keys containsObject:@"0"]) {
                idCell.sateLabel.text = @"已选择";
                idCell.cardImageView.hidden = false;
                idCell.cardImageView.image = [self.showImageDic objectForKey:@"0"];
            }
            
        } else if (indexPath.row == 1)  {
            idCell.cardImageView.hidden = true;
            idCell.cardDesLabel.text = @"证件照背面";
            if ([keys containsObject:@"1"]) {
                idCell.cardImageView.hidden = false;
                idCell.sateLabel.text = @"已选择";
                idCell.cardImageView.image = [self.showImageDic objectForKey:@"1"];
            }
        } else {
            idCell.cardImageView.hidden = true;
            idCell.cardDesLabel.text = @"视频认证";
            if ([NSString isTextEmpty:[TXUserModel defaultUser].videoPath]) {
                idCell.sateLabel.text = @"未上传";
            } else {
                idCell.sateLabel.text = @"已上传";
            }
        }
        
        idCell.accessoryView = [idCell setCustomAccessoryView];
        idCell.cellLineType = indexPath.row != 2 ? TXCellSeperateLinePositionType_Single : TXCellSeperateLinePositionType_None;
        
        cell = idCell;
    } else {
        // 正常显示类型
        TXPersonalMinusMarginTableViewCell *defaultCell = [TXPersonalMinusMarginTableViewCell cellWithTableView:tableView];
        defaultCell.cellDetailLabel.textColor = RGB(76, 76, 76);
        if (indexPath.row == 1) {
            defaultCell.cellTitleLabel.text = LocalSTR(@"Str_Sex");
            defaultCell.cellDetailLabel.text = @"男";
        } else if (indexPath.row == 2) {
            defaultCell.cellTitleLabel.text = LocalSTR(@"Str_IDType");
            defaultCell.cellDetailLabel.text = self.idCardName;
        } else {
            defaultCell.cellTitleLabel.text = LocalSTR(@"Str_IDValidityTime");
            defaultCell.cellDetailLabel.text = self.upToDate;
        }

        defaultCell.accessoryView = [defaultCell setCustomAccessoryView];
        defaultCell.cellLineType = TXCellSeperateLinePositionType_Single;
        
        cell = defaultCell;
    }
    cell.cellLineRightMargin = TXCellRightMarginType16;
    return cell;
}

/**
 *  判断是否为 textField cell
 */
- (BOOL)isTextFieldCellWithIndex:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 3)) return true;
    return false;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    weakSelf(self);
    if ([self isTextFieldCellWithIndex:indexPath]) {
        // TextField 类型
        if (indexPath.row == 0) { // 姓名
            
        } else { // 证件号
            
        }
    } else if (indexPath.section == 0 && indexPath.row == 5) { // 地址
        // TextView 类型

    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            TKCVideoRealViewController *vwcVideo = [TKCVideoRealViewController new];
            [self.navigationController pushViewController:vwcVideo animated:true];
        } else {
            // ImageView 类型
            _sign = (NSInteger)indexPath.row;
            [self showChangeAvatarActionSheet];
        }
        
    } else {
        // 正常显示类型
        if (indexPath.row == 1) {
            // 性别
            [self touchChangeSexCell:[tableView cellForRowAtIndexPath:indexPath]];
        } else if (indexPath.row == 2) {
        // 证件类型
            // 获取证件类型
            [self getCertificateType:[tableView cellForRowAtIndexPath:indexPath]];
        } else {
            // 身份证有效期
            pickerControl *pick = [[pickerControl alloc] initWithType:1 columuns:3 WithDataSource:nil response:^(NSString *str) {
                NSLog(@"%@", str);
                weakSelf.upToDate = str;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
                [weakSelf.verifyTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [pick show];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 5) return 100.0;
    
    if (indexPath.section == 1) {
        if (indexPath.row != 2) {
            if (self.showImageDic.count == 0) {
                return 44;
            } else if (self.showImageDic.count == 1) {
                NSArray *keys = [_imgURLDic allKeys];
                if (indexPath.row == [[keys objectAtIndex:0] intValue]) {
                    return 308;
                } else {
                    return 44;
                }
            } else {
                return 308;
            }
        } else {
            return 44;
        }
        
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 48;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 1) {
//        return 36;
//    }
    return 10.0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
        view.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, SCREEN_WIDTH-24, 36)];
        label.text = @"*填写的地址要与身份证上的地址完全相同，否则无法通过实名认证";
        label.textColor = RGB(153, 153, 153);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = FONT(12);
        [view addSubview:label];
        return view;
    }
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 2) {
//        
//        NSString * desStr = @"*请严格按照示例内的要求上传图片、视频！查看示例";
//        NSString * urlString = @"http://cdn.utouu.com/ui/mobile/photoExample/index-video.html";
//        
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
//        NSString *text = desStr;
//        UILabel *label = [[UILabel alloc] init];
//        label.textColor = RGB(102, 102, 102);
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
//        [attStr addAttribute:NSForegroundColorAttributeName value:RGB(48, 108, 255) range:[text rangeOfString:@"查看示例"]];
//        label.attributedText = attStr;
//        label.font = FONT(12);
//        label.numberOfLines = 0;
//        __weak typeof(self)weakSelf = self;
//        [label yb_addAttributeTapActionWithStrings:@[@"查看示例"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
//            [weakSelf jumpToH5:urlString];
//        }];
//        [view addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(view.mas_left).offset(12);
//            make.top.mas_equalTo(view.mas_top).offset(10);
//            make.right.mas_equalTo(view.mas_right).offset(-12);
//        }];
//        return view;
//    }
//    return nil;
//}

- (void)jumpToH5:(NSString *)urlString {
    
    TXShowWebViewController * webVC = [[TXShowWebViewController alloc] init];
    webVC.webViewUrl = urlString;
    webVC.naviTitle = @"示例";
    [self.navigationController pushViewController:webVC animated:true];
}

#pragma mark - Custom Method

- (void)saveVerifyInfo:(id)sender {
    [self save];
}

/**
 *  性别
 */
- (void)touchChangeSexCell:(TXPersonalMinusMarginTableViewCell *)defaultCell {
    
    weakSelf(self);
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Male") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.gender = @"男";
        defaultCell.cellDetailLabel.text = weakSelf.gender;
    }];
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Female") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.gender = @"女";
        defaultCell.cellDetailLabel.text = weakSelf.gender;
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
 * 显示修改头像
 */
- (void)showChangeAvatarActionSheet {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Camera") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            image = [self imageWithImage:image scaledToSize:image.size];//压缩图片
            // 显示图片
            [self setImage:image];
            // 保存图片
            [self saveImage:image pickey:[NSString stringWithFormat:@"%zd",_sign]];
            
            NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:_sign inSection:1];
            NSArray *indexArray = [NSArray arrayWithObject:indexPath_1];
            [_verifyTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showPhotoLibraryWithViewController:weakSelf handler:^(UIImage *image) {
            image = [self imageWithImage:image scaledToSize:image.size];//压缩图片
            // 显示图片
            [self setImage:image];
            // 保存图片
            [self saveImage:image pickey:[NSString stringWithFormat:@"%zd",_sign]];
            
            NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:_sign inSection:1];
            NSArray *indexArray = [NSArray arrayWithObject:indexPath_1];
            [_verifyTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
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

// 空白页
- (void)showBlankView {
    switch (self.verifyStatus.value) {
        case 2:
        {
            [self.blankView createBlankViewWithImage:@"ic_main_is_reviewing" title:@"正在审核" subTitle:@"请耐心等待"];
        }
            break;
            
        case 3:
        {
            [self.blankView showBlankViewWithImage:@"ic_main_audit_failure" title:@"审核失败" subTitle:@"抱歉，您填写的信息未通过审核" buttonTitle:@"重新提交"];
        }
            break;
            
        case 4:
        {
            [self.blankView showBlankViewWithImage:@"ic_main_expired" title:@"已过期" subTitle:@"你的证件有效期已过期\n请尽快更新以免影响您的使用" buttonTitle:@"重新提交"];
        }
            break;
            
        default:
            break;
    }
    _rightButton.hidden = true;
    self.blankView.hidden = false;
    self.navigationItem.title = @"安全设置";
    weakSelf(self);
    // TODO: 沈钱
    [self.blankView setBtnClickedBlock:^(NSInteger tag){
        // weakSelf.blankView.hidden = true;
        [weakSelf.blankView removeFromSuperview];
        weakSelf.blankView = nil;
        weakSelf.navigationItem.title = @"实名认证";
        weakSelf.verifyTableView.hidden = false;
        weakSelf.bottomButton.hidden = false;
        weakSelf.rightButton.hidden = false;
    }];
}


// 如果现实图片的话调用此方法
-(void)setImage: (UIImage *)image{
    [_showImageDic setObject:image forKey:[NSString stringWithFormat:@"%zd",_sign]];
}

#pragma amrk - 照片的处理 -
//压缩图片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
// 保存图片到数组
-(void)saveImage:(UIImage*)image pickey:(NSString*)key;{
    if (image) {
        NSData *imageData= UIImageJPEGRepresentation(image, 0.5);
        [_imgURLDic setObject:imageData forKey:key];
    }
}


#pragma mark - Net Request

/**
 获取是否实名认证信息
 */
- (void)getRealNameAuthStatus {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterGetRealNameAuthStatus success:^(id responseObject) {
                                            if ([responseObject[ServerResponse_success] boolValue]) {
                                                [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
                                                NSLog(@"responseObject = %@", responseObject[@"data"][@"value"]);
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
 获取证件类型
 */
- (void)getCertificateType:(TXPersonalMinusMarginTableViewCell *)defaultCell {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterGetCertificateType success:^(id responseObject) {
                                            if ([responseObject[ServerResponse_success] boolValue]) {
                                                TXCardTypeCollectionModel *collection = [TXCardTypeCollectionModel mj_objectWithKeyValues:responseObject];
                                                NSMutableArray *arr = [NSMutableArray array];
                                                self.cardTypeArray = [NSMutableArray array];
                                                for (TXCardTypeModel *model in collection.data) {
                                                    [self.cardTypeArray addObject:model];
                                                    [arr addObject:model.name];
                                                }
                                                TXSingleComponentPickerView *pickerViewHeight = [TXSingleComponentPickerView pickerView];
                                                pickerViewHeight.array = arr;
                                                [pickerViewHeight show];
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


- (void)checkRealNameStatus {
    // ("未提交", 0),("通过", 1),("审核中", 2),("不通过", 3),("已过期",4)
    [self.netView showAddedTo:self.view isClearBgc:NO];
    [TXNetRequest userCenterRequestMethodWithParams:nil
                                        relativeUrl:strUserCenterGetRealNameAuthStatus success:^(id responseObject) {
                                            [self.netView stopNetViewLoadingFail:false error:false];
                                            self.verifyStatus = [TXCardTypeModel mj_objectWithKeyValues:responseObject[@"data"]];
                                            switch (self.verifyStatus.value) {
                                                case 0: {
                                                    self.verifyTableView.hidden = false;
                                                    self.bottomButton.hidden = false;
                                                }
                                                    break;
                                                    
                                                case 1: {
                                                    
                                                }
                                                    break;
                                                    
                                                case 2:
                                                case 3:
                                                case 4: {
                                                    [self showBlankView];
                                                }
                                                    break;
                                                    
                                                default:
                                                    break;
                                            }
                                        } failure:^(NSError *error) {
                                            [ShowMessage showMessage:error.description withCenter:self.view.center];
                                            [self.netView stopNetViewLoadingFail:true error:false];
                                        } isLogin:^{
                                            [self.netView stopNetViewLoadingFail:NO error:YES];
                                            [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
                                        }];
}

#pragma mark - 证件类型选择的监听
- (void)certificateTypeChoose:(NSNotification *)notification {
    NSString *certificateType = ((TXSingleComponentPickerView *)notification.object).result;
    NSLog(@"%@",certificateType);
    self.idCardName = certificateType;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [_verifyTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 保存
- (void)save {
    [_verifyTableView endEditing:YES];
    
    /*
    realName	string	是	用户真实姓名
    credentialsType	int	是	身份证类型(类型从身份证类型接口获取)
    dateTimeMax	int	是	有限期（0）、无限期（1）
    upToDate	string	是	date_time_max为1时，可以为空身份证截至日期，格式“yyyy-MM-dd”
    homeAddress	string	是	家庭住址
    idNo	string	是	身份证号
    sex	string	是	性别：“男”、“女”
    file1	file	是	身份证正面
    file2	file	是	身份证背面
     */
    
    for (TXCardTypeModel *cardType in self.cardTypeArray) {
        if ([cardType.name isEqualToString:self.idCardName]) {
            self.credentialsType = cardType.value;
            break;
        }
    }
    
    NSString *realName = self.nameString;
    NSString *credentialsType = [NSString stringWithFormat:@"%zd", self.credentialsType];
    NSString *dateTimeMax = @"0";
    NSString *upToDate = self.upToDate;
    NSString *homeAddress = self.addressString;
    NSString *idNo = self.cardString;
    NSString *sex = self.gender ? self.gender : @"男";
    
    if (self.nameString == nil || self.nameString.length == 0 || ![NSString checkUserName:self.nameString]) {
        [ShowMessage showMessage:@"请填写您的真实姓名" withCenter:self.view.center];
        return;
    } else if (self.idCardName == nil || self.idCardName.length == 0) {
        [ShowMessage showMessage:@"请选择证件类型" withCenter:self.view.center];
        return;
    } else if (self.cardString == nil || self.cardString.length == 0) {
        [ShowMessage showMessage:@"请填写您正确的身份证号码" withCenter:self.view.center];
        return;
    } else if (upToDate == nil || upToDate.length == 0) {
        [ShowMessage showMessage:@"请选择身份证有效期" withCenter:self.view.center];
        return;
    } else if (self.addressString == nil || self.addressString.length == 0) {
        [ShowMessage showMessage:@"请填写您的身份证住址" withCenter:self.view.center];
        return;
    } else if (_imgURLDic.count < 2) {
        [ShowMessage showMessage:@"请选择证件照" withCenter:self.view.center];
        return;
    }
//    else if ([NSString isTextEmpty:[TXUserModel defaultUser].videoPath]) {
//        [ShowMessage showMessage:@"请上传视频认证" withCenter:self.view.center];
//        return;
//    }
    
    NSArray *keys = [_imgURLDic allKeys];
    NSMutableArray *showArray = [NSMutableArray array];
    NSData *file1 = [_imgURLDic objectForKey:[keys objectAtIndex:0]];
    NSData *file2 = [_imgURLDic objectForKey:[keys objectAtIndex:1]];
    [showArray addObject:file1];
    [showArray addObject:file2];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param  setValue:realName forKey:@"realName"];
    [param  setValue:credentialsType forKey:@"credentialsType"];
    [param  setValue:dateTimeMax forKey:@"dateTimeMax"];
    [param  setValue:upToDate forKey:@"upToDate"];
    [param  setValue:homeAddress forKey:@"homeAddress"];
    [param  setValue:idNo forKey:@"idNo"];
    [param  setValue:sex forKey:@"sex"];
//    [param  setValue:[TXUserModel defaultUser].videoPath forKey:@"videoUrl"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterRealNameAuthWithParams:param pictureKey:@[@"file1", @"file2"] pictures:showArray progress:^(CGFloat num) {
        NSLog(@"%f", num);
    } success:^(id responseObject) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if ([dic[ServerResponse_success] boolValue]) {
            [MBProgressHUD hideHUDForView:self.view];
            
            [self checkRealNameStatus];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationVerifyUserRealName object:nil];
        } else if ([dic[ServerResponse_code] intValue] == 700020) {
            [MBProgressHUD hideHUDForView:self.view];
            [ShowMessage showMessage:@"您输入的身份证号码有误！" withCenter:self.view.center];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
            [ShowMessage showMessage:dic[ServerResponse_msg] withCenter:self.view.center];
        }
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [ShowMessage showMessage:error.description withCenter:self.view.center];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - TXModifySecretTableViewCell

- (void)endInputTextWithString:(NSString *)textContent textField:(UITextField *)textField {
    if (textField.tag == 100) {
        // 姓名
        self.nameString = textContent;
    } else {
        // 证件号
        self.cardString = textContent;
    }
}

#pragma mark - TXIDAddressTableViewCellDelegate

- (void)endInputTextView:(UITextView *)textView content:(NSString *)textContent {
    self.addressString = textContent;
}


#pragma mark - Lazy

- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT  - kTopHeight)];
        _blankView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_blankView];
    }
    
    return _blankView;
}

/**
 网络错误页
 
 @return
 */
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        _netView.delegate = self;
    }
    return _netView;
}

#pragma mark - NetErrorViewDelegate

/**
 错误页面点击回调事件
 
 @param errorView 错误页面
 */
- (void)reloadDataNetErrorView:(NetErrorView*)errorView {
    [self checkRealNameStatus];
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

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

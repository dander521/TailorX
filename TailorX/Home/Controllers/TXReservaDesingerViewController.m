//
//  TXReservaDesingerViewController.m
//  TailorX
//
//  Created by Qian Shen on 14/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXReservaDesingerViewController.h"
#import "MSSBrowseLocalViewController.h"
#import "TXReservationSuccessController.h"
#import "TXShowWebViewController.h"
#import "TXDesignerDetailController.h"
#import "QBImagePickerController.h"
#import "TXStoreDetailController.h"
#import "TXReservationHeaderView.h"
#import "TXReservationFooterView.h"
#import "TXUploadPictureCollCell.h"
#import "TXMultiPayView.h"
#import "TXPayBottomView.h"
#import "NetErrorView.h"
#import "CustomIOSAlertView.h"
#import "TXRulesView.h"
#import "TXLocationManager.h"
#import "TXAllDesignerViewController.h"
#import "TXCustomSuccessInfoModel.h"
#import "WXApi.h"
#import "TXKVPO.h"
#import "AppDelegate.h"
#import "TXOrdersDisplayViewController.h"
#import "TXAllStoreViewController.h"

static NSString *cellID = @"TXUploadPictureCollCell";

@interface TXReservaDesingerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TXUploadPictureCollCellDelegate,TXMultiPayViewDelegate,TXPayBottomViewDelegate,NetErrorViewDelegate,QBImagePickerControllerDelegate>

/** 内容视图*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** 留言以上一截视图*/
@property (nonatomic, strong) TXReservationHeaderView *headerView;
/** 图片以下一截视图*/
@property (nonatomic, strong) TXReservationFooterView *footerView;
/** 选择的图片数组*/
@property (nonatomic, strong) NSMutableArray *pictures;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;
/** 支付方式*/
@property (nonatomic, strong) NSString *payMethod;
/** 定金金额*/
@property (nonatomic, assign) CGFloat appointmentDeposit;
/** 可用余额*/
@property (nonatomic, strong) NSString *availableBalance;
/** 底部视图*/
@property (nonatomic, strong) TXPayBottomView *bottomView;
/** 预约订单编号*/
@property (nonatomic, strong) NSString *appointmentNo;
/* 预约规则弹窗*/
@property (nonatomic, strong) CustomIOSAlertView *alertView;
/* 预约规则显示内容 */
@property (nonatomic, strong) TXRulesView *rulesView;
/** 资讯图片路径和图片ID*/
@property (nonatomic, strong) NSDictionary *informationDict;
/** 定位管理*/
@property (nonatomic, strong) TXLocationManager *locationManager;
/** 设计师信息*/
@property (nonatomic, strong) OrderDesignerInfoModel *designerInfoModel;

@end

@implementation OrderDesignerInfoModel

@end

@implementation TXReservaDesingerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        if ([[TXKVPO getIsInfomation] integerValue] == 1) {
            NSMutableDictionary *dict = [@{}mutableCopy];
            TXInformationClassModel *model = [TXInformationClassModel sharedTXInformationClassModel];
            [dict setValue:model.infoPicUrl forKey:@"infoPicUrl"];
            [dict setValue:[NSString stringWithFormat:@"%zd",model.infoPicID] forKey:@"infoPicID"];
            [dict setValue:model.informationNo forKey:@"informationNo"];
            [dict setValue:model.pictureID forKey:@"pictureID"];
            [dict setValue:model.tags forKey:@"tags"];
            self.informationDict = [dict copy];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
    [self.view addSubview:self.errorView];
}

- (void)addNotification {
    // 微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPaySuccess) name:kNSNotificationWXPaySuccess object:nil];
    // 微信支付失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againReload) name:kNSNotificationWXPayFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderSuccess:) name:kNSNotificationAliPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNSNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStore:) name:kNotificationChangeStore object:nil];
}

#pragma mark - notificationCenter

- (void)changeStore:(NSNotification *)noti {
    TXStoreDetailModel *model = (TXStoreDetailModel *)noti.object;
    self.storeDetailModel = model;
}

- (void)loginSuccess {
    [self initializeDataSource];
}

#pragma mark - init

- (void)initializeDataSource {
    self.pictures = [@[]mutableCopy];
    if (self.informationDict.count > 0) {
        [self.pictures addObject:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        [self.pictures addObject:[UIImage imageNamed:@"shape"]];
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView sd_small_setImageWithURL:[NSURL URLWithString:self.informationDict[@"infoPicUrl"]] placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, EMSDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                 [self.pictures replaceObjectAtIndex:0 withObject:image];
            }
            [self.footerView.collectionView reloadData];
            NSString *num = [NSString stringWithFormat:@"%zd/3",self.pictures.count-1];
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:num];
            [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(num.length-2,2)];
            [aString addAttribute:NSForegroundColorAttributeName value:RGB(204, 204, 204) range:NSMakeRange(num.length-2,2)];
            self.footerView.numLabel.attributedText = aString;
        }];
    }else {
        [self.pictures addObject:[UIImage imageNamed:@"shape"]];
    }
    [self locate];
}

- (void)locate {
    weakSelf(self);
    self.locationManager = [[TXLocationManager alloc]init];
    [self.locationManager locationManagerWithsuccess:^(NSString *cityName) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadData) object:nil];
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    } failure:^(NSError *error) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadData) object:nil];
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    }];
}

- (void)initializeInterface {
    
    self.navigationItem.title = self.customType ? @"预约定制" : @"预约设计师";
    
    self.view.backgroundColor = RGB(241, 241, 241);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    [self.scrollView addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.scrollView addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(20);
    }];
    if ([NSString isTextEmpty:self.informationDict[@"tags"]]) {
        [self.footerView.tagBgView removeFromSuperview];
    }else {
        self.footerView.tagLabel.text = self.informationDict[@"tags"];
    }
    [self.view addSubview:self.bottomView];
    weakSelf(self);
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view);
        make.left.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(@(50));
    }];
}

#pragma mark - methods

/** 
 * 重新刷新数据
 */
- (void)againReload {
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.appointmentNo forKey:@"orderNo"];
    // 删除订单
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeDeleteAppointment completion:^(id responseObject, NSError *error) {
    }isLogin:^{
    }];
}

#pragma mark - events

- (void)respondsToheadImgBtn:(UIButton*)sender {
    TXDesignerDetailController *vc = [TXDesignerDetailController new];
    vc.designerId = self.designerId;
    vc.isHavaCommitBtn = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)respondsToSwitchDesignerBtn:(UIButton*)sender {
    if (!_customType) {
        TXAllDesignerViewController *vc = [TXAllDesignerViewController new];
        vc.isSelect = true;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TXAllStoreViewController *vc = [TXAllStoreViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickSureBtn {
    [self.alertView close];
}

#pragma mark - methods

- (void)loadData {
    // 获取定金
    weakSelf(self);
    [TXNetRequest homeRequestMethodWithParams:nil relativeUrl:strHomeGetEarnest completion:^(id responseObject, NSError *error) {
        if (error) {
            [self.errorView stopNetViewLoadingFail:YES error:NO];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                NSDictionary *dict = responseObject[kData];
                NSString *setMoney = [NSString stringWithFormat:@"%@",dict[@"setMoney"]];
                if (![NSString isTextEmpty:setMoney]) {
                    self.appointmentDeposit = [setMoney floatValue];
                    self.bottomView.accountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.appointmentDeposit];
                }
                NSMutableString *tempStr = [NSMutableString new];
                
                for (NSInteger i = 0; i < [dict[@"description"] count]; i ++) {
                    if (![NSString isTextEmpty:dict[@"description"][i]]) {
                        if (i != [dict[@"description"] count] - 1) {
                            [tempStr appendString:[NSString stringWithFormat:@"%@\n",dict[@"description"][i]]];
                        }else {
                            [tempStr appendString:[NSString stringWithFormat:@"%@",dict[@"description"][i]]];
                        }
                        
                    }
                }
                if (tempStr.length == 0) {
                    tempStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"1、为提高预约效率，需支付%@元定金。\n2、若取消预约或订单失效，预约定金全额退还。\n3、请务必按时到店，享受您的专属服务。\n4、如遇不可抗力影响，及时与门店联系。",self.bottomView.accountLabel.text]];
                }
                // 调整行间距
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:8];
                [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempStr length])];
                self.rulesView.textLabel.attributedText = attributedStr;
                
                CGFloat height = [self heightForString:tempStr fontSize:LayoutF(14) andWidth:SCREEN_WIDTH-LayoutW(100)-60].height;
                if (height > SCREEN_HEIGHT - 150) {
                    height = SCREEN_HEIGHT - 200;
                }
                self.rulesView.frame = CGRectMake(0, 0, SCREEN_WIDTH-LayoutW(100), height + 100 + 28);
                self.alertView.frame = CGRectMake(0, 0, SCREEN_WIDTH-LayoutW(100), height + 100 + 28);
                self.alertView.center = self.view.center;
                self.alertView.containerView = self.rulesView;
                // 获取账户余额
                [weakSelf getTheUserAccountBalance];
            }else {
                [self.errorView stopNetViewLoadingFail:NO error:YES];
                [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
            }
        }
    } isLogin:^{
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/**
 *  获取账户余额
 */
- (void)getTheUserAccountBalance {
    weakSelf(self);
    [TXNetRequest homeRequestMethodWithParams:@{@"accountType":@"all"} relativeUrl:findMyBalance completion:^(id responseObject, NSError *error) {
        if (error) {
            [self.errorView stopNetViewLoadingFail:YES error:NO];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                // balance： 余额账户金额 income：收益账户金额
                NSString *balance = responseObject[kData][@"balance"];
                self.availableBalance = balance;
                [self getOrderDesignerInfo];
            }else {
                [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
                [weakSelf.errorView stopNetViewLoadingFail:NO error:YES];
            }
        }
    } isLogin:^{
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/**
 *  获取设计师信息
 */
- (void)getOrderDesignerInfo {
    weakSelf(self);
    if ([NSString isTextEmpty:self.designerId]) {
        [self.errorView stopNetViewLoadingFail:NO error:NO];
        return;
    }
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.designerId forKey:@"designerId"];
    [dict setValue:GetUserInfo.longitude forKey:@"longitude"];
    [dict setValue:GetUserInfo.latitude forKey:@"latitude"];
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strGetOrderDesignerInfo completion:^(id responseObject, NSError *error) {
        if (error) {
            [self.errorView stopNetViewLoadingFail:YES error:NO];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                self.designerInfoModel = [OrderDesignerInfoModel mj_objectWithKeyValues:responseObject[kData]];
                [self.errorView stopNetViewLoadingFail:NO error:NO];
            }else {
                [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
                [weakSelf.errorView stopNetViewLoadingFail:NO error:YES];
            }
        }
    } isLogin:^{
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/**
 *  选择图片
 */
- (void)clickUploadImage {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            [self.pictures insertObject:image atIndex:self.pictures.count - 1];
            NSString *num = [NSString stringWithFormat:@"%zd/3",self.pictures.count-1];
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:num];
            [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(num.length-2,2)];
            [aString addAttribute:NSForegroundColorAttributeName value:RGB(204, 204, 204) range:NSMakeRange(num.length-2,2)];
            self.footerView.numLabel.attributedText = aString;
            [self.footerView.collectionView reloadData];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf(self);
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持从相册选取文件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
            [alert show];
        }else{
            QBImagePickerController *imagePickerVc = [[QBImagePickerController alloc] init];
            imagePickerVc.mediaType = QBImagePickerMediaTypeImage;
            imagePickerVc.delegate = weakSelf;
            imagePickerVc.allowsMultipleSelection = YES;
            imagePickerVc.maximumNumberOfSelection = 4 - self.pictures.count;
            [weakSelf presentViewController:imagePickerVc animated:YES completion:NULL];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
 * 查看图片
 */
- (void)cheackBigImageViewOfIndex:(NSInteger)index {
    // 加载本地图片
    NSMutableArray *showArr = [self.pictures mutableCopy];
    [showArr removeLastObject];
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc] init];
    for(int i = 0;i < showArr.count; i++)
    {
        MSSBrowseModel *browseModel = [[MSSBrowseModel alloc]init];
        browseModel.bigImage = self.pictures[i];
        [browseItemArray addObject:browseModel];
    }
    MSSBrowseLocalViewController *vc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
    vc.deleteBlock = ^(NSInteger index) {
       
    };
    [vc showBrowseViewController:self];
}

/**
 * 计算文字的宽高
 */
- (CGSize)heightForString:(NSString *)value fontSize:(UIFont*)fontSize andWidth:(CGFloat)width {
    NSMutableAttributedString *coreText = [[NSMutableAttributedString alloc] initWithString:value];
    // 设置字体
    [coreText addAttribute:NSFontAttributeName value:fontSize range:NSMakeRange(0, coreText.length)];
    // 自动获取coreText所占CGSize 注意：获取前必须设置所有字体大小
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [coreText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [coreText length])];
    CGSize labelSize = [coreText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return labelSize;
}

#pragma mark QBImagePickerControllerDelegate

/**
 * 相册回调
 */
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    weakSelf(self);
    [self dismissViewControllerAnimated:YES completion:nil];
    for (int i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        // 针对手机内存过小 图片需要从icloud下载引发的UIImage *result = nil crash 问题
        options.synchronous = false;
        options.networkAccessAllowed = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            // 设置图片
            if (result) {
                [weakSelf.pictures insertObject:result atIndex:self.pictures.count - 1];
                NSString *num = [NSString stringWithFormat:@"%zd/3",self.pictures.count-1];
                NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:num];
                [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(num.length-2,2)];
                [aString addAttribute:NSForegroundColorAttributeName value:RGB(193, 193, 193) range:NSMakeRange(num.length-2,2)];
                weakSelf.footerView.numLabel.attributedText = aString;
                [weakSelf.footerView.collectionView reloadData];
            } else {
                [ShowMessage showMessage:@"图片格式有误"];
            }
        }];
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TXPayBottomViewDelegate 

/**
 * 提交预约
 */
- (void)touchPayAccountButton {
    [self.view endEditing:YES];

    TXMultiPayView *payView = [TXMultiPayView shareInstanceManager];
    payView.delegate = self;
    payView.totalAccountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.appointmentDeposit];
    payView.availableBalance = [self.availableBalance floatValue];
    if (self.appointmentDeposit > [self.availableBalance floatValue]) {
        payView.cashButton.hidden = YES;
    }
    NSMutableDictionary *dict = [@{}mutableCopy];
    
    [dict setValue:[NSString disableEmoji:self.headerView.msgTextView.text] forKey:@"message"];
    [dict setValue:@(self.appointmentDeposit) forKey:@"appointmentDeposit"];
    // 资讯
    [dict setValue:self.informationDict[@"infoPicID"] forKey:@"informationDescriptionId"];
    // 发现
    [dict setValue:self.informationDict[@"pictureID"] forKey:@"pictureId"];
    // 定制
    if (_customType) {
        [dict setValue:@(self.storeDetailModel.ID) forKey:@"storeId"];
    }else {
        [dict setValue:self.designerId forKey:@"designerId"];
    }
    // 从详情页面过来
    NSMutableArray *pictureFilesArray = [@[]mutableCopy];
    if (_isHeadImgBtnClick) {
        NSMutableArray *showArray = [self.pictures mutableCopy];
        [showArray removeLastObject];
        if (self.informationDict.count > 0) {
            [showArray removeObjectAtIndex:0];
        }
        if (showArray.count > 0) {
            for (int i = 0; i < showArray.count; i++) {
                NSData *imageData = UIImageJPEGRepresentation(showArray[i], 0.5);
                [pictureFilesArray addObject:imageData];
            }
        }else {
            pictureFilesArray = nil;
        }
    }else {
        NSMutableArray *showArray = [self.pictures mutableCopy];
        [showArray removeLastObject];
        if (showArray.count > 0) {
            for (int i = 0; i < showArray.count; i++) {
                NSData *imageData = UIImageJPEGRepresentation(showArray[i], 0.5);
                [pictureFilesArray addObject:imageData];
            }
        }else {
            pictureFilesArray = nil;
        }
    }
    weakSelf(self);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中";
    [TXNetRequest homeCommitAppointmentWithParams:dict relativeUrl:strHomeCommitAppointment pictureKey:@[@"files"] pictures:pictureFilesArray completion:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (error) {
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                NSDictionary *dict = responseObject[kData];
                weakSelf.appointmentNo = dict[@"appointmentNo"];
                [payView show];
            }else {
                [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
            }
        }
    }];
}

- (void)touchAppointmentDescriptionButton {
    [self.alertView showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - TXUploadPictureCollCellDelegate

- (void)uploadPictureCollCell:(TXUploadPictureCollCell *)pictureCell didSelectItemOfIndex:(NSInteger)index {
    [self.pictures removeObjectAtIndex:index];
    [self.footerView.collectionView reloadData];
    NSString *num = [NSString stringWithFormat:@"%zd/3",self.pictures.count-1];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:num];
    [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(num.length-2,2)];
    [aString addAttribute:NSForegroundColorAttributeName value:RGB(193, 193, 193) range:NSMakeRange(num.length-2,2)];
    self.footerView.numLabel.attributedText = aString;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.pictures.count>3) {
        return 3;
    }else{
        return self.pictures.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXUploadPictureCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.photoImageView.image = self.pictures[indexPath.row];
    if (self.informationDict.count > 0) {
        if (self.pictures.count >= 4) {
            if (indexPath.row == 0) {
                cell.deleteBtn.hidden = YES;
            }else {
                cell.deleteBtn.hidden = NO;
            }
        }else {
            if (indexPath.row == self.pictures.count - 1 || indexPath.row == 0) {
                cell.deleteBtn.hidden = YES;
            }else {
                cell.deleteBtn.hidden = NO;
            }
        }
    }else {
        if (self.pictures.count >= 4) {
            cell.deleteBtn.hidden = NO;
        }else {
            if (indexPath.row == self.pictures.count - 1) {
                cell.deleteBtn.hidden = YES;
            }else {
                cell.deleteBtn.hidden = NO;
            }
        }
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pictures.count >= 4) {
        [self cheackBigImageViewOfIndex:indexPath.row];
    }else{
        if (indexPath.item != self.pictures.count- 1) {
            // 查看
            [self cheackBigImageViewOfIndex:indexPath.row];
        }else{
            // 上传
            [self clickUploadImage];
        }
    }
}

#pragma mark - TXMultiPayViewDelegate

- (void)touchPayAccountCommitButtonWithPayType:(TXMultiPayViewType)payType {
    self.payMethod = [NSString stringWithFormat:@"%zd", payType];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"支付中";
    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:self.appointmentNo forKey:@"orderNo"];
    [dict setValue:self.payMethod forKey:@"payMethod"];
    [dict setValue:@(self.appointmentDeposit) forKey:@"appointmentDeposit"];
    weakSelf(self);
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:@"/v3/app/order/payAppointment" completion:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([responseObject[kSuccess] boolValue]) {
            if ([self.payMethod isEqualToString:@"2"]) {
                [ShowMessage showMessage:@"预约成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                    [[AppDelegate sharedAppDelegate].tabBarVc.selectedViewController pushViewController:[TXOrdersDisplayViewController new] animated:YES];
                });
            } else if ([self.payMethod isEqualToString:@"1"]) {
                [[AlipaySDK defaultService] payOrder:responseObject[kMsg] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                }];
            } else {
                NSData *jsonData = [responseObject[kMsg] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                //需要创建这个支付对象
                PayReq *req   = [[PayReq alloc] init];
                //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                req.openID = dic[@"appid"];
                // 商家id，在注册的时候给的
                req.partnerId = dic[@"partnerid"];
                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                req.prepayId  = dic[@"prepayid"];
                // 根据财付通文档填写的数据和签名
                //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
                req.package   = dic[@"package"];
                // 随机编码，为了防止重复的，在后台生成
                req.nonceStr  = dic[@"noncestr"];
                // 这个是时间戳，也是在后台生成的，为了验证支付的
                NSString * stamp = dic[@"timestamp"];
                req.timeStamp = stamp.intValue;
                // 这个签名也是后台做的
                req.sign = dic[@"sign"];
                //发送请求到微信，等待微信返回onResp
                [WXApi sendReq:req];
            }
        }else {
            [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
        }
    } isLogin:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)touchPayAccountCancelButton {
    [self againReload];
}

- (void)weChatPaySuccess {
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShowMessage showMessage:@"预约成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            [[AppDelegate sharedAppDelegate].tabBarVc.selectedViewController pushViewController:[TXOrdersDisplayViewController new] animated:YES];
        });
    });
}

- (void)payOrderSuccess:(NSNotification*)sender {
    weakSelf(self);
    NSDictionary *resultDic = sender.userInfo;
    NSString *message;
    if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeSuccess]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShowMessage showMessage:@"预约成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                [[AppDelegate sharedAppDelegate].tabBarVc.selectedViewController pushViewController:[TXOrdersDisplayViewController new] animated:YES];
            });
        });
    } else {
        if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeDealing]) {
            message = @"正在处理中";
        }
        else if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeFail]) {
            message = @"预约支付失败";
            [weakSelf againReload];
        }
        else if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeCancel]) {
            message = @"用户中途取消";
            [weakSelf againReload];
        }
        else {
            message = @"预约支付失败";
            [weakSelf againReload];
        }
        [ShowMessage showMessage:message withCenter:self.view.center];
    }
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - setters

- (void)setDesignerInfoModel:(OrderDesignerInfoModel *)designerInfoModel {
    _designerInfoModel = designerInfoModel;
    if (!_customType) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            self.headerView.promptLabel.text = @"未获取您当前位置，是否预约该设计师";
        }else {
            if (!designerInfoModel.isSameCity) {
                self.headerView.promptLabel.text = @"您预约的设计师和你相距太远";
            }else {
                [self.headerView.topPromptView removeFromSuperview];
            }
        }
        [self.headerView.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:designerInfoModel.designerPhoto] imageViewWidth:0 placeholderImage:kDefaultUeserHeadImg];
        self.headerView.nameLabel.text = [NSString isTextEmpty:self.designerInfoModel.designerName] ? @"" : self.designerInfoModel.designerName;
        self.headerView.storeNameLabel.text = [NSString isTextEmpty:self.designerInfoModel.storeName] ? @"" : self.designerInfoModel.storeName;
        self.headerView.stroeAddressLabel.text = [NSString isTextEmpty:self.designerInfoModel.storeAddress] ? @"" : self.designerInfoModel.storeAddress;
        self.headerView.workTimeLabel.text = [NSString isTextEmpty:self.designerInfoModel.workTime] ? @"" : [NSString stringWithFormat:@"营业时间：%@",self.designerInfoModel.workTime];
    }
}

- (void)setStoreDetailModel:(TXStoreDetailModel *)storeDetailModel {
    _storeDetailModel = storeDetailModel;
    if (_customType) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            self.headerView.promptLabel.text = @"未获取您当前位置，是否预约该门店";
        }else {
            if (!storeDetailModel.isSameCity) {
                self.headerView.promptLabel.text = @"您预约的门店和你相距太远";
            }else {
                [self.headerView.topPromptView removeFromSuperview];
            }
        }
        self.headerView.storeNameLabel.text = [NSString isTextEmpty:self.storeDetailModel.name] ? @"" : self.storeDetailModel.name;
        self.headerView.stroeAddressLabel.text = [NSString isTextEmpty:self.storeDetailModel.address] ? @"" : self.storeDetailModel.address;
        self.headerView.workTimeLabel.text = [NSString isTextEmpty:self.storeDetailModel.workTime] ? @"" : [NSString stringWithFormat:@"营业时间：%@",self.storeDetailModel.workTime];
    }
}


- (void)setCustomType:(BOOL)customType {
    _customType = customType;
    if (_customType) {
        self.headerView.photoImgView.hidden = YES;
        self.headerView.nameLabel.hidden = YES;
        self.headerView.desingerMarkImgView.hidden = YES;
        self.headerView.rightImgView.hidden = YES;
        self.headerView.headBtn.hidden = YES;
        self.navigationItem.title = @"预约定制";
        self.headerView.promptChangeLabel.text = @"切换门店";
    }else {
        self.headerView.storeInfoView.hidden = YES;
        self.navigationItem.title = @"预约设计师";
        self.headerView.promptChangeLabel.text = @"切换设计师";
    }
}

#pragma mark - getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = RGB(255, 255, 255);
    }
    return _scrollView;
}

- (TXReservationHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"TXReservationHeaderView" owner:nil options:nil].lastObject;
        // 资讯页面进来头像可以点击跳转的是设计师详情页，走正常的预约流程头像则不能点击
        if (_isHeadImgBtnClick) {
            [_headerView.headBtn addTarget:self action:@selector(respondsToheadImgBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            _headerView.rightImgView.hidden = YES;
        }
        [_headerView.switchDesignerBtn addTarget:self action:@selector(respondsToSwitchDesignerBtn:) forControlEvents:UIControlEventTouchUpInside];
        return _headerView;
    }
    return _headerView;
}

- (TXReservationFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"TXReservationFooterView" owner:nil options:nil].lastObject;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _footerView.collectionView.collectionViewLayout = flowLayout;
        //设置最小间距
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.minimumLineSpacing = 2;
        //设置格子大小
        // plus
        if(SCREEN_HEIGHT > 700) {
            flowLayout.itemSize = CGSizeMake(120, 120);
            _footerView.widthLayout.constant = 370;
            _footerView.heightLayout.constant = 122;
        }
        // s
        else if (SCREEN_HEIGHT > 650) {
            flowLayout.itemSize = CGSizeMake(105, 105);
            _footerView.widthLayout.constant = 325;
            _footerView.heightLayout.constant = 107;
        }
        // 4、5
        else {
            flowLayout.itemSize = CGSizeMake(85, 85);
            _footerView.widthLayout.constant = 270;
            _footerView.heightLayout.constant = 87;
        }
        [_footerView layoutIfNeeded];
        _footerView.collectionView.dataSource = self;
        _footerView.collectionView.delegate = self;
        [_footerView.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        NSString *num = [NSString stringWithFormat:@"%zd/3",0];
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:num];
        [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(num.length-2,2)];
        [aString addAttribute:NSForegroundColorAttributeName value:RGB(193, 193, 193) range:NSMakeRange(num.length-2,2)];
        _footerView.numLabel.attributedText = aString;
        return _footerView;
    }
    return _footerView;
}

- (TXPayBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [TXPayBottomView instanceView];
        _bottomView.payType = TXPayViewTypeSingle;
        _bottomView.appointmentType = TXPayViewAppointmentTypeShow;
        _bottomView.payDescriptionLabel.text = @"定金:";
        _bottomView.accountLabel.text = @"￥100";
        _bottomView.delegate = self;
        [_bottomView.submitButton setTitle:@"提交预约" forState:UIControlStateNormal];
    }
    return _bottomView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
}

- (CustomIOSAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[CustomIOSAlertView alloc]initWithFrame:CGRectMake(0, 0, 260, 100)];
        _alertView.center = self.view.center;
    }
    return _alertView;
}

- (TXRulesView *)rulesView {
    if (!_rulesView) {
        _rulesView = [TXRulesView creationRulesView];
        _rulesView.textLabel.font = LayoutF(14);
        [_rulesView.sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rulesView;
}

@end

//
//  TXCommentViewController.m
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXInputCommentViewController.h"
#import "MSSBrowseLocalViewController.h"
#import "TXOrdersDisplayViewController.h"
#import "QBImagePickerController.h"
#import "TXStarRateTableViewCell.h"
#import "TXCommentTableViewCell.h"
#import "TXPhotoTableViewCell.h"
#import "TXOrderHeaderView.h"
#import "MSSBrowseModel.h"

#define DefaultStarRate @"5"

@interface TXInputCommentViewController () <UITableViewDelegate, UITableViewDataSource, TXStarRateTableViewCellProtocol, TXPhotoTableViewCellDelegate,UITextViewDelegate, QBImagePickerControllerDelegate>

/** TableView */
@property (nonatomic, strong) UITableView *commentTableView;
/** 图片数组*/
@property (nonatomic, strong) NSMutableArray *commentPictures;
/** 设计师星级描述*/
@property (nonatomic, strong) NSString *designerRateString;
/** 综合描述*/
@property (nonatomic, strong) NSString *overallRateString;
/** 工厂描述*/
@property (nonatomic, strong) NSString *factoryRateString;
/** 保存按钮 */
@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation TXInputCommentViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器属性
    [self configViewController];
    // 初始化tableView
    [self setUpContentTableView];
    // 初始化 评论图
    [self initializeDataSource];
}

#pragma mark - Initial

/**
 * 设置控制器属性
 */
- (void)configViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"评价";
    self.designerRateString = DefaultStarRate;
    self.overallRateString = DefaultStarRate;
    self.factoryRateString = DefaultStarRate;
    
    // 保存按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 30, 30);
    [_rightButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    
    [_rightButton setTitle:@"提交" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = FONT(14);
    _rightButton.contentMode = UIViewContentModeScaleAspectFill;
    [_rightButton addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right_Button = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -8;//此处修改到边界的距离
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,right_Button];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_arrow"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(touchBackItem:)];
}

/**
 * 设置底部按钮
 */
- (void)setupBottomButton {
    ThemeButton *bottomButton = [TailorxFactory setBlackThemeBtnWithTitle:@"评论"];
    bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT - kTabBarHeight, SCREEN_WIDTH, 50);
    bottomButton.titleLabel.font = FONT(17);
    [bottomButton addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.commentTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.commentTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) return 1;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        TXCommentTableViewCell *commentCell = [TXCommentTableViewCell cellWithTableView:tableView];
        commentCell.cellLineType = TXCellSeperateLinePositionType_None;
        commentCell.inputTextView.delegate = self;
        cell = commentCell;
    } else if (indexPath.section == 1) {
        TXPhotoTableViewCell *commentCell = [TXPhotoTableViewCell cellWithTableView:tableView];
        commentCell.cellLineType = TXCellSeperateLinePositionType_None;
        commentCell.delegate = self;
        commentCell.dataSource = self.commentPictures;
        cell = commentCell;
    } else {
        TXStarRateTableViewCell *rateCell = [TXStarRateTableViewCell cellWithTableView:tableView];
        rateCell.commentStatusLabel.hidden = true;
        rateCell.delegate = self;
        rateCell.starView.tag = 1000 + indexPath.row;
        rateCell.cellLineType = indexPath.row == 2 ? TXCellSeperateLinePositionType_None : TXCellSeperateLinePositionType_Single;
        rateCell.starView.isGrayStarForBlank = false;
        
        if (indexPath.row == 0) {
            rateCell.descriptionLabel.text = @"综合评分";
        } else if (indexPath.row == 1) {
            rateCell.descriptionLabel.text = @"设计师评分";
        } else {
            rateCell.descriptionLabel.text = @"工厂评分";
        }
        
        cell = rateCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) return 50.0;
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 140;
    if (indexPath.section == 1) return 127;
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        TXOrderHeaderView *headerView = [TXOrderHeaderView instanceView];
        headerView.headerType = TXOrderHeaderTypeDismissImage;
        headerView.storeLabel.font = FONT(13);
        headerView.storeLabel.textColor = RGB(108, 108, 108);
        headerView.storeLabel.text = @"评分";
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        if (indexPath.section == 1) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, TableViewDefaultOriginX, 0, 0)];
        }
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

#pragma mark - Custom Method

/**
 * 设置控制器属性
 */

- (void)touchBackItem:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TXOrdersDisplayViewController class]]) {
            [self.navigationController popToViewController:controller animated:false];
        }
    }
}

/**
 * 初始化 评论图
 */
- (void)initializeDataSource {
    self.commentPictures = [NSMutableArray new];
    [self.commentPictures addObject:[UIImage imageNamed:@"ic_main_img_camera"]];
}

/**
 提交评论

 @param sender
 */
- (void)submitComment:(id)sender {
    NSMutableArray *pictureFilesArray = [NSMutableArray array];
    NSMutableArray *showArray = [self.commentPictures mutableCopy];
    [showArray removeLastObject];
    if (showArray.count > 0) {
        for (int i = 0; i < showArray.count; i++) {
            NSData *imageData= UIImageJPEGRepresentation(self.commentPictures[i], 0.5);
            [pictureFilesArray addObject:imageData];
        }
    } else {
        pictureFilesArray = nil;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    TXCommentTableViewCell *commentCell = [self.commentTableView cellForRowAtIndexPath:indexPath];
    if (commentCell.inputTextView.text == nil || commentCell.inputTextView.text.length == 0) {
        [ShowMessage showMessage:@"请填写评价内容" withCenter:self.view.center];
        return;
    } else if (commentCell.inputTextView.text.length < 4) {
        [ShowMessage showMessage:@"评价不能小于4个字" withCenter:self.view.center];
        return;
    } else if (commentCell.inputTextView.text.length > 600) {
        [ShowMessage showMessage:@"评价内容太长了" withCenter:self.view.center];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.orderNo forKey:ServerParams_orderNo];
    [param setValue:[NSString disableEmoji:commentCell.inputTextView.text] forKey:ServerParams_content];
    [param setValue:self.overallRateString forKey:ServerParams_attitudeScore];
    [param setValue:self.designerRateString forKey:ServerParams_designerScore];
    [param setValue:self.factoryRateString forKey:ServerParams_satisfactionScore];
    [TXNetRequest orderFeedbackPictureWithParams:param
                                      pictureKey:@[ServerParams_pictureFiles]
                                        pictures:pictureFilesArray
                                         success:^(id responseObject) {
                                             NSError *err;
                                             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                 options:NSJSONReadingMutableContainers
                                                                                                   error:&err];
                                             if ([dic[ServerResponse_success] boolValue]) {
                                                 
                                                 [ShowMessage showMessage:@"评价成功" withCenter:self.view.center];
                                                 [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0];
                                             } else {
                                                 [ShowMessage showMessage:dic[ServerResponse_msg] withCenter:self.view.center];
                                             }
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } failure:^(NSError *error) {
                                             [ShowMessage showMessage:error.description withCenter:self.view.center];
                                             [MBProgressHUD hideHUDForView:self.view];
                                         }];
}

- (void)delayMethod {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TXOrdersDisplayViewController class]]) {
            [self.navigationController popToViewController:controller animated:false];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCommentSuccess object:nil userInfo:@{@"orderNo" : self.orderNo}];
}


/**
 *  选择图片
 */
- (void)touchUploadImage {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            [self.commentPictures insertObject:image atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            TXPhotoTableViewCell *cell = [self.commentTableView cellForRowAtIndexPath:indexPath];
            cell.dataSource = self.commentPictures;
            [cell.commentCollectionView reloadData];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持从相册选取文件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
            [alert show];
        }else{
            QBImagePickerController *_imagePickerController = [[QBImagePickerController alloc] init];
            _imagePickerController.mediaType = QBImagePickerMediaTypeImage;
            _imagePickerController.delegate = self;
            _imagePickerController.allowsMultipleSelection = YES;
            _imagePickerController.maximumNumberOfSelection = 4 - self.commentPictures.count;
            [self presentViewController:_imagePickerController animated:YES completion:NULL];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalSTR(@"Str_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:cameraAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:albumAction];
    [TXCustomTools setActionTitleTextColor:RGB(246, 47, 94) action:cancelAction];
    
    [avatarAlert addAction:cameraAction];
    [avatarAlert addAction:albumAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

#pragma mark QBImagePickerControllerDelegate
//相册回调
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
                [weakSelf.commentPictures insertObject:result atIndex:self.commentPictures.count - 1];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                TXPhotoTableViewCell *cell = [self.commentTableView cellForRowAtIndexPath:indexPath];
                cell.dataSource = self.commentPictures;
                [cell.commentCollectionView reloadData];
            } else {
                [ShowMessage showMessage:@"图片格式有误"];
            }
        }];
    }
    
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TXStarRateTableViewCellProtocol

/**
 选择星级代理
 
 @param starView 星级view
 @param currentScore 星级数
 */
- (void)selectRatingView:(XHStarRateView *)starView score:(CGFloat)currentScore {

    switch (starView.tag - 1000) {
        case 0:
        {
            self.overallRateString = [NSString stringWithFormat:@"%d", (int)currentScore];
        }
            break;
            
        case 1:
        {
            self.designerRateString = [NSString stringWithFormat:@"%d", (int)currentScore];
        }
            break;
            
        case 2:
        {
            self.factoryRateString = [NSString stringWithFormat:@"%d", (int)currentScore];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - TXPhotoTableViewCellDelegate

/**
 * 查看图片
 */
- (void)uploadCommentPictureTabCell:(TXCommentTableViewCell *)commentCell
            didSelectPictureOfindex:(NSInteger)index {
    // 加载本地图片
    NSMutableArray *showArray = [self.commentPictures mutableCopy];
    [showArray removeLastObject];
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc] init];
    for(int i = 0;i < [showArray count]; i++)
    {
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImage = self.commentPictures[i];// 大图赋值
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseLocalViewController *bvc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
    bvc.deleteBlock = ^(NSInteger index) {
        [self.commentPictures removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        TXPhotoTableViewCell *cell = [self.commentTableView cellForRowAtIndexPath:indexPath];
        cell.dataSource = self.commentPictures;
        [cell.commentCollectionView reloadData];
    };
    [bvc showBrowseViewController];
}

/**
 * 上传图片
 */
- (void)uploadCommentPicture:(TXCommentTableViewCell *)commentCell {
    [self touchUploadImage];
}

/**
 删除对应位置的图片
 
 @param index 索引
 */
- (void)deletePictureWithIndex:(NSInteger)index {
    [self.commentPictures removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    TXPhotoTableViewCell *cell = [self.commentTableView cellForRowAtIndexPath:indexPath];
    cell.dataSource = self.commentPictures;
    [cell.commentCollectionView reloadData];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

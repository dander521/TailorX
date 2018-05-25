//
//  TXReplaceImageViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/13.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXReplaceImageViewController.h"

@interface TXReplaceImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bodyImageView;
/** <#description#> */
@property (nonatomic, strong) UIImage *selectedImage;
@end

@implementation TXReplaceImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.title;
    [self.bodyImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pictureUrl] placeholderImage:self.model.image];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_more"] style:UIBarButtonItemStylePlain target:self action:@selector(touchRightBarItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)touchRightBarItem {
    // 弹框提示替换还是删除
    weakSelf(self);
    [UIAlertController showAlertWithStyle:UIAlertControllerStyleActionSheet Title:nil message:nil actionsMsg:@[@"拍照",@"相册",@"取消"] buttonActions:^(NSInteger i) {
        if (i == 0) {
            [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
                weakSelf.selectedImage = image;
                // 上传照片
                [weakSelf requsetUploadImage];
            }];
        } else if (i == 1) {
            [[CMImagePickerManager sharedCMImagePickerManager] showPhotoLibraryWithViewController:weakSelf handler:^(UIImage *image) {
                weakSelf.selectedImage = image;
                // 上传照片
                [weakSelf requsetUploadImage];
            }];
        }
    } target:self];
}

/**
 * 上传图片或替换图片
 */

- (void)requsetUploadImage {

    NSMutableDictionary *dict = [@{}mutableCopy];
    [dict setValue:@(self.model.ID) forKey:@"fileId"];
    [dict setValue:@(self.index +  1) forKey:@"type"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest userCenterCommitRePictureWithParams:dict relativeUrl:strHomeAddBodyPicture pictureKey:@[@"file"] pictures:@[UIImageJPEGRepresentation(self.selectedImage, 0.7)] progress:^(CGFloat pro) {
        
    } completion:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            return ;
        }
        if ([responseObject[kSuccess] boolValue]) {
            self.bodyImageView.image = self.selectedImage;
            self.model.ID = [responseObject[kData][@"id"] integerValue];
            self.model.image = self.selectedImage;
            self.model.pictureUrl = @"";
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationBodyImageChangeSuccess object:nil userInfo:nil];
        }else {

        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  TKCVideoRealViewController.m
//  TKC
//
//  Created by TKC on 2017/8/20.
//  Copyright © 2017年 TKC. All rights reserved.
//

#import "TKCVideoRealViewController.h"
#import "LZBRecordVideoVC.h"
#import <Photos/Photos.h>
@interface TKCVideoRealViewController ()
{
    NSString * _pinStr;
    NSString * _tips;
    NSInteger _kVideoMaxTime;
}
@end

@implementation TKCVideoRealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.title = @"视频认证";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUpLoadSuccess) name:kNSNotificationVerifyVedioSuccess object:nil];
    [self serviceData];
}

- (void)videoUpLoadSuccess {
    [self.navigationController popViewControllerAnimated:false];
}

- (void)serviceData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TXNetRequest getVideoPincodeSuccess:^(id responseObject) {
        
        NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"code"]];
        _pinStr = str;
        [self creatUI];
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)creatUI {
    UILabel * tipsLab = [TailorxFactory setLabWithText:@"" textColor:RGB(0, 0, 0) fontType:FONT(16)];
    NSString * str = @"请录制本人与身份证相貌相符的手持证件视频，要求手持证件正面清晰可见，完整露出持证人双手手臂，并用正常语速的普通话读出以下随机显示的4位数字，视频时长建议不超过15秒。";

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:102.0f / 255.0f alpha:1.0f] range:NSMakeRange(0, 23)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:102.0f / 255.0f alpha:1.0f] range:NSMakeRange(69, 14)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle setLineSpacing:8];
    
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    
    tipsLab.attributedText = attrStr;
    
    tipsLab.font = FONT(16);
    
    tipsLab.numberOfLines = 0;
    tipsLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLab];
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(90);
    }];
    
    CGFloat labW = W(50);
    CGFloat labD = (SCREEN_WIDTH - 60 - 4 * labW) / 3;
    for (int i = 0; i < [_pinStr length]; i++) {
        UILabel * lab = [TailorxFactory labWithTitle:[_pinStr substringWithRange:NSMakeRange(i,1)] titleColor:RGB(0, 0, 0) font:[UIFont fontWithName:@"PingFangSC-Medium" size:48]];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:lab];
        [lab borderForColor:RGB(0, 0, 0) borderWidth:1];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30 + (labW + labD) * i);
            make.top.mas_equalTo(tipsLab.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(labW, H(70)));
        }];
    }
    
    UIButton * btn = [TailorxFactory btnWithBackgroundNormalImage:[UIImage imageNamed:@"button 1-normal"] selectedImage:nil heighLightedImage:[UIImage imageNamed:@"button 1-pressed"] title:@"立即录制视频" titleColor:[UIColor whiteColor] font:FONT(16)];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-90);
    }];
    [btn addTarget:self action:@selector(btnCliked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnCliked {
    // 判断授权状态
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (videoStatus == AVAuthorizationStatusDenied) {
        [UIAlertController showAlertWithStyle:UIAlertControllerStyleAlert Title:@"温馨提示" message:@"请前往 -> [设置 - 隐私 - 相机 - TKC钱包] 打开访问开关" actionsMsg:@[@"去设置"] buttonActions:^(NSInteger index) {
            NSURL * url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            };
        } target:self];
    } else if (audioStatus == AVAuthorizationStatusDenied) {
        [UIAlertController showAlertWithStyle:UIAlertControllerStyleAlert Title:@"温馨提示" message:@"请前往 -> [设置 - 隐私 - 麦克风 - TailorX] 打开访问开关" actionsMsg:@[@"去设置"] buttonActions:^(NSInteger index) {
            NSURL * url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            };
        } target:self];
    } else {
        LZBRecordVideoVC * VC = [[LZBRecordVideoVC alloc] init];
        VC.kVideoMaxTime = 15;
        [self.navigationController presentViewController:VC animated:true completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

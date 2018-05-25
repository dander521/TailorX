//
//  LZBRecordVideoVC.m
//  LZBRecordingVideo
//
//  Created by Apple on 2017/2/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LZBRecordVideoVC.h"
#import "LZBRecordVideoTool.h"
#import "LZBRecordProcessView.h"
#import "Masonry.h"

@interface LZBRecordVideoVC ()<LZBRecordVideoToolDelegate>
{
    NSData * _data;
}

@property (nonatomic, strong) UIButton *closeButton; // 关闭当前界面按钮
@property (nonatomic, strong) UIButton *cameraButton; // 前后相机切换按钮
@property (nonatomic, strong) UIButton *recordingButton; // 录制按钮
@property (nonatomic, strong) UIView *containerView; // 拍摄界面

@property (nonatomic, strong) UIButton * abandonBtn; // 舍弃当前拍摄的视频
@property (nonatomic, strong) UIButton * sureBtn; // 确定使用当前拍摄的视频
@property (nonatomic, strong) UILabel * tipsLab; // 按住摄像的提示

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (nonatomic, strong) LZBRecordVideoTool *videoTool;
@property (nonatomic, strong) LZBRecordProcessView *progressView;
@property (nonatomic, assign) CGFloat timeCount;
@property (nonatomic, assign) CGFloat timeMargin;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,strong)AVPlayerLayer *playerLayer;//播放器，用于录制完视频后播放视频
@end

@implementation LZBRecordVideoVC

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self setupSubView];
    [self setupCaptureSession];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.recordingButton.center = CGPointMake(width *0.5, height - self.recordingButton.bounds.size.height - 42);
    self.progressView.center = self.recordingButton.center;
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.centerY.mas_equalTo(self.recordingButton.mas_centerY).offset(0);
    }];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.recordingButton.mas_top).offset(-12);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.abandonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(-30);
        make.bottom.mas_equalTo(-42);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(30);
        make.bottom.mas_equalTo(-42);
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.videoTool stopCapture];
    [self.videoTool stopRecordFunction];
}


- (void)setupSubView
{
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.cameraButton];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.recordingButton];
    [self.view addSubview:self.abandonBtn];
    [self.view addSubview:self.tipsLab];
    [self.view addSubview:self.sureBtn];
   
}

- (void)setupCaptureSession
{
   self.captureVideoPreviewLayer  =  [self.videoTool previewLayer];
    CALayer *layer=self.containerView.layer;
    layer.masksToBounds=YES;
    self.captureVideoPreviewLayer.frame = layer.bounds;
    [layer addSublayer:self.captureVideoPreviewLayer];
    //开启录制功能
    [self.videoTool startRecordFunction];
    
}

#pragma mark- action
- (void)closeButtonClick
{
    [self endRecordingVideo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)flashButtonClick:(UIButton *)flashButton
{
    flashButton.selected = !flashButton.isSelected;
    if(flashButton.selected)
    {
        [self.videoTool openFlashLight];
    }
    else
        [self.videoTool closeFlashLight];
}

- (void)cameraButtonClick:(UIButton *)cameraButton
{
    cameraButton.selected = !cameraButton.isSelected;
    if(cameraButton.selected)
    {
        [self.videoTool changeCameraInputDeviceisFront:YES];
    }
    else
        [self.videoTool changeCameraInputDeviceisFront:NO];
}

- (void)startRecordingVideo
{
    self.cameraButton.hidden = YES;
    [self startTimer];
    [self.videoTool startCapture];
}

- (void)endRecordingVideo
{
    if (self.timeCount > 2) {
        self.abandonBtn.hidden = NO;
        self.sureBtn.hidden = NO;
        self.tipsLab.hidden = YES;
        self.closeButton.hidden = YES;
        self.recordingButton.hidden = YES;
    } else {
        self.cameraButton.hidden = NO;
        self.abandonBtn.hidden = YES;
        self.sureBtn.hidden = YES;
        self.tipsLab.hidden = NO;
        self.closeButton.hidden = NO;
        self.recordingButton.hidden = NO;
    }
    
    [self stopTimer];
    [self.videoTool stopCapture];
}

- (void)abandonBtnClick:(UIButton *)abandonBtn {
    self.cameraButton.hidden = NO;
    self.abandonBtn.hidden = YES;
    self.sureBtn.hidden = YES;
    self.tipsLab.hidden = NO;
    self.closeButton.hidden = NO;
    self.recordingButton.hidden = NO;
    [_playerLayer removeFromSuperlayer];
    [_playerLayer.player.currentItem cancelPendingSeeks];
    [_playerLayer.player.currentItem.asset cancelLoading];
    _playerLayer = nil;
}

- (void)sureBtnClick:(UIButton *)sureBtn {
    NSLog(@"开始上传");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"正在上传";

    [TXNetRequest uploadVideoWithParam:nil keyArray:@[@"files"] fileDataArray:@[_data] progress:^(CGFloat num) {
        hud.progress = num;
        if (num == 1) {
            hud.mode = MBProgressHUDModeIndeterminate;
        }
    } success:^(id responseObject) {
        [hud hide:YES];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if ([dic[@"success"] intValue] == 1) {
            [MBProgressHUD showSuccess:@"视频上传成功"];
            NSLog(@"relative = %@", dic[@"videoUrl"]);
            
            [TXModelAchivar updateUserModelWithKey:@"videoPath" value:dic[@"videoUrl"]];
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationVerifyVedioSuccess object:nil];
            }];
        } else {
            [MBProgressHUD showError:dic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
    }];
}
#pragma mark - 定时器
- (void)startTimer
{
    self.progressView.hidden = NO;
    CGFloat signleTime = 0.01;
    self.timeCount = 0;
    self.timeMargin = signleTime;
    self.timer = [NSTimer  scheduledTimerWithTimeInterval:signleTime target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    self.progressView.progress = 0;
    //self.progressView.hidden = YES;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateProgress
{
    if(self.timeCount >=_kVideoMaxTime)
    {
        [self stopTimer];
        [self endRecordingVideo];
        return;
    }
    NSLog(@"======%lf",self.timeCount);
    self.timeCount +=self.timeMargin;
    CGFloat progress = self.timeCount/_kVideoMaxTime;
    self.progressView.progress = progress;
}

#pragma mark - delegate -

- (void)videoToolCaptureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (self.timeCount < 2) {
        [MBProgressHUD showError:@"视频录制太短，请重新录制"];
        return;
    }
    NSLog(@"------");
    //视频录制完之后自动播放
    AVPlayer * player = [AVPlayer playerWithURL:outputFileURL];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    _playerLayer.frame = self.captureVideoPreviewLayer.frame;
    [self.captureVideoPreviewLayer addSublayer:_playerLayer];
    [player play];
    
    _data = [NSData dataWithContentsOfURL:outputFileURL];
}

#pragma mark - lazy

- (UIView *)containerView
{
  if(_containerView == nil)
  {
      _containerView = [[UIView alloc]initWithFrame:self.view.bounds];
      _containerView.backgroundColor = RGB(240, 240, 240);
  }
    return _containerView;
}

- (UIButton *)closeButton
{
   if(_closeButton == nil)
   {
       _closeButton = [ UIButton buttonWithType:UIButtonTypeCustom];
       [_closeButton setImage:[UIImage imageNamed:@"视频认证_返回"] forState:UIControlStateNormal];
        _closeButton.bounds = CGRectMake(0, 0, 50, 50);
       _closeButton.layer.cornerRadius =  _closeButton.bounds.size.width * 0.5;
       _closeButton.layer.masksToBounds = YES;
       [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
   }
    return _closeButton;
}

- (UIButton *)cameraButton
{
    if(_cameraButton == nil)
    {
        _cameraButton = [ UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"视频认证_相机翻转"] forState:UIControlStateNormal];
        _cameraButton.bounds = CGRectMake(0, 0, 50, 50);
        _cameraButton.layer.cornerRadius =  _cameraButton.bounds.size.width * 0.5;
        _cameraButton.layer.masksToBounds = YES;
        [_cameraButton addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (UIButton *)recordingButton
{
    if(_recordingButton == nil)
    {
        _recordingButton = [ UIButton buttonWithType:UIButtonTypeCustom];
        [_recordingButton setImage:[UIImage imageNamed:@"视频认证_拍摄"] forState:UIControlStateNormal];
        _recordingButton.bounds = CGRectMake(0, 0, 64, 64);
        _recordingButton.layer.cornerRadius =  _recordingButton.bounds.size.width * 0.5;
        _recordingButton.layer.masksToBounds = YES;
        [_recordingButton addTarget:self action:@selector(startRecordingVideo) forControlEvents:UIControlEventTouchDown];
        [_recordingButton addTarget:self action:@selector(endRecordingVideo) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _recordingButton;
}

- (LZBRecordVideoTool *)videoTool
{
  if(_videoTool == nil)
  {
      _videoTool = [[LZBRecordVideoTool alloc]init];
      _videoTool.delegate = self;
  }
    return _videoTool;
}

- (LZBRecordProcessView *)progressView
{
  if(_progressView == nil)
  {
      CGFloat widthHeight = self.recordingButton.bounds.size.width +2*lineWith;
      _progressView = [[LZBRecordProcessView alloc]initWithCenter:CGPointMake(widthHeight *0.5, widthHeight*0.5) radius:(widthHeight-lineWith) *0.5];
      _progressView.bounds =CGRectMake(0, 0, widthHeight, widthHeight);
      _progressView.hidden = YES;
  }
    return _progressView;
}

- (UILabel *)tipsLab {
    if (_tipsLab == nil) {
        _tipsLab = [[UILabel alloc] init];
        _tipsLab.textColor = [UIColor whiteColor];
        _tipsLab.text = @"按住摄像";
        _tipsLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _tipsLab;
}

- (UIButton *)abandonBtn {
    if (_abandonBtn == nil) {
        _abandonBtn = [ UIButton buttonWithType:UIButtonTypeCustom];
        [_abandonBtn setImage:[UIImage imageNamed:@"视频认证_舍弃"] forState:UIControlStateNormal];
        [_abandonBtn addTarget:self action:@selector(abandonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _abandonBtn.hidden = YES;
    }
    return _abandonBtn;
}

- (UIButton *)sureBtn {
    if (_sureBtn == nil) {
        _sureBtn = [ UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setImage:[UIImage imageNamed:@"视频认证_确认"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.hidden = YES;
    }
    return _sureBtn;
}

@end

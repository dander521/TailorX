//
//  LZBRecordVideoTool.h
//  LZBRecordingVideo
//
//  Created by Apple on 2017/2/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol LZBRecordVideoToolDelegate <NSObject>

-(void)videoToolCaptureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error;

@end

@interface LZBRecordVideoTool : NSObject
@property (strong, nonatomic) NSString *videoPath;//视频路径
@property (nonatomic, weak) id <LZBRecordVideoToolDelegate> delegate;
//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer;

//启动录制功能
- (void)startRecordFunction;

//关闭录制功能
- (void)stopRecordFunction;

//开始录制
- (void) startCapture;

//停止录制
- (void) stopCapture;

//开启闪光灯
- (void)openFlashLight;

//关闭闪光灯
- (void)closeFlashLight;

//切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront;
@end

@interface LZBRecordVideoTool(Authorization)

/**
   相机是否可以用
 */
- (BOOL)isAvailableWithCamera;

/**
    麦克风是否可以用
 */
- (BOOL)isAvailableWithMic;
@end

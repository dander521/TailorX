//
//  GXTCrashTool.h
//  Tailorx
//
//  Created by 高习泰 on 16/8/10.
//  Copyright © 2016年   高习泰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXTCrashTool : NSObject {
    BOOL dismissed;
}
void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);
@end
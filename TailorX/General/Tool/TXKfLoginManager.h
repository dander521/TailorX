//
//  TXKfLoginManager.h
//  TailorX
//
//  Created by Qian Shen on 2/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXKfLoginManager : NSObject

/**
 * 登录IM
 */
+ (void)loginKefuSDKcomplete:(void (^)(bool success))complete;


@end

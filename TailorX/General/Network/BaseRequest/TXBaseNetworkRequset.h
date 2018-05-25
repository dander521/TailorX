//
//  TXBaseNetworkRequset.h
//  TailorX
//
//  Created by liuyanming on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXBaseNetworkRequset : NSObject

+ (void)requestWithURL:(NSString *)urlStr
                params:(id)params
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
               isLogin:(void(^)())login;

@end

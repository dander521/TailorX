//
//  HCRKeyChain.h
//  LoginDemo
//
//  Created by   徐安超 on 16/6/16.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface HCRKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;
@end

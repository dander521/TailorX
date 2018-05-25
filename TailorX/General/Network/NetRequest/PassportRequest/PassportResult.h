//
//  PassportResult.h
//  TailorX
//
//  Created by Qian Shen on 27/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassportResult : NSObject

/** 成功或者失败*/
@property (nonatomic) BOOL              success;

/** 失败信息*/
@property (nonatomic, strong) NSString  *msg;

/** 失败码*/
@property (nonatomic, strong) NSString  *code;

/** 数据包*/
@property (nonatomic, strong) NSObject  *data;

@property (nonatomic, strong) NSString  *total;

@end

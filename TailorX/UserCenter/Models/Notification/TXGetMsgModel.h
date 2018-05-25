//
//  TXGetMsgModel.h
//  TailorX
//
//  Created by Qian Shen on 5/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXGetMsgModel : NSObject

/** 消息内容*/
@property (nonatomic, strong) NSString *content;
/** 消息类型*/
@property (nonatomic, strong) NSString *contentType;
/** 消息类型Id */
@property (nonatomic, strong) NSString *contentTypeId;
/** 创建时间*/
@property (nonatomic, assign) NSInteger createTime;
/** 主键ID*/
@property (nonatomic, assign) NSInteger ID;
/** 消息状态（0未读，1已读，2删除*/
@property (nonatomic, assign) NSInteger status;
/** 接收人ID*/
@property (nonatomic, assign) NSInteger userId;

@end

//
//  TXCommentNotPassModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCommentNotPassModel : NSObject

/** 评论的内容 */
@property (nonatomic, strong) NSString *content;
/** 发布时间 */
@property (nonatomic, assign) NSInteger createDate;
/** 咨询id */
@property (nonatomic, strong) NSString *infoCover;
/** 审核拒绝原因 */
@property (nonatomic, assign) NSInteger infoId;
/** 咨询名称 */
@property (nonatomic, strong) NSString *infoName;
/** 咨询封面 */
@property (nonatomic, strong) NSString *reason;

@end

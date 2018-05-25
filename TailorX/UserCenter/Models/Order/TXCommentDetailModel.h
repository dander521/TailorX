//
//  TXCommentDetailModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCommentDetailModel : NSObject

/** 评论内容 */
@property (nonatomic, strong) NSString *content;
/** 设计师评分 */
@property (nonatomic, assign) NSInteger designerScore;
/** 工厂评分 */
@property (nonatomic, assign) NSInteger factoryScore;
/** 综合评分 */
@property (nonatomic, assign) NSInteger overallScore;
/** 评论图片 */
@property (nonatomic, strong) NSArray *pics;

@end

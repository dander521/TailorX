//
//  TXDesignerCommentListModel.h
//  TailorX
//
//  Created by Qian Shen on 7/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXDesignerCommentListModel : NSObject

/** 评论内容*/
@property (nonatomic, strong) NSString *content;
/** 创建时间*/
@property (nonatomic, strong) NSString *createDate;
/** 评论人名字*/
@property (nonatomic, strong) NSString *customerName;
/** 评论人头像*/
@property (nonatomic, strong) NSString *photo;
/** 评论主键ID*/
@property (nonatomic, assign) NSInteger ID;
/** 评论图片的路径*/
@property (nonatomic, strong) NSArray *pictureList;

@end

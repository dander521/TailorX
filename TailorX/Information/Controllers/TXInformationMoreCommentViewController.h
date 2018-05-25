//
//  TXInformationMoreCommentViewController.h
//  TailorX
//
//  Created by 温强 on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"

typedef void(^CommentSuccessBlock)();

@interface TXInformationMoreCommentViewController : TXBaseViewController

/** 资讯ID */
@property (nonatomic, copy) NSString *informationNo;

/** 是否弹出键盘*/
@property (nonatomic, assign) BOOL isShowKeyBoard;

/** 评论成功回调 */
@property (nonatomic, copy) CommentSuccessBlock commentSuccessBlock;

@end

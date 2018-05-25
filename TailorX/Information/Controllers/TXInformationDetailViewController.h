//
//  TXInformationDetailViewController.h
//  TailorX
//
//  Created by 温强 on 2017/4/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"
#import "TXInfomationHeadView.h"

typedef void (^FavoriteChangedBlock)(BOOL isLiked);
typedef void (^ShareBlock)();

@interface TXInformationDetailViewController : TXBaseViewController<UINavigationControllerDelegate>
/** 头部视图*/
@property (nonatomic, strong) TXInfomationHeadView *headerView;
/** 资讯ID*/
@property (nonatomic, strong) NSString *informationNo;
/** 资讯列表*/
@property (nonatomic, strong) NSString *coverUrl;
/** 资讯图片的宽*/
@property (nonatomic, assign) CGFloat coverImgWidth;
/** 资讯图片的高*/
@property (nonatomic, assign) CGFloat coverImgHeight;
/** 记录该资讯是否被收藏 */
@property (nonatomic, assign) BOOL isFavorited;

@property (nonatomic, copy) FavoriteChangedBlock favoriteChangedBlock;
/** 分享回调*/
@property (nonatomic, copy) ShareBlock shareBlock;
/** 下标*/
@property (nonatomic, strong) NSIndexPath *currenIndexPath;


@end

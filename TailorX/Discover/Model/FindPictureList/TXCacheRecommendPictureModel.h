//
//  TXCacheRecommendPictureModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/11/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXFindPictureModel.h"

@interface TXCacheRecommendPictureModel : NSObject

/** 是否已经加载 */
@property (nonatomic, assign) BOOL isLoad;
/** 是否已经加载完所有数据 */
@property (nonatomic, assign) BOOL isEnd;
/** 推荐数据 */
@property (nonatomic, strong) NSMutableArray <TXFindPictureListModel *>*recommendList;

@end

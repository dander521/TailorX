//
//  TXStoreAlbumController.h
//  TailorX
//
//  Created by Qian Shen on 21/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"
#import "TXStoreDetailModel.h"

@interface TXStoreAlbumController : TXBaseViewController

/** 数据源*/
@property (nonatomic, strong) NSArray<TXPicturesModel*> *dataSource;

@end

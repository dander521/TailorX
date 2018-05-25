//
//  TXReservaDesingerViewController.h
//  TailorX
//
//  Created by Qian Shen on 14/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBaseViewController.h"
#import "TXDesignerDetailModel.h"
#import "TXStoreDetailModel.h"


@interface TXReservaDesingerViewController : TXBaseViewController

/** 设计师ID*/
@property (nonatomic, strong) NSString *designerId;
/** 头像是否可点击*/
@property (nonatomic, assign) BOOL isHeadImgBtnClick;
/** 是否显示时尚标签*/
@property (nonatomic, assign) BOOL isShowLabel;
/** 预约类型*/
@property (nonatomic, assign) BOOL customType; // 0 预约设计师 1 门店定制
/** 门店定制 是否同城*/
@property (nonatomic, assign) BOOL isSameStoreCity;
/** 门店详情信息*/
@property (nonatomic, strong) TXStoreDetailModel *storeDetailModel;

@end

@interface OrderDesignerInfoModel : NSObject

/** 是否在同一个城市*/
@property (nonatomic, assign) BOOL isSameCity;
/** 设计师头像*/
@property (nonatomic, strong) NSString *designerPhoto;
/** 门店名字*/
@property (nonatomic, strong) NSString *storeName;
/** 门店地址*/
@property (nonatomic, strong) NSString *storeAddress;
/** 工作时间*/
@property (nonatomic, strong) NSString *workTime;
/** 设计师名字*/
@property (nonatomic, strong) NSString *designerName;

@end


//
//  TXQueueNoModel.h
//  TailorX
//
//  Created by liuyanming on 2017/3/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

//rankId-排号主键ID；sortNo-排号；amount-金额（未出让则返回的是最后一次交易价格）；categoryName-品类；saleStatus-状态，0未出让，1出让中，交易中；userName-拥有者姓名；ownerType-拥有者归类，0自己，1他人

@interface TXQueueNoModel : NSObject

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * rankId;
@property (nonatomic, assign) NSInteger saleStatus;
@property (nonatomic, assign) NSInteger sortNo;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, assign) NSInteger ownerType;
@property (nonatomic, strong) NSString * orderNo;


@end


@interface TXQueueNoList : NSObject

@property (nonatomic, strong) NSArray * queueNos;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger totalSize;


@end

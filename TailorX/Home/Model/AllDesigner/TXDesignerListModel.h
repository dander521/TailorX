//
//  TXDesignerListModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/8/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXDesignerListModel : NSObject

/** id */
@property (nonatomic, strong) NSString *ID;
/** name */
@property (nonatomic, strong) NSString *name;
/** 图片 */
@property (nonatomic, strong) NSString *photo;
/** 产品类型 */
@property (nonatomic, strong) NSString *goodStyle;
/** 门店名 */
@property (nonatomic, strong) NSString *storeName;
/** 使用次数 */
@property (nonatomic, assign) NSInteger usedCount;
/** 评分 */
@property (nonatomic, assign) NSInteger score;
/** 订单数量 */
@property (nonatomic, assign) NSInteger order_count;
/** 距离 */
@property (nonatomic, assign) NSInteger distance;

@end

@interface TXAllDesignerListModel : NSObject

/** 数据源 */
@property (nonatomic, strong) NSMutableArray <TXDesignerListModel *>*data;

@end

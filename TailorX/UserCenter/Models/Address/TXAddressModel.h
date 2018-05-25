//
//  TXAddress.h
//  TailorX
//
//  Created by RogerChen on 2017/4/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXAddressModel : NSObject

/** 详细地址 */
@property (nonatomic, strong) NSString *address;
/** 市 */
@property (nonatomic, strong) NSString *cityName;
/** 区 */
@property (nonatomic, strong) NSString *districtName;
/** 客户地址id */
@property (nonatomic, assign) NSInteger idField;
/** 是否为默认地址：1是 0否 */
@property (nonatomic, assign) NSInteger isDefault;
/** 收件人 */
@property (nonatomic, strong) NSString *name;
/** 邮编  */
@property (nonatomic, strong) NSString *postcode;
/** 省 */
@property (nonatomic, strong) NSString *provinceName;
/** 联系方式 */
@property (nonatomic, strong) NSString *telephone;

- (NSString *)combineUserAddress;

@end

@interface TXAddressCollectionModel : NSObject

/** 地址对象数组 */
@property (nonatomic, strong) NSMutableArray *data;

@end

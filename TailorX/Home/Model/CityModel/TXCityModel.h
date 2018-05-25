//
//  TXCityModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/5/16.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCityModel : NSObject

/** 城市编码 */
@property (nonatomic, strong) NSString *code;
/** 首字母 */
@property (nonatomic, strong) NSString *initial;
/** 城市名称 */
@property (nonatomic, strong) NSString *name;

@end

@interface TXCityCollectionModel : NSObject

/** 城市集合 */
@property (nonatomic, strong) NSArray *data;

@end

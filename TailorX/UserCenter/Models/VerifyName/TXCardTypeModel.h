//
//  TXCardType.h
//  TailorX
//
//  Created by RogerChen on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCardTypeModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) NSInteger value;

@end

@interface TXCardTypeCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end

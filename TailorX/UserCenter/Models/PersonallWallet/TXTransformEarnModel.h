//
//  TXTransformEarnModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/9/15.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXTransformEarnModel : NSObject

@property (nonatomic, strong) NSString * balance;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) NSString * income;
@property (nonatomic, assign) float moneyMax;
@property (nonatomic, assign) float moneyMin;
@property (nonatomic, assign) float ratio;
@property (nonatomic, assign) NSInteger transferCount;

@end

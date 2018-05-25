//
//  TXTransactionRecordModel.h
//  TailorX
//
//  Created by liuyanming on 2017/4/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXTransactionRecordModel : NSObject

@property (nonatomic, strong) NSString * amount;
@property (nonatomic, assign) NSInteger date;
@property (nonatomic, strong) NSString * dateStr;
@property (nonatomic, strong) NSString * name;

@end


@interface TXTransactionRecordModelList : NSObject

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger totalSize;

@end

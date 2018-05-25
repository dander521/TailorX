//
//  TXFindRecordListModel.h
//  TailorX
//
//  Created by liuyanming on 2017/4/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TXFindRecordModel : NSObject

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, assign) NSInteger saleStatus;
@property (nonatomic, assign) NSInteger sortNoBuy; 
@property (nonatomic, assign) NSInteger sortNoSale;
@property (nonatomic, strong) NSString *tradeNo;
@property (nonatomic, strong) NSString *tradeTime;
@property (nonatomic, strong) NSString *userName;

@end

@interface TXFindRecordListModel : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger totalSize;

@end



//
//  TXTagGroupModel.h
//  TailorX
//
//  Created by Qian Shen on 21/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXTagGroupModel : NSObject

@property (nonatomic, strong) NSString  *coverImg;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger delFlag;
@property (nonatomic, strong) NSString  *desc;
@property (nonatomic, strong) NSString  *ID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) NSInteger updateTime;

@end

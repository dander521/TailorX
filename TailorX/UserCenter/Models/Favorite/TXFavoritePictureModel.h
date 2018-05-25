//
//  TXFavoritePictureModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/8/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXFavoritePictureModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger popularity;
@property (nonatomic, assign) NSInteger amountOfReading;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@end

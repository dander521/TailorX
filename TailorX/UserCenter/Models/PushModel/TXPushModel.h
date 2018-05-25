//
//  TXPushModel.h
//  TailorX
//
//  Created by liuyanming on 2017/4/10.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TXPushModel : NSObject

@property (nonatomic, assign) NSInteger shake;
@property (nonatomic, assign) NSInteger sound;
@property (nonatomic, assign) NSInteger dontDisturb;


singleton_interface(TXPushModel);

@end

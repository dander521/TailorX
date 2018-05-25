//
//  TXSetView.h
//  TailorX
//
//  Created by 温强 on 2017/3/22.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AboutUsBlock)();

@interface TXSetView : UIView

@property (nonatomic, copy) AboutUsBlock aboutUsBlock;

+ (instancetype)instanse;
@end

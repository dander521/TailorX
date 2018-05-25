//
//  TXFromTransition.h
//  TailorX
//
//  Created by Qian Shen on 4/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXToTransition.h"

@interface TXFromTransition : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(TransitionType)type;


@end

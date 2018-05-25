//
//  TXToTransition.h
//  TailorX
//
//  Created by Qian Shen on 4/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransitionType) {
    TransitionInformation = 0,
    TransitionPicture,
    TransitionRecommend,
    TransitionFavoriteInformation,
    TransitionFavoritePicture,
    TransitionSearch
};


@interface TXToTransition : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(TransitionType)type currenIndexPath:(NSIndexPath*)indexPath;

@end

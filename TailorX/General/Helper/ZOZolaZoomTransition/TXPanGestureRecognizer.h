//
//  TXPanGestureRecognizer.h
//  TailorX
//
//  Created by Qian Shen on 25/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, PanGestureRecognizerDirection) {
    PanGestureRecognizerDirectionRight = 1 << 0,
    PanGestureRecognizerDirectionLeft = 1 << 1,
    PanGestureRecognizerDirectionUp = 1 << 2,
    PanGestureRecognizerDirectionDown = 1 << 3,
};


@interface TXPanGestureRecognizer : UIPanGestureRecognizer {
    int _moveX;
    int _moveY;
}

/**
 *  拖动方向
 */
@property (nonatomic, assign) PanGestureRecognizerDirection direction;

@end

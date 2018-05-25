//
//  TXPanGestureRecognizer.m
//  TailorX
//
//  Created by Qian Shen on 25/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

static const CGFloat PanTriggerDistance = 1;

@interface TXPanGestureRecognizer ()

@property (nonatomic, assign) CGPoint beginPoint;

@end

@implementation TXPanGestureRecognizer

-(instancetype)initWithTarget:(id)target action:(SEL)action
{
    if (self = [super initWithTarget:target action:action]) {
        _direction = PanGestureRecognizerDirectionRight|
                     PanGestureRecognizerDirectionLeft|
                     PanGestureRecognizerDirectionUp|
                     PanGestureRecognizerDirectionDown;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.beginPoint = [(UITouch *)[touches anyObject] locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint current = [(UITouch *)[touches anyObject] locationInView:self.view];
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    
    if(self.state == UIGestureRecognizerStatePossible ) {
        if (abs(_moveX) > PanTriggerDistance) {
            self.state = UIGestureRecognizerStateChanged;
            _moveX = 0;
            _moveY = 0;
        }
    }
    CGPoint movement = CGPointMake(current.x-self.beginPoint.x, current.y-self.beginPoint.y);
    if ((movement.x > PanTriggerDistance)&&(_direction&PanGestureRecognizerDirectionRight)) {
        //右
        [super touchesMoved:touches withEvent:event];
    } else if ((movement.x < -PanTriggerDistance)&&(_direction&PanGestureRecognizerDirectionLeft)&&(fabs(movement.x)>fabs(movement.y))) {
        //左
        [super touchesMoved:touches withEvent:event];
    } else if ((movement.y > PanTriggerDistance)&&(_direction&PanGestureRecognizerDirectionDown)&&(fabs(movement.y)>fabs(movement.x))) {
        //下
        [super touchesMoved:touches withEvent:event];
    } else if ((movement.y < -PanTriggerDistance)&&(_direction&PanGestureRecognizerDirectionUp)&&(fabs(movement.y)>fabs(movement.x))) {
        //上
        [super touchesMoved:touches withEvent:event];
    } else if ((fabs(movement.x)<PanTriggerDistance)&&(fabs(movement.y)<PanTriggerDistance)){
        self.state = UIGestureRecognizerStatePossible;
    }else {
        //结束移动
        [self ignoreTouch:[touches anyObject] forEvent:event];
        self.state = UIGestureRecognizerStateFailed;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}




@end

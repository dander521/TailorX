//
//  TXFromTransition.m
//  TailorX
//
//  Created by Qian Shen on 4/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFromTransition.h"
#import "TXWaterfallColCell.h"
#import "TXInfomationHeadView.h"

// 资讯
#import "TXInformationDetailViewController.h"
#import "TXFashionViewController.h"

// 图片
#import "TXDiscoveViewController.h"
#import "TXDiscoverDetailCollectionViewController.h"
#import "TXDiscoverDetailCollectionViewCell.h"

// 收藏
#import "TXFavoriteViewController.h"

#import "TXSearchResultViewController.h"


@interface TXFromTransition ()

@property (nonatomic, assign) TransitionType type;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation TXFromTransition

- (instancetype)initWithTransitionType:(TransitionType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case TransitionInformation: {
            TXFashionViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXInformationDetailViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得图片对应的cell
            [fromViewController.collectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[fromViewController.collectionView cellForItemAtIndexPath:[fromViewController.collectionView indexPathsForSelectedItems].lastObject];
            UIView *cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
            cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            toViewController.view.alpha = 0;
            toViewController.headerView.coverImgView.hidden = YES;
            
            [containerView addSubview:toViewController.view];
            [containerView addSubview:cellImageSnapshot];
            
            [UIView animateWithDuration:duration animations:^{
                toViewController.view.alpha = 1.0;
                CGRect frame = [containerView convertRect:CGRectMake(toViewController.headerView.frame.origin.x + 16, toViewController.headerView.frame.origin.y + 16, SCREEN_WIDTH-32, toViewController.headerView.frame.size.height-16) fromView:toViewController.headerView];
                cellImageSnapshot.frame = frame;
                [toViewController.headerView.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:toViewController.coverUrl] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            }completion:^(BOOL finished) {
                toViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [cellImageSnapshot removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
            
        case TransitionPicture: {
            TXDiscoveViewController *fromViewController = (TXDiscoveViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXDiscoverDetailCollectionViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得图片对应的cell
            [fromViewController.currenCollectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[fromViewController.currenCollectionView cellForItemAtIndexPath:[fromViewController.currenCollectionView indexPathsForSelectedItems].lastObject];
            UIView *cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
            cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            toViewController.view.alpha = 0;
            
            toViewController.headerView.coverImgView.hidden = YES;
 
            [containerView addSubview:toViewController.view];
            [containerView addSubview:cellImageSnapshot];
            
            [UIView animateWithDuration:duration animations:^{
                toViewController.view.alpha = 1.0;
                CGRect frame = [containerView convertRect:CGRectMake(toViewController.headerView.frame.origin.x + 16, toViewController.headerView.frame.origin.y - 48, SCREEN_WIDTH-32, toViewController.headerView.frame.size.height-16) fromView:toViewController.headerView];
                cellImageSnapshot.frame = frame;
                [toViewController.headerView.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:toViewController.model.imgUrl] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            } completion:^(BOOL finished) {
                toViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [cellImageSnapshot removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
        case TransitionRecommend: {
            TXDiscoverDetailCollectionViewController *fromViewController = (TXDiscoverDetailCollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXDiscoverDetailCollectionViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            
            TXDiscoverDetailCollectionViewCell *collectionCell = (TXDiscoverDetailCollectionViewCell *)[fromViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromViewController.currenIndex inSection:0]];
            
            //获得图片对应的cell
            [collectionCell.collectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[collectionCell.collectionView cellForItemAtIndexPath:[collectionCell.collectionView indexPathsForSelectedItems].lastObject];
            UIView *cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
            cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            toViewController.view.alpha = 0;
            toViewController.headerView.coverImgView.hidden = YES;
            
            [containerView addSubview:toViewController.view];
            [containerView addSubview:cellImageSnapshot];
            
            [UIView animateWithDuration:duration animations:^{
                toViewController.view.alpha = 1.0;
                CGRect frame = [containerView convertRect:CGRectMake(toViewController.headerView.frame.origin.x + 16, toViewController.headerView.frame.origin.y-48, SCREEN_WIDTH-32, toViewController.headerView.frame.size.height-16) fromView:toViewController.headerView];
                cellImageSnapshot.frame = frame;
                [toViewController.headerView.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:toViewController.model.imgUrl] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            }completion:^(BOOL finished) {
                toViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [cellImageSnapshot removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
        case TransitionFavoriteInformation: {
            TXFavoriteViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXInformationDetailViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得图片对应的cell
            [fromViewController.currenCollectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[fromViewController.currenCollectionView cellForItemAtIndexPath:[fromViewController.currenCollectionView indexPathsForSelectedItems].lastObject];
            UIView *cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
            cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            toViewController.view.alpha = 0;
            toViewController.headerView.coverImgView.hidden = YES;
            [containerView addSubview:toViewController.view];
            [containerView addSubview:cellImageSnapshot];
            
            [UIView animateWithDuration:duration animations:^{
                toViewController.view.alpha = 1.0;
                CGRect frame = [containerView convertRect:CGRectMake(toViewController.headerView.frame.origin.x + 16, toViewController.headerView.frame.origin.y + 16, SCREEN_WIDTH-32, toViewController.headerView.frame.size.height-16) fromView:toViewController.headerView];
                cellImageSnapshot.frame = frame;
                [toViewController.headerView.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:toViewController.coverUrl] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            }completion:^(BOOL finished) {
                toViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [cellImageSnapshot removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
        case TransitionFavoritePicture: {
            TXFavoriteViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXDiscoverDetailCollectionViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得图片对应的cell
            [fromViewController.currenCollectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[fromViewController.currenCollectionView cellForItemAtIndexPath:[fromViewController.currenCollectionView indexPathsForSelectedItems].lastObject];
            UIView *cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
            cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            toViewController.view.alpha = 0;
            toViewController.headerView.coverImgView.hidden = YES;
            
            [containerView addSubview:toViewController.view];
            [containerView addSubview:cellImageSnapshot];
            
            [UIView animateWithDuration:duration animations:^{
                toViewController.view.alpha = 1.0;
                CGRect frame = [containerView convertRect:CGRectMake(toViewController.headerView.frame.origin.x + 16, toViewController.headerView.frame.origin.y - 48, SCREEN_WIDTH-32, toViewController.headerView.frame.size.height-16) fromView:toViewController.headerView];
                cellImageSnapshot.frame = frame;
                [toViewController.headerView.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:toViewController.model.imgUrl] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            }completion:^(BOOL finished) {
                toViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [cellImageSnapshot removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
            
        case TransitionSearch: {
            TXSearchResultViewController *fromViewController = (TXSearchResultViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXDiscoverDetailCollectionViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得图片对应的cell
            [fromViewController.currenCollectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[fromViewController.currenCollectionView cellForItemAtIndexPath:[fromViewController.currenCollectionView indexPathsForSelectedItems].lastObject];
            UIView *cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
            cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            toViewController.view.alpha = 0;
            
            toViewController.headerView.coverImgView.hidden = YES;
            
            [containerView addSubview:toViewController.view];
            [containerView addSubview:cellImageSnapshot];
            
            [UIView animateWithDuration:duration animations:^{
                toViewController.view.alpha = 1.0;
                CGRect frame = [containerView convertRect:CGRectMake(toViewController.headerView.frame.origin.x + 16, toViewController.headerView.frame.origin.y - 48, SCREEN_WIDTH-32, toViewController.headerView.frame.size.height-16) fromView:toViewController.headerView];
                cellImageSnapshot.frame = frame;
                [toViewController.headerView.coverImgView sd_small_setImageWithURL:[NSURL URLWithString:toViewController.model.imgUrl] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
            } completion:^(BOOL finished) {
                toViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [cellImageSnapshot removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
        default:
            break;
    }
}

@end

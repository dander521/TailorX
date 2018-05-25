//
//  TXToTransition.m
//  TailorX
//
//  Created by Qian Shen on 4/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXToTransition.h"
#import "TXWaterfallColCell.h"

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

@interface TXToTransition ()

@property (nonatomic, assign) TransitionType type;

@property (nonatomic, strong) NSIndexPath *currenIndexPath;


@end


@implementation TXToTransition

- (instancetype)initWithTransitionType:(TransitionType)type currenIndexPath:(NSIndexPath*)indexPath {
    if (self = [super init]) {
        _type = type;
        _currenIndexPath = indexPath;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case TransitionInformation: {
            TXInformationDetailViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXFashionViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    toViewController.tabBarController.tabBar.alpha = 1;
                }];
            });
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得要移动的图片的快照
            [fromViewController.headerView  layoutIfNeeded];
            UIView *imageSnapshot = [fromViewController.headerView.coverImgView snapshotViewAfterScreenUpdates:NO];
            imageSnapshot.frame = [containerView convertRect:fromViewController.headerView.coverImgView.frame fromView:fromViewController.headerView.coverImgView.superview];
            fromViewController.headerView.coverImgView.hidden = YES;
            //获得图片对应的cell
            [toViewController.collectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[toViewController.collectionView cellForItemAtIndexPath:self.currenIndexPath];
            [cell layoutIfNeeded];
            [cell.contentView layoutIfNeeded];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            [containerView addSubview:imageSnapshot];
            [UIView animateWithDuration:duration animations:^{
                fromViewController.view.alpha = 0.0;
                imageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            } completion:^(BOOL finished) {
                [imageSnapshot removeFromSuperview];
                fromViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
        case TransitionPicture: {
            TXDiscoverDetailCollectionViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXDiscoveViewController *toViewController = (TXDiscoveViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    toViewController.tabBarController.tabBar.alpha = 1;
                }];
            });
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得要移动的图片的快照
            [fromViewController.headerView.coverImgView layoutIfNeeded];
            
            //获得图片对应的cell
            [toViewController.currenCollectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[toViewController.currenCollectionView cellForItemAtIndexPath:self.currenIndexPath];
            NSLog(@"%zd--%zd",((NSIndexPath*)[toViewController.currenCollectionView indexPathsForSelectedItems].firstObject).section,((NSIndexPath*)[toViewController.currenCollectionView indexPathsForSelectedItems].firstObject).row)
            [cell layoutIfNeeded];
            [cell.contentView layoutIfNeeded];
            cell.imageView.hidden = YES;
            
            UIView *imageSnapshot = [fromViewController.headerView.coverImgView snapshotViewAfterScreenUpdates:NO];

            TXDiscoverDetailCollectionViewCell *fromCell = (TXDiscoverDetailCollectionViewCell *)[fromViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromViewController.currenIndex inSection:0]];
            
            imageSnapshot.frame = [containerView convertRect:fromCell.reusableHeaderView.coverImgView.frame fromView:fromCell.collectionView];
            
            fromViewController.headerView.coverImgView.hidden = YES;
            
            // 设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            [containerView addSubview:imageSnapshot];
            [UIView animateWithDuration:duration animations:^{
                fromViewController.view.alpha = 0.0;
                imageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            } completion:^(BOOL finished) {
                [imageSnapshot removeFromSuperview];
                fromViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
        case TransitionRecommend: {
            TXDiscoverDetailCollectionViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXDiscoverDetailCollectionViewController *toViewController = (TXDiscoverDetailCollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    toViewController.tabBarController.tabBar.alpha = 1;
                }];
            });
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得要移动的图片的快照
            [fromViewController.headerView  layoutIfNeeded];
            UIView *imageSnapshot = [fromViewController.headerView.coverImgView snapshotViewAfterScreenUpdates:NO];
            TXDiscoverDetailCollectionViewCell *fromCell = (TXDiscoverDetailCollectionViewCell *)[fromViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromViewController.currenIndex inSection:0]];
            
            imageSnapshot.frame = [containerView convertRect:fromCell.reusableHeaderView.coverImgView.frame fromView:fromCell.collectionView];
            fromViewController.headerView.coverImgView.hidden = YES;
            //获得图片对应的cell
            [toViewController.collectionView layoutIfNeeded];
            
            TXDiscoverDetailCollectionViewCell *toCell = (TXDiscoverDetailCollectionViewCell *)[toViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toViewController.currenIndex inSection:0]];
            
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[toCell.collectionView cellForItemAtIndexPath:self.currenIndexPath];
            [cell layoutIfNeeded];
            [cell.contentView layoutIfNeeded];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            [containerView addSubview:imageSnapshot];
            [UIView animateWithDuration:duration animations:^{
                fromViewController.view.alpha = 0.0;
                imageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            } completion:^(BOOL finished) {
                [imageSnapshot removeFromSuperview];
                fromViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
        case TransitionFavoriteInformation: {
            TXInformationDetailViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXFavoriteViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    toViewController.tabBarController.tabBar.alpha = 1;
                }];
            });
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得要移动的图片的快照
            [fromViewController.headerView  layoutIfNeeded];
            UIView *imageSnapshot = [fromViewController.headerView.coverImgView snapshotViewAfterScreenUpdates:NO];
            imageSnapshot.frame = [containerView convertRect:fromViewController.headerView.coverImgView.frame fromView:fromViewController.headerView.coverImgView.superview];
            fromViewController.headerView.coverImgView.hidden = YES;
            //获得图片对应的cell
            [toViewController.currenCollectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[toViewController.currenCollectionView cellForItemAtIndexPath:self.currenIndexPath];
            [cell layoutIfNeeded];
            [cell.contentView layoutIfNeeded];
            cell.imageView.hidden = YES;
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            [containerView addSubview:imageSnapshot];
            [UIView animateWithDuration:duration animations:^{
                fromViewController.view.alpha = 0.0;
                imageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            } completion:^(BOOL finished) {
                [imageSnapshot removeFromSuperview];
                fromViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
        case TransitionFavoritePicture: {
            TXDiscoverDetailCollectionViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXFavoriteViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    toViewController.tabBarController.tabBar.alpha = 1;
                }];
            });
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得要移动的图片的快照
            [fromViewController.headerView  layoutIfNeeded];
            NSLog(@"%@----ccoverImgViewFrame",NSStringFromCGRect(fromViewController.headerView.coverImgView.frame));
            
            TXDiscoverDetailCollectionViewCell *toCell = (TXDiscoverDetailCollectionViewCell *)[fromViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromViewController.currenIndex inSection:0]];
            
            UIView *imageSnapshot = [fromViewController.headerView.coverImgView snapshotViewAfterScreenUpdates:NO];
            imageSnapshot.frame = [containerView convertRect:fromViewController.headerView.coverImgView.frame fromView:toCell.collectionView];
            fromViewController.headerView.coverImgView.hidden = YES;
            //获得图片对应的cell
            [toViewController.currenCollectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[toViewController.currenCollectionView cellForItemAtIndexPath:self.currenIndexPath];
            [cell layoutIfNeeded];
            [cell.contentView layoutIfNeeded];
            cell.imageView.hidden = YES;
            NSLog(@"%@----cellFrame",NSStringFromCGRect(cell.frame));
            //设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            [containerView addSubview:imageSnapshot];
            [UIView animateWithDuration:duration animations:^{
                fromViewController.view.alpha = 0.0;
                imageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            } completion:^(BOOL finished) {
                [imageSnapshot removeFromSuperview];
                fromViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
            
        case TransitionSearch: {
            TXDiscoverDetailCollectionViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            TXSearchResultViewController *toViewController = (TXSearchResultViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.tabBarController.tabBar.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    toViewController.tabBarController.tabBar.alpha = 1;
                }];
            });
            UIView *containerView = [transitionContext containerView];
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            //获得要移动的图片的快照
            [fromViewController.headerView.coverImgView layoutIfNeeded];
            
            //获得图片对应的cell
            [toViewController.currenCollectionView layoutIfNeeded];
            TXWaterfallColCell *cell = (TXWaterfallColCell*)[toViewController.currenCollectionView cellForItemAtIndexPath:self.currenIndexPath];
            NSLog(@"%zd--%zd",((NSIndexPath*)[toViewController.currenCollectionView indexPathsForSelectedItems].firstObject).section,((NSIndexPath*)[toViewController.currenCollectionView indexPathsForSelectedItems].firstObject).row)
            [cell layoutIfNeeded];
            [cell.contentView layoutIfNeeded];
            cell.imageView.hidden = YES;
            
            UIView *imageSnapshot = [fromViewController.headerView.coverImgView snapshotViewAfterScreenUpdates:NO];
            
            TXDiscoverDetailCollectionViewCell *fromCell = (TXDiscoverDetailCollectionViewCell *)[fromViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromViewController.currenIndex inSection:0]];
            
            imageSnapshot.frame = [containerView convertRect:fromCell.reusableHeaderView.coverImgView.frame fromView:fromCell.collectionView];
            
            fromViewController.headerView.coverImgView.hidden = YES;
            
            // 设置初始view的状态
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            [containerView addSubview:imageSnapshot];
            [UIView animateWithDuration:duration animations:^{
                fromViewController.view.alpha = 0.0;
                imageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
            } completion:^(BOOL finished) {
                [imageSnapshot removeFromSuperview];
                fromViewController.headerView.coverImgView.hidden = NO;
                cell.imageView.hidden = NO;
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }
            break;
            
        default:
            break;
    }
}

@end

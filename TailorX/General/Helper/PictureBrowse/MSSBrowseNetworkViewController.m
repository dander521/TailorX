//
//  MSSBrowseNetworkViewController.m
//  MSSBrowse
//
//  Created by 于威 on 16/4/26.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSBrowseNetworkViewController.h"
#import "EMSDImageCache.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+MSSLayout.h"
#import "UIImage+MSSScale.h"

@implementation MSSBrowseNetworkViewController

- (void)loadBrowseImageWithBrowseItem:(MSSBrowseModel *)browseItem Cell:(MSSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect
{
    // 停止加载
    [cell.loadingView stopAnimation];
    // 判断大图是否存在
    if ([[EMSDImageCache sharedImageCache] imageFromMemoryCacheForKey:browseItem.bigImageUrl]) {
        // 显示大图
        [self showBigImage:cell.zoomScrollView.zoomImageView browseItem:browseItem rect:bigImageRect];
    }else{
        self.isFirstOpen = NO;
        // 加载大图
        [self loadBigImageWithBrowseItem:browseItem cell:cell rect:bigImageRect];
    }

}

- (void)showBigImage:(UIImageView *)imageView browseItem:(MSSBrowseModel *)browseItem rect:(CGRect)rect
{
    // 取消当前请求防止复用问题
//    [imageView sd_cancelCurrentImageLoad];
    [imageView sd_cancelCurrentAnimationImagesLoad];
    
    // 如果存在直接显示图片
    imageView.image = [[EMSDImageCache sharedImageCache]imageFromDiskCacheForKey:browseItem.bigImageUrl];
    // 当大图frame为空时，需要大图加载完成后重新计算坐标
    CGRect bigRect = [self getBigImageRectIfIsEmptyRect:rect bigImage:imageView.image];
    // 第一次打开浏览页需要加载动画
    if(self.isFirstOpen)
    {
        self.isFirstOpen = NO;

        if (browseItem.smallImageView) {
            imageView.frame = [self getFrameInWindow:browseItem.smallImageView];
            [UIView animateWithDuration:0.5 animations:^{
                imageView.frame = bigRect;
            }];
        }else{
            self.view.alpha = 0.0;
            imageView.frame = bigRect;
            [UIView animateWithDuration:0.5 animations:^{
                self.view.alpha = 1.0;
            }];
        }
        
    }
    else
    {
        imageView.frame = bigRect;
    }
}

// 加载大图
- (void)loadBigImageWithBrowseItem:(MSSBrowseModel *)browseItem cell:(MSSBrowseCollectionViewCell *)cell rect:(CGRect)rect {
    UIImageView *imageView = cell.zoomScrollView.zoomImageView;
    // 加载圆圈显示
    [cell.loadingView startAnimation];
    // 默认为屏幕中间
    UIImage *imageDefault = nil;
    // 处理当前查看大图无默认图及转圈 提取bundle内菊花资源到Assets 设置默认小图
    if (browseItem.smallImageView == nil) {
        [imageView mss_setFrameInSuperViewCenterWithSize:CGSizeMake(LayoutW(80), LayoutH(80))];
        imageDefault = [TXCustomTools createImageWithColor:[TXCustomTools randomColor]];
    } else {
        [imageView mss_setFrameInSuperViewCenterWithSize:CGSizeMake(browseItem.smallImageView.width/2.0, browseItem.smallImageView.height/2.0)];
        imageDefault = browseItem.smallImageView.image;
    }
    
//    [imageView sd_setImageWithURL:[NSURL URLWithString:browseItem.bigImageUrl] placeholderImage:imageDefault completed:^(UIImage *image,
//    }];
    
    [imageView sd_small_setImageWithURL:[NSURL URLWithString:browseItem.bigImageUrl] placeholderImage:imageDefault completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
            // 关闭图片浏览view的时候，不需要继续执行小图加载大图动画
            if(self.collectionView.userInteractionEnabled)
            {
                // 停止加载
                [cell.loadingView stopAnimation];
                if(error)
                {
                    [self showBrowseRemindViewWithText:@"图片加载失败"];
                }
                else
                {
                    // 当大图frame为空时，需要大图加载完成后重新计算坐标
                    CGRect bigRect = [self getBigImageRectIfIsEmptyRect:rect bigImage:image];
                    // 图片加载成功
                    [UIView animateWithDuration:0.5 animations:^{
                        imageView.frame = bigRect;
                    }];
                }
            }
    }];
}

// 当大图frame为空时，需要大图加载完成后重新计算坐标
- (CGRect)getBigImageRectIfIsEmptyRect:(CGRect)rect bigImage:(UIImage *)bigImage {
    if(CGRectIsEmpty(rect))
    {
        return [bigImage mss_getBigImageRectSizeWithScreenWidth:self.screenWidth screenHeight:self.screenHeight];
    }
    return rect;
}

@end

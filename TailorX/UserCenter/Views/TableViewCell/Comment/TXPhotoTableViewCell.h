//
//  TXPhotoTableViewCell.h
//  TailorX
//
//  Created by 程荣刚 on 2017/6/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXPhotoTableViewCell;

@protocol TXPhotoTableViewCellDelegate <NSObject>

@required

/**
 * 查看图片
 */
- (void)uploadCommentPictureTabCell:(TXPhotoTableViewCell* )commentCell
            didSelectPictureOfindex:(NSInteger)index;

/**
 * 上传图片
 */
- (void)uploadCommentPicture:(TXPhotoTableViewCell *)commentCell;

/**
 删除对应位置的图片
 
 @param index 索引
 */
- (void)deletePictureWithIndex:(NSInteger)index;


@end

@interface TXPhotoTableViewCell : TXSeperateLineCell

/** 数据源*/
@property (nonatomic, strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *commentCollectionView;
/** 代理*/
@property (nonatomic, weak) id<TXPhotoTableViewCellDelegate> delegate;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

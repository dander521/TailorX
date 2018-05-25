//
//  TXStoreTabCell.m
//  TailorX
//
//  Created by Qian Shen on 4/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStoreTabCell.h"
#import "TXStoreColCell.h"

static NSString *cellID = @"TXStoreColCell";

@interface TXStoreTabCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end


@implementation TXStoreTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeInterface];
}

#pragma mark - init

- (void)initializeInterface {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowLayout;
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 10;
    //设置格子大小
    CGFloat w = 165;
    CGFloat h = 125;
    flowLayout.itemSize = CGSizeMake(w, h);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXStoreColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma - mark  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeTabCell:didSelectItemOfIndex:)]) {
        [self.delegate storeTabCell:self didSelectItemOfIndex:indexPath.row];
    }
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

@end

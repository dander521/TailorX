//
//  TXStarDesignerTabCell.m
//  TailorX
//
//  Created by Qian Shen on 4/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStarDesignerTabCell.h"
#import "TXDesignerItem.h"

static NSString *cellID = @"TXDesignerItem";

@interface TXStarDesignerTabCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation TXStarDesignerTabCell

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
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    //设置格子大小
    CGFloat w = 108;
    CGFloat h = 105;
    flowLayout.itemSize = CGSizeMake(w, h);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXDesignerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma - mark  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(starDesignerTabCell:didSelectItemOfIndex:)]) {
        [self.delegate starDesignerTabCell:self didSelectItemOfIndex:indexPath.row];
    }
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (IBAction)touchCheckAllBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(touchAllDesignerButton)]) {
        [self.delegate touchAllDesignerButton];
    }
}



@end

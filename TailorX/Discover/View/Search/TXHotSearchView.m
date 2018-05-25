//
//  TXHotSearchView.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXHotSearchView.h"
#import "TXHotSearchCollectionViewCell.h"

static NSString *cellID = @"TXHotSearchCollectionViewCell";

@interface TXHotSearchView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;

@end

@implementation TXHotSearchView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];

    //设置最小间距
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 20;
    //设置格子大小
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 90)/4 , 24);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    
    [self addSubview:self.collectionView];
    
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self).offset(30);
        make.right.mas_equalTo(self).offset(-30);
        make.bottom.mas_equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXHotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.tagLabel.text = self.dataSource[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemWithString:)]) {
        [self.delegate didSelectItemWithString:self.dataSource[indexPath.item]];
    }
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    TXHotSearchView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return headerView;
}

@end

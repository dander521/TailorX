//
//  TXDesingerInfoTabCell.m
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesingerInfoTabCell.h"
#import "TXArthorInfoItemCell.h"
#import "TXProductListCollectionViewCell.h"

static NSString *cellID = @"TXArthorInfoItemCell";
static NSString *cellProductID = @"TXProductListCollectionViewCell";


@interface TXDesingerInfoTabCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *designLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealLineLabel;
@property (nonatomic, strong) TXBlankView *blankView;


@end

@implementation TXDesingerInfoTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeInterface];
}

#pragma mark - init 

- (void)initializeInterface {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = flowLayout;
    //设置最小行距
    flowLayout.minimumLineSpacing = 8;
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 8;
    //设置组边界（格子的四周边界）
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    //设置格子大小
    CGFloat h = LayoutH(216);
    CGFloat w = (SCREEN_WIDTH - 32 - 10) / 2.0;
    flowLayout.itemSize = CGSizeMake(w, h);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerNib:[UINib nibWithNibName:cellProductID bundle:nil] forCellWithReuseIdentifier:cellProductID];
    self.cellType = TXDesingerInfoTabCellTypeDesign;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.cellType == TXDesingerInfoTabCellTypeDesign) {
        if (self.dataSource.count > 4) {
            return 4;
        } else {
            return self.dataSource.count;
        }
    } else {
        if (self.productDataSource.count > 4) {
            return 4;
        } else {
            return self.productDataSource.count;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellType == TXDesingerInfoTabCellTypeDesign) {
        TXArthorInfoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    } else {
        TXProductListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellProductID forIndexPath:indexPath];
        cell.model = self.productDataSource[indexPath.row];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(desingerInfoTabCell:didSelectOfIndex:type:)]) {
        [self.delegate desingerInfoTabCell:self didSelectOfIndex:indexPath.item type:self.cellType];
    }
}

#pragma mark - events

- (IBAction)clickAllBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(desingerInfoTabCell:clickAllBtn:type:)]) {
        [self.delegate desingerInfoTabCell:self clickAllBtn:sender type:self.cellType];
    }
}

- (IBAction)touchDesignButton:(id)sender {
    self.cellType = TXDesingerInfoTabCellTypeDesign;
    self.designLineLabel.hidden = false;
    self.dealLineLabel.hidden = true;
    [self.collectionView reloadData];
    
    if (self.dataSource.count == 0) {
        [self showBlankView];
    } else {
        [self removeBlankView];
    }
}

- (IBAction)touchDealButton:(id)sender {
    self.cellType = TXDesingerInfoTabCellTypeDeal;
    self.designLineLabel.hidden = true;
    self.dealLineLabel.hidden = false;
    [self.collectionView reloadData];
    
    if (self.productDataSource.count == 0) {
        [self showBlankView];
    } else {
        [self removeBlankView];
    }
}

- (void)showBlankView {
    [self addSubview:self.blankView];
}

- (void)removeBlankView {
    [self.blankView removeFromSuperview];
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count > 0) {
        for (UIView *subView in self.contentView.subviews) {
            subView.hidden = NO;
        }
    }else {
        for (UIView *subView in self.contentView.subviews) {
            subView.hidden = YES;
        }
    }
    [self.collectionView reloadData];
}

- (TXBlankView *)blankView {
    if (!_blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 72.5, self.bounds.size.width, self.bounds.size.height-82.5)];
        [_blankView createBlankViewWithImage:@"ic_main_default_noproduct" title:@"设计师暂无成交作品"];
    }
    _blankView.isFull = false;
    return _blankView;
}


@end

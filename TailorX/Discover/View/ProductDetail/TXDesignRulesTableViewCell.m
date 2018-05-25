//
//  TXDesignRulesTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignRulesTableViewCell.h"
#import "TXDesignRulesCollectionViewCell.h"

static NSString *cellID = @"TXDesignRulesCollectionViewCell";

@interface TXDesignRulesTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 瀑布流布局*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation TXDesignRulesTableViewCell

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXDesignRulesTableViewCell";
    TXDesignRulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2, 34);
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView.collectionViewLayout = self.flowLayout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRuleArray:(NSArray<RulesInfo *> *)ruleArray {
    _ruleArray = ruleArray;

    // 处理直接刷新界面卡顿
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ruleArray.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXDesignRulesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.row%2 != 0) {
        cell.contentView.backgroundColor = RGB(250, 250, 250);
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    cell.model = self.ruleArray[indexPath.item];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate


@end

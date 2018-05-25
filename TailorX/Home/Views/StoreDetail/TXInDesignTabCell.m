//
//  TXInDesignTabCell.m
//  TailorX
//
//  Created by Qian Shen on 10/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInDesignTabCell.h"
#import "XHStarRateView.h"
#import "TxDesignerCollectionCell.h"
#import "TXGetDesignerProductionModel.h"

static NSString *cellID = @"TxDesignerCollectionCell";

@interface TXInDesignTabCell ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *starBgView;
/** 五星*/
@property (nonatomic, strong) XHStarRateView *starView;

/** 设计师头像*/
@property (weak, nonatomic) IBOutlet UIImageView  *photoImgView;
/** 设计师名字*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** [设计师风格]*/
@property (weak, nonatomic) IBOutlet UILabel *stylesLabel;

@end

@implementation TXInDesignTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeInterface];
}

#pragma mark - init

- (void)initializeInterface {
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.userInteractionEnabled = NO;
    CGFloat h = (SCREEN_WIDTH - 32 - 3 * 7.5) / 4.0;
    [self.starBgView addSubview:self.starView];
    
    //初始化一个布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 7;
    //设置格子大小
    flowLayout.itemSize = CGSizeMake(h, h+LayoutH(24));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //初始化集合视图
    self.collectionView.collectionViewLayout = flowLayout;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(h+2+LayoutH(24)));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-16);
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
    }];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.dataSource = self;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource.count > 4) {
        return 4;
    } else {
        return self.dataSource.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TxDesignerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    TXGetDesignerProductionModel *model = self.dataSource[indexPath.row];
    [cell.productImageView sd_small_setImageWithURL:[NSURL URLWithString:model.productionImg] imageViewWidth:(SCREEN_WIDTH - 32 - 3 * 7.5) / 4.0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInDesignTabCell:ofIndex:atItem:)]) {
        [self.delegate didSelectedInDesignTabCell:self ofIndex:self.index atItem:indexPath.item];
    }
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count == 0) {
        self.topConstraint.constant = 0;
        self.collectionView.hidden = YES;
    }else {
        self.topConstraint.constant = 15;
        self.collectionView.hidden = NO;
    }
    [self.collectionView reloadData];
}

- (void)setModel:(TXGetStoreDesignerListModel *)model {
    _model = model;
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:model.photo] imageViewWidth:63 placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    self.nameLabel.text = model.name;
    self.stylesLabel.text = ![NSString isTextEmpty:model.goodStyle] ? model.goodStyle : @"";
    
    if  (model.goodStyle.length >= 5) {
        for(int i = 0; i < [model.goodStyle length]; i++)
        {
            NSString *tempStr = [model.goodStyle substringWithRange:NSMakeRange(i,1)];
            if ([tempStr isEqualToString:@"、"] && i == 4) {
                self.stylesLabel.text = [model.goodStyle substringToIndex:4];
            }else if ([tempStr isEqualToString:@"、"] && i == 0) {
                self.stylesLabel.text = [model.goodStyle substringWithRange:NSMakeRange(1, 4)];
            }
        }
    }
    self.starView.currentScore = model.score;
}

@end

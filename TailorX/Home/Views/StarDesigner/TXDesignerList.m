//
//  TXDesignerList.m
//  TailorX
//
//  Created by Qian Shen on 16/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDesignerList.h"
#import "TxDesignerCollectionCell.h"
#import "XHStarRateView.h"
#import "TXDesignerProductionModel.h"

#define kStr @"、"
static NSString *cellID = @"TxDesignerCollectionCell";

@interface TXDesignerList ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)UICollectionView   *collectionView;
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

@implementation TXDesignerList

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeInterface];
}

#pragma mark - init 

- (void)initializeInterface {
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.userInteractionEnabled = NO;
    [self.starBgView addSubview:self.starView];
    //初始化一个布局对象
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 7;
    CGFloat h = (SCREEN_WIDTH - 32 - 3 * 7.5) / 4.0;
    //设置格子大小
    flowLayout.itemSize = CGSizeMake(h, h+LayoutH(24));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(h+LayoutH(24)+2));
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
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TxDesignerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    TXDesignerProductionModel *model = self.dataSource[indexPath.row];
    [cell.productImageView sd_small_setImageWithURL:[NSURL URLWithString:model.productionImg] imageViewWidth:(SCREEN_WIDTH - 32 - 3 * 7.5) / 4.0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    return cell;
}

#pragma mark - UICollectionViewDelegate 

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDesignerList:ofIndex:)]) {
        [self.delegate didSelectedDesignerList:self ofIndex:indexPath.row];
    }
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
    if (_dataSource.count == 0) {
        self.collectionView.hidden = YES;
    }else {
        self.collectionView.hidden = NO;
    }
}

- (void)setModel:(TXFindStarDesignerModel *)model {
    _model = model;
    [self.photoImgView sd_small_setImageWithURL:[NSURL URLWithString:model.photo] imageViewWidth:63 placeholderImage:kDefaultUeserHeadImg];
    self.nameLabel.text = model.name;
    NSMutableString *styleStr = [NSMutableString string];
    for (NSString *style in model.styleArray) {
        if (![NSString isTextEmpty:style]) {
            [styleStr appendString:[NSString stringWithFormat:@"%@%@",style,kStr]];
        }
    }
    if (styleStr.length > 0) {
        self.stylesLabel.text = [styleStr substringToIndex:styleStr.length-1];
    }else{
        self.stylesLabel.text = @"没有哦！";
    }
    if  (styleStr.length >= 5) {
        NSString *tempStr = [styleStr substringWithRange:NSMakeRange(4,1)];
        if ([tempStr isEqualToString:@"、"]) {
            self.stylesLabel.text = [styleStr substringToIndex:4];
        }else {
            self.stylesLabel.text = [styleStr substringToIndex:5];
        }
    }
    self.starView.currentScore = model.score;
}

@end
















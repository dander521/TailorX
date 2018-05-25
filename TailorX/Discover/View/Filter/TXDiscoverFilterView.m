//
//  TXDiscoverFilterView.m
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXDiscoverFilterView.h"
#import "TXFilterColViewCell.h"
#import "TXSectionReusableView.h"
#import "TXFooterReusableView.h"

#define sexCount 6
#define styleCount 6
#define seasonCount 6
#define commonTagCount 6

static NSString *cellID = @"TXFilterColViewCell";


@interface TXDiscoverFilterView ()<UICollectionViewDelegate,UICollectionViewDataSource,TXSectionReusableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/** 按钮区域天剑阴影*/
@property (weak, nonatomic) IBOutlet UIView *sureBtnBgView;
/** 遮罩*/
@property (nonatomic, strong) UIView *bgView;
/** 可点击区域*/
@property (nonatomic, strong) UIView *clickView;
/** section图标*/
@property (nonatomic, strong) NSArray *icons;
/** 记录section是否选中*/
@property (nonatomic, strong) NSMutableArray *sectionState;

@end

@implementation TXDiscoverFilterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sureBtnBgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.sureBtnBgView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.sureBtnBgView.layer.shadowOpacity = 0.5;
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
}

#pragma mark - init

- (void)initializeDataSource {
    
    self.sectionState = [@[]mutableCopy];
    for (NSInteger i = 0; i < 4; i ++) {
        [self.sectionState addObject:[NSNumber numberWithBool:NO]];
    }
    self.icons = @[@"ic_main_gender_3.2.0",@"ic_main_style_3.2.0",@"ic_main_season_3.2.0",@"ic_main_preference_3.2.0"];
}


- (void)initializeInterface {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.headerReferenceSize = CGSizeMake(285, 52);
    flowLayout.footerReferenceSize = CGSizeMake(285, 16);
    //设置最小行距
    flowLayout.minimumLineSpacing = 7;
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 7;
    //设置格子大小
    CGFloat h = 45;
    CGFloat w = 85;
    flowLayout.itemSize = CGSizeMake(w, h);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 7, 0, 7);
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TXSectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"H"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TXFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"F"];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return (self.tagModels.systemTags.sex.count <= sexCount || [self.sectionState[0] boolValue]) ? self.tagModels.systemTags.sex.count : sexCount;
            break;
        case 1:
            return (self.tagModels.systemTags.style.count <= styleCount || [self.sectionState[1] boolValue]) ? self.tagModels.systemTags.style.count : styleCount;
            break;
        case 2:
            return (self.tagModels.systemTags.season.count <= seasonCount || [self.sectionState[2] boolValue]) ? self.tagModels.systemTags.season.count : seasonCount;
            break;
        case 3:
            return (self.tagModels.commonTags.count <= commonTagCount || [self.sectionState[3] boolValue]) ? self.tagModels.commonTags.count : commonTagCount;
            break;
        default:
            return 0;
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        TXSectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"H" forIndexPath:indexPath];
        headerView.section = indexPath.section;
        headerView.delegate = self;
        headerView.iconImgView.image = [UIImage imageNamed:self.icons[indexPath.section]];
        headerView.markImgView.image = [self.sectionState[indexPath.section] boolValue] == YES ? [UIImage imageNamed:@"ic_main_top_arrow"] : [UIImage imageNamed:@"ic_main_bottom_arrow"];
        if (indexPath.section == 0) {
            headerView.bgView.hidden = self.tagModels.systemTags.sex.count <= sexCount ? YES : NO;
            headerView.sectionTitleLabel.text = @"性别";
        }else if (indexPath.section == 1) {
            headerView.bgView.hidden = self.tagModels.systemTags.style.count <= styleCount ? YES : NO;
            headerView.sectionTitleLabel.text = @"款式";
        }else if (indexPath.section == 2) {
            headerView.bgView.hidden = self.tagModels.systemTags.season.count <= seasonCount ? YES : NO;
            headerView.sectionTitleLabel.text = @"适用季节";
        }else if (indexPath.section == 3) {
            headerView.bgView.hidden = self.tagModels.commonTags.count <= commonTagCount ? YES : NO;
            headerView.sectionTitleLabel.text = @"偏好风格";
        }
        return headerView;
    }else {
        TXFooterReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"F" forIndexPath:indexPath];
        footerView.hidden = indexPath.section == 3 ? YES : NO;
        return footerView;
    }
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXFilterColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model = self.tagModels.systemTags.sex[indexPath.row];
    }else if(indexPath.section == 1) {
        cell.model = self.tagModels.systemTags.style[indexPath.row];
    }else if(indexPath.section == 2) {
        cell.model = self.tagModels.systemTags.season[indexPath.row];
    }else if(indexPath.section == 3) {
        cell.model = self.tagModels.commonTags[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        for (NSInteger i = 0; i < [self.tagModels.systemTags.sex count]; i ++) {
            self.tagModels.systemTags.sex[i].isSelected = indexPath.row == i ? !self.tagModels.systemTags.sex[i].isSelected : NO;
        }
    }else if(indexPath.section == 1) {
        for (NSInteger i = 0; i < [self.tagModels.systemTags.style count]; i ++) {
            self.tagModels.systemTags.style[i].isSelected = indexPath.row == i ? !self.tagModels.systemTags.style[i].isSelected : NO;
        }
    }else if(indexPath.section == 2) {
        for (NSInteger i = 0; i < [self.tagModels.systemTags.season count]; i ++) {
            self.tagModels.systemTags.season[i].isSelected = indexPath.row == i ? !self.tagModels.systemTags.season[i].isSelected : NO;
        }
    }else if(indexPath.section == 3) {
        self.tagModels.commonTags[indexPath.row].isSelected = !self.tagModels.commonTags[indexPath.row].isSelected;
    }
    [collectionView reloadData];
}

#pragma mark - TXSectionReusableViewDelegate

- (void)sectionReusableView:(TXSectionReusableView *)reusableView clickofSection:(NSInteger)section {
    [self.sectionState replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:![self.sectionState[section] boolValue]]];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:section];
    if (section == 3) {
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }else {
        [self.collectionView reloadSections:indexSet];
    }
}

#pragma mark - setters

- (void)setTagModels:(TXFindAllTagsModel *)tagModels {
    _tagModels = tagModels;
    [self.collectionView reloadData];
}

#pragma mark - events

- (IBAction)clcikResetBtn:(UIButton *)sender {
    for (TagInfo *tag in self.tagModels.systemTags.sex) {
        tag.isSelected = NO;
    }
    for (TagInfo *tag in self.tagModels.systemTags.style) {
        tag.isSelected = NO;
    }
    for (TagInfo *tag in self.tagModels.systemTags.season) {
        tag.isSelected = NO;
    }
    for (TagInfo *tag in self.tagModels.commonTags) {
        tag.isSelected = NO;
    }
    [self.collectionView reloadData];
}

- (IBAction)clickSureBtn:(UIButton *)sender {
    NSMutableDictionary *tagDict = [@{}mutableCopy];
    for (TagInfo *tag in self.tagModels.systemTags.sex) {
        if (tag.isSelected) {
            [tagDict setValue:tag.ID forKey:@"sexTagId"];
        }
    }
    for (TagInfo *tag in self.tagModels.systemTags.style) {
        if (tag.isSelected) {
            [tagDict setValue:tag.ID forKey:@"styleTagId"];
        }
    }
    for (TagInfo *tag in self.tagModels.systemTags.season) {
        if (tag.isSelected) {
            [tagDict setValue:tag.ID forKey:@"seasonTagId"];
        }
    }
    NSMutableString *tempCommonTagIds = [NSMutableString string];
    for (TagInfo *tag in self.tagModels.commonTags) {
        if (tag.isSelected) {
            [tempCommonTagIds appendString:[NSString stringWithFormat:@"%@||",tag.ID]];
        }
    }
    [tagDict setValue:tempCommonTagIds forKey:@"tags"];
    if (self.sureBlock) {
        self.sureBlock(tagDict);
    }
    [self dismiss:0.35];
}

#pragma mark - methods

- (void)showWithSure:(SureBlock)sureBlock {
    [self show];
    self.sureBlock = sureBlock;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _bgView.alpha = 1;
    [window addSubview:_bgView];
    _clickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-285, SCREEN_HEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
    [_clickView addGestureRecognizer:tap];
    [window addSubview:_clickView];
    self.frame = CGRectMake(SCREEN_WIDTH, 0, 285, SCREEN_HEIGHT);
    [window addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH-285, 0, 285, SCREEN_HEIGHT);
    }];
}

- (void)dismissView {
    [self dismiss:0.35];
}

- (void)dismiss:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH, 0, 285, SCREEN_HEIGHT);
        _bgView.alpha = 0;
    }completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_clickView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end

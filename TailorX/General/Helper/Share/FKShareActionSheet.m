//
//  FKShareActionSheet.m
//  5KM
//
//  Created by haozhiyu on 2017/4/23.
//  Copyright © 2017年 UTSoft. All rights reserved.
//

#import "FKShareActionSheet.h"
#import "FKActionSheetItme.h"
#import "UIColor+CMKit.h"

@interface FKShareActionSheet () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> {
    FKShareActionSheetClickBlock block[4];
    NSInteger index;
}

/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *images;

/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *titles;

/** 占位block */
@property (readonly, copy) FKShareActionSheetClickBlock empty;
@property (nonatomic, strong) UICollectionView *collect;

/** 出现的点击按钮的个数 */
@property (nonatomic, assign) NSInteger actionCount;

@end

@implementation FKShareActionSheet

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setArgument];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setArgument];
    }
    return self;
}

- (void)setArgument {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    [self addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)addActionWithImage:(UIImage *)image title:(NSString *)title clickBlock:(FKShareActionSheetClickBlock)clickBlock {
    if (index<4) {
        if (clickBlock) {
            block[index] = [clickBlock copy];
        } else {
            block[index] = self.empty;
        }
        
        if (image) {
            [self.images addObject:image];
        } else {
            [self.images addObject:@""];
        }
        
        if (title.length > 0) {
            [self.titles addObject:title];
        } else {
            [self.titles addObject:@""];
        }
        
        index++;
    }
}

- (void)show {
    self.actionCount = self.titles.count;
    
    if (!self.actionCount) {
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50+30);
    
    self.collect = [[UICollectionView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT, SCREEN_WIDTH-20, 160) collectionViewLayout:layout];
    [self.collect registerClass:[FKActionSheetItme class] forCellWithReuseIdentifier:@"FKShareActionSheet"];
    self.collect.backgroundColor = [UIColor whiteColor];
    self.collect.layer.cornerRadius = 10.f;
    self.collect.layer.masksToBounds = YES;
    self.collect.delegate = self;
    self.collect.dataSource = self;
    [self addSubview:self.collect];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(10, CGRectGetMaxY(self.collect.frame)+10, SCREEN_WIDTH-20, 49);
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.layer.cornerRadius = 10.f;
    cancel.layer.masksToBounds = YES;
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorForColorString:@"#393939"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    
    [UIView animateWithDuration:.2 animations:^{
        self.collect.frame = CGRectMake(10, SCREEN_HEIGHT-160-10-49-10, SCREEN_WIDTH-20, 160);
        cancel.frame = CGRectMake(10, SCREEN_HEIGHT-10-49, SCREEN_WIDTH-20, 49);
    }];
}

- (void)cancelAction {
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actionCount;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self cancelAction];
    
    FKShareActionSheetClickBlock blockItem = block[indexPath.item];
    
    if (blockItem) {
        blockItem();
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FKActionSheetItme *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FKShareActionSheet" forIndexPath:indexPath];
    cell.title = self.titles[indexPath.item];
    if ([self.images[indexPath.item] isKindOfClass:[UIImage class]]) {
        cell.image = self.images[indexPath.item];
    } else {
        cell.image = nil;
    }
    [cell setNeedsLayout];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat offset = (SCREEN_WIDTH-20-self.actionCount*50-1)/(self.actionCount+1);
    return UIEdgeInsetsMake(40, offset, 40, offset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat offset = (SCREEN_WIDTH-20-self.actionCount*50-1)/(self.actionCount+1);
    return offset;
}

- (FKShareActionSheetClickBlock)empty {
    FKShareActionSheetClickBlock emptyBlock = ^{
        NSLog(@"没有实现block。。。");
    };
    return [emptyBlock copy];
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

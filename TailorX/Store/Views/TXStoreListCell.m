//
//  TXStoreListCell.m
//  TailorX
//
//  Created by 温强 on 2017/4/1.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXStoreListCell.h"
#import "WYKit.h"
#import "UIImageView+YMWebCache.h"

@interface TXStoreListCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *bgView;
@property (weak, nonatomic) IBOutlet UIView *iconsBgView;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *iconImageViewAry;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation TXStoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setUpBgViewStyle];
}
- (void)setModel:(TXStroeListModel *)model {

    _model = model;
    self.titleLabel.text = model.name;
    self.addressLabel.text = model.address;
    [self.facadeImageView sd_small_setImageWithURL:[NSURL URLWithString:model.coverImage] imageViewWidth:0 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
    if (model.status == 0) {
        [self.statusBtn setBackgroundImage:[UIImage imageNamed:@"in_decoration"] forState:UIControlStateNormal];
        if ([NSString isTextEmpty:model.coverImage]) {
            self.facadeImageView.image = [UIImage imageNamed:@"img_stores"];
        }
    } else {
        [self.statusBtn setBackgroundImage:[UIImage imageNamed:@"in_business"] forState:UIControlStateNormal];
    }
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2fkm",model.distance / 1000.0];
   
    [self setUpDesignerIcons:model.designerPhotoList];
}


- (void)setUpBgViewStyle {
    
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.bgView.layer.shadowOpacity = 0.5;
}


- (void)setUpDesignerIcons:(NSArray *)storeListDataAry {
    // 移除所有头像，防止重复
    [self.iconsBgView removeAllSubViews];
    // 将可变数组中的imageView的image置空
    for (UIImageView *imageView in self.iconImageViewAry) {
        imageView.image = nil;
    }
    // 清空缓存头像（imageView）的数组
    [self.iconImageViewAry removeAllObjects];
    // 头像宽度
    float iconImageViewW = 30;
    float widthBg = self.iconsBgView.frame.size.width;
    
    NSInteger iconsNum = self.model.designerCount > 4 ? 4 : self.model.designerPhotoList.count;
    
    for (int i = 0; i < iconsNum; i ++) {
            
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.frame = CGRectMake(widthBg - (iconImageViewW + i*iconImageViewW*0.6), 0, iconImageViewW, iconImageViewW);
        bgView.layer.borderWidth = 1.0;
        bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        bgView.layer.cornerRadius = 15.0;
        bgView.layer.masksToBounds = YES;
            
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.layer.cornerRadius = 12.5;
        iconImageView.layer.masksToBounds = YES;
        iconImageView.image = [UIImage imageNamed:@"ic_main_username_zhan"];
        [bgView addSubview:iconImageView];
            
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(26, 26));
        }];
            
        [self.iconsBgView addSubview:bgView];
        [self.iconImageViewAry addObject:iconImageView];
    }
    
    for (int i = 0; i < self.model.designerPhotoList.count; i ++) {
        // 最多4个imageView，防止数据给4个以上错误
        if (i == 4) {
            break;
        }
        NSURL *imageUrl = [NSURL URLWithString:self.model.designerPhotoList[i]];
        [self.iconImageViewAry[i] sd_small_setImageWithURL:imageUrl
                                            imageViewWidth:26
                                          placeholderImage:[UIImage imageNamed:@"ic_main_username_zhan"]];
    }
    
    NSInteger num = self.model.designerCount - 4;
    UILabel * overplusNumLab = [UILabel labelWithFont:10
                                            textColor:RGB(102, 102, 102)
                                            superView:self.iconsBgView];
    overplusNumLab.text = [NSString stringWithFormat:@"+%zd",num];
        
    overplusNumLab.frame = CGRectMake(widthBg - 3.4 * iconImageViewW, - 5, 40, 40);
    if (num < 1) {
        overplusNumLab.hidden = YES;
    }
}

- (NSMutableArray *)iconImageViewAry {
    
    if (_iconImageViewAry == nil) {
        _iconImageViewAry = [NSMutableArray array];
    }
    
    return _iconImageViewAry;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

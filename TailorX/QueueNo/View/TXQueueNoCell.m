//
//  TXQueueNoCell.m
//  TailorX
//
//  Created by liuyanming on 2017/3/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXQueueNoCell.h"
#import "TXFontTool.h"
#import "TXQueueNoModel.h"

static CGFloat margin = 15.0;
static CGFloat numLabelWH = 126*0.5;
static CGFloat btnW = 65;
static CGFloat btnH = 26;

@interface TXQueueNoCell ()
/** 转让 */
@property (strong, nonatomic)  ThemeButton *transBtn;
/** 购买 */
@property (strong, nonatomic)  ThemeButton *payBtn;
/** 取消 */
@property (strong, nonatomic)  UIButton *cancelBtn;

/** 号码 */
@property (strong, nonatomic)  ThemeLabel *numLabel;
/** 品类 */
@property (strong, nonatomic)  UILabel *titleLabel;
/** 价格 */
@property (strong, nonatomic)  UILabel *priceLabel;
/** 状态 */
@property (strong, nonatomic)  UILabel *stateLabel;

@property (strong, nonatomic)    UIImageView *avatar;

@property (strong, nonatomic)    UIImageView *avatarMask;

@end

@implementation TXQueueNoCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _payBtn.layer.borderWidth = 0.5;
    _payBtn.layer.cornerRadius = 2;
    _payBtn.layer.masksToBounds = true;

    _transBtn.layer.borderWidth = 0.5;
    _transBtn.layer.cornerRadius = 2;
    _transBtn.layer.masksToBounds = true;
}

- (void)setData:(TXQueueNoModel *)data {
    _data = data;
    
    NSString *num = [NSString stringWithFormat:@"%ld号", (long)data.sortNo];
    _numLabel.attributedText = [TXFontTool addFontAttribute:num minFont:MinFont number:1];

    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", data.amount];
    
    // saleStatus-状态，0未出让，1出让中，2交易中
    switch (data.saleStatus) {
        case 0:{
            _stateLabel.text = @"未出让";
        }
            break;
        case 1:{
            _stateLabel.text = @"出让中";
        }
            break;
        case 2:{
            _stateLabel.text = @"交易中";
            break;
        }
        default:
            break;
    }
    _transBtn.hidden = YES;
    _cancelBtn.hidden = YES;
    _payBtn.hidden = YES;
    
    switch (self.cellType) {
        case TXQueueNoCellTypeMyNum: // 我的排号
        {
            _titleLabel.text = [NSString stringWithFormat:@"定制标签：%@", data.categoryName];
            self.avatarMask.hidden = true;
            if (data.saleStatus == 0) {
                _transBtn.hidden = NO;
                
                _transBtn.layer.borderColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"].CGColor;
                [_transBtn setTitleColor:[[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"] forState:UIControlStateNormal];
            }else if (data.saleStatus == 1) {
                _cancelBtn.hidden = NO;
            }
            else if (data.saleStatus == 2) {
                
            }
            break;
        }
        case TXQueueNoCellTypeTransNum: // 排号交易
        {
            _payBtn.hidden = NO;
            _titleLabel.text = [NSString stringWithFormat:@"排号持有者：%@", data.userName];
            // ownerType-拥有者归类，0自己，1他人
            if (data.ownerType == 0) {
                self.numLabel.textColor = [UIColor whiteColor];
                [self.avatar sd_small_setImageWithURL:[NSURL URLWithString:GetUserInfo.photo] imageViewWidth:0 placeholderImage:kDefaultUeserHeadImg];
                self.avatarMask.hidden = false;
                _payBtn.hidden = YES;
                _titleLabel.text = [NSString stringWithFormat:@"定制标签：%@", data.categoryName];
            }else {
                self.numLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
                self.avatar.image = nil;
                self.avatarMask.hidden = true;
                _titleLabel.text = [NSString stringWithFormat:@"排号持有者：%@", data.userName];
            }
            if (data.saleStatus == 1) {
                _payBtn.enabled = YES;
                _payBtn.userInteractionEnabled = YES;
                _payBtn.layer.borderColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"].CGColor;
                [_payBtn setTitleColor:[[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"] forState:UIControlStateNormal];
            }else {
                _payBtn.userInteractionEnabled = NO;
                _payBtn.enabled = NO;
                _payBtn.layer.borderColor = RGB(204, 204, 204).CGColor;
                [_payBtn setTitleColor:RGB(204, 204, 204) forState:UIControlStateNormal];
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - init

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"queueNoCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化子控件
        [self setUpAllChildView];
    }
    return self;
}

#pragma mark - events

- (void)cellBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(cellOfButtonClick:senderType:)]) {
        [self.delegate cellOfButtonClick:self senderType:btn.tag];
    }
}

/**
 * 初始化子控件
 */
- (void)setUpAllChildView {
    // 号
    ThemeLabel *numLabel = [[ThemeLabel alloc] init];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.cloName = @"theme_color";
    numLabel.font = MaxFont;
    numLabel.attributedText = [TXFontTool addFontAttribute:@"0号" minFont:MinFont number:1];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numLabel];
    [numLabel circleLabelWithWithRoundedRect:CGRectMake(0, 0, numLabelWH, numLabelWH) cornerRadius:numLabelWH*0.5];
    self.numLabel = numLabel;
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(margin);
        make.left.equalTo(self.contentView).offset(margin);
        make.size.mas_equalTo(CGSizeMake(numLabelWH, numLabelWH));
    }];
    //头像
    UIImageView *avatar = [[UIImageView alloc] init];
    avatar.backgroundColor = LightColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, numLabelWH, numLabelWH) cornerRadius:numLabelWH*0.5];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    avatar.layer.mask = maskLayer;
    self.avatar = avatar;
    [self.contentView insertSubview:self.avatar belowSubview:self.numLabel];
    
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(margin);
        make.left.equalTo(self.contentView).offset(margin);
        make.size.mas_equalTo(CGSizeMake(numLabelWH, numLabelWH));
    }];
    //头像遮罩
    UIImageView *maskAvatar = [[UIImageView alloc] init];
    maskAvatar.backgroundColor = RGBA(0, 0, 0, 0.4);
    UIBezierPath *maskAvatarPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, numLabelWH, numLabelWH) cornerRadius:numLabelWH*0.5];
    CAShapeLayer *maskAvatarLayer = [[CAShapeLayer alloc] init];
    maskAvatarLayer.frame = self.bounds;
    maskAvatarLayer.path = maskAvatarPath.CGPath;
    maskAvatar.layer.mask = maskAvatarLayer;
    self.avatarMask = maskAvatar;
    [self.contentView insertSubview:self.avatarMask belowSubview:self.numLabel];
    
    [maskAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(margin);
        make.left.equalTo(self.contentView).offset(margin);
        make.size.mas_equalTo(CGSizeMake(numLabelWH, numLabelWH));
    }];
    // 状态
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.textColor = StateTextColor;
    stateLabel.text = @"出让中";
    stateLabel.font = FONT(13);
    stateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:stateLabel];
    self.stateLabel = stateLabel;
    
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(margin+2.5);
        make.right.equalTo(self.contentView).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(78, 24));
    }];
    // 品类
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TitleTextColor;
    titleLabel.text = @"定制标签：西装";
    titleLabel.font = FONT(14);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(margin+2.5);
        make.left.equalTo(numLabel.mas_right).offset(margin);
        make.height.mas_offset(24);
        make.right.equalTo(self.contentView).offset(-margin-50);
    }];
    // 价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = DefaultBlackColor;
    priceLabel.text = @"￥12.33";
    priceLabel.font = FONT(16);
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.5);
        make.left.equalTo(titleLabel);
        make.height.mas_offset(24);
        make.right.equalTo(self.contentView).offset(-margin-50);
    }];
    // 转让按钮
    self.transBtn =  [TailorxFactory setBorderThemeBtnWithTitle:@"出让"];
    self.transBtn.titleLabel.font = LayoutF(12);
    self.transBtn.tag = TXQueueNoCellBtnTypeTrans;
    self.transBtn.layer.borderWidth = 0.5;
    self.transBtn.layer.cornerRadius = 2;
    [self.transBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.transBtn];
    
    [self.transBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-margin-10);
        make.right.equalTo(self.contentView).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    // 购买按钮
    self.payBtn =  [TailorxFactory setBorderThemeBtnWithTitle:@"购买"];
    self.payBtn.titleLabel.font = LayoutF(12);
    self.payBtn.tag = TXQueueNoCellBtnTypepay;
    self.payBtn.layer.borderWidth = 0.5;
    self.payBtn.layer.cornerRadius = 2;
    [self.payBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.payBtn];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-margin-10);
        make.right.equalTo(self.contentView).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    // 取消按钮
    self.cancelBtn = [self creatCellBtnWithTitle:@"取消" titleColor:DefaultBlackColor btnType:TXQueueNoCellBtnTypeCancel];
    [self.contentView addSubview:self.cancelBtn];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-margin-10);
        make.right.equalTo(self.contentView).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    // line
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LightColor;
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.height.mas_offset(10);
        make.right.equalTo(self.contentView);
    }];
}

/**
 * 创建button
 */
- (UIButton *)creatCellBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor btnType:(TXQueueNoCellBtnType)btnType {
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [cancelBtn setTitle:title forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    cancelBtn.tag = btnType;
    cancelBtn.layer.borderColor = titleColor.CGColor;
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.cornerRadius = 2;
    [cancelBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return  cancelBtn;
}

@end

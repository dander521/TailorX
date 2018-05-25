//
//  TXProductCommentTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductCommentTableViewCell.h"
#import "XHStarRateView.h"

@interface TXProductCommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *summaryBgView;
@property (weak, nonatomic) IBOutlet UIView *designerBgView;
@property (weak, nonatomic) IBOutlet UIView *factoryBgView;

/**  */
@property (nonatomic, strong) XHStarRateView *summaryStarView;
/**  */
@property (nonatomic, strong) XHStarRateView *designerStarView;
/**  */
@property (nonatomic, strong) XHStarRateView *factoryStarView;

@end

@implementation TXProductCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (!_summaryStarView) {
        _summaryStarView = [[XHStarRateView alloc] initWithFrame:self.summaryBgView.bounds];
        _summaryStarView.isAnimation = false;
        _summaryStarView.rateStyle = WholeStar;
        _summaryStarView.currentScore = 5.0;
        _summaryStarView.userInteractionEnabled = false;
        [self.summaryBgView addSubview:_summaryStarView];
    }
    
    if (!_designerStarView) {
        _designerStarView = [[XHStarRateView alloc] initWithFrame:self.designerBgView.bounds];
        _designerStarView.isAnimation = false;
        _designerStarView.rateStyle = WholeStar;
        _designerStarView.currentScore = 5.0;
        _designerStarView.userInteractionEnabled = false;
        [self.designerBgView addSubview:_designerStarView];
    }
    
    if (!_factoryStarView) {
        _factoryStarView = [[XHStarRateView alloc] initWithFrame:self.factoryBgView.bounds];
        _factoryStarView.isAnimation = false;
        _factoryStarView.rateStyle = WholeStar;
        _factoryStarView.currentScore = 5.0;
        _factoryStarView.userInteractionEnabled = false;
        [self.factoryBgView addSubview:_factoryStarView];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TXProductDetailModel *)model {
    _model = model;
    
    self.contentLabel.text = model.customerEvaluate;
    
    self.summaryStarView.currentScore = [model.overallScore floatValue];
    self.designerStarView.currentScore = [model.designerScore floatValue];
    self.factoryStarView.currentScore = [model.factoryScore floatValue];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXProductCommentTableViewCell";
    TXProductCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

@end

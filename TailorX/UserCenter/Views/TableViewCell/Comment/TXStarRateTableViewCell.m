//
//  TXStarRateTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXStarRateTableViewCell.h"

@implementation TXStarRateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_starView) {
        _starView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 188, 20)];
        _starView.isAnimation = false;
        _starView.rateStyle = WholeStar;
        _starView.delegate = self;
        _starView.currentScore = 5.0;
        [self.ratingView addSubview:_starView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore {
    if ([self.delegate respondsToSelector:@selector(selectRatingView:score:)]) {
        [self.delegate selectRatingView:starRateView score:currentScore];
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXStarRateTableViewCell";
    TXStarRateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TXStarRateTableViewCell class]) owner:self options:nil] lastObject];
        
    }
    
    return cell;
}

- (void)setScoreSelected:(CGFloat)scoreSelected {
    _scoreSelected = scoreSelected;
    self.starView.currentScore = scoreSelected;
    
    if (scoreSelected == 1) {
        self.commentStatusLabel.text = @"极差";
    } else if (scoreSelected == 2) {
        self.commentStatusLabel.text = @"差";
    } else if (scoreSelected == 3) {
        self.commentStatusLabel.text = @"一般";
    } else if (scoreSelected == 4) {
        self.commentStatusLabel.text = @"良";
    } else {
        self.commentStatusLabel.text = @"非常好";
    }
}


@end

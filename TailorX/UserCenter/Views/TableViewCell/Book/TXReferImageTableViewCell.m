//
//  TXReferImageTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXReferImageTableViewCell.h"

@interface TXReferImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;


@end

@implementation TXReferImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXReferImageTableViewCell";
    TXReferImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (void)setAppoinmentModel:(TXAppointmentDetailModel *)appoinmentModel {
    _appoinmentModel = appoinmentModel;
    if (![NSString isTextEmpty:appoinmentModel.informationNo] && [appoinmentModel.informationNo integerValue] !=0) {
        self.firstImageView.isInformation = true;
        self.firstImageView.inforNoLabel.text = appoinmentModel.informationNo;
    } else {
        self.firstImageView.isInformation = false;
    }
    
    self.secondImageView.isInformation = false;
    self.thirdImageView.isInformation = false;
    
    NSMutableArray *pictureList = [@[]mutableCopy];
    
    NSArray *tempPictureList = [appoinmentModel.pictures componentsSeparatedByString:@";"];
    for (NSString *str in tempPictureList) {
        if (![NSString isTextEmpty:str]) {
            [pictureList addObject:str];
        }
    }
    if (pictureList.count == 1) {
        self.secondImageView.hidden = true;
        self.thirdImageView.hidden = true;
    } else if (pictureList.count == 2) {
        self.thirdImageView.hidden = true;
    }
    for (int i = 0; i < pictureList.count; i++) {
        if (i == 0) {
            [self.firstImageView.referImageView sd_small_setImageWithURL:[NSURL URLWithString:pictureList[i]] imageViewWidth:(SCREEN_WIDTH-kTopHeight)/3 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        } else if (i == 1) {
            [self.secondImageView.referImageView sd_small_setImageWithURL:[NSURL URLWithString:pictureList[i]] imageViewWidth:(SCREEN_WIDTH-kTopHeight)/3 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        } else {
            [self.thirdImageView.referImageView sd_small_setImageWithURL:[NSURL URLWithString:pictureList[i]] imageViewWidth:(SCREEN_WIDTH-kTopHeight)/3 placeholderImage:[TXCustomTools createImageWithColor:[TXCustomTools randomColor]]];
        }
    }
}

- (TXAppointmentReferView *)firstImageView {
    if (!_firstImageView) {
        _firstImageView = [TXAppointmentReferView setUpAppointmentReferView];
        _firstImageView.frame = self.firstView.bounds;
        _firstImageView.tag = 1000;
        [self addImageViewGestureRecognizerWithImageView:_firstImageView];
        [self.firstView addSubview:_firstImageView];
    }
    return _firstImageView;
}

- (TXAppointmentReferView *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [TXAppointmentReferView setUpAppointmentReferView];
        _secondImageView.frame = self.secondView.bounds;
        _secondImageView.tag = 1001;
        [self addImageViewGestureRecognizerWithImageView:_secondImageView];
        [self.secondView addSubview:_secondImageView];
    }
    return _secondImageView;
}

- (TXAppointmentReferView *)thirdImageView {
    if (!_thirdImageView) {
        _thirdImageView = [TXAppointmentReferView setUpAppointmentReferView];
        _thirdImageView.frame = self.thirdView.bounds;
        _thirdImageView.tag = 1002;
        [self addImageViewGestureRecognizerWithImageView:_thirdImageView];
        [self.thirdView addSubview:_thirdImageView];
    }
    return _thirdImageView;
}

- (void)addImageViewGestureRecognizerWithImageView:(TXAppointmentReferView *)imageView {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    gesture.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:gesture];
}

- (void)tapImageView:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(tapImageViewWithIndex:)]) {
        [self.delegate tapImageViewWithIndex:recognizer.view.tag-1000];
    }
}

@end

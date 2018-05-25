//
//  TXReSuccessCell.m
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXReSuccessCell.h"

@interface TXReSuccessCell ()

/** 门店文案*/
@property (weak, nonatomic) IBOutlet UILabel *storeTitleLabel;
/** 门店名称*/
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
/** 设计师名字*/
@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;
/** 时尚标签*/
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
/** 定金*/
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
/** 设计师那一行*/
@property (weak, nonatomic) IBOutlet UIView *designerBgView;
/** 标签哪一行*/
@property (weak, nonatomic) IBOutlet UIView *tagBgView;
/** *请您稍作休息，设计师将尽快与您取得联系*/
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation TXReSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(TXCustomSuccessInfoModel *)model {
    _model = model;
    
    self.depositLabel.text = model.depositStr;
    
    if ([NSString isTextEmpty:model.designerName]) {
        self.designerBgView.hidden = YES;
    }else {
        self.designerNameLabel.text = model.designerName;
    }
    if ([NSString isTextEmpty:model.tags]) {
        self.tagBgView.hidden = YES;
    }else {
        self.tagsLabel.text = model.tags;
    }
    self.storeNameLabel.text = [NSString isTextEmpty:model.storeName] ? @"" : model.storeName;
    self.storeTitleLabel.text = model.customType ? @"预约门店" : @"所在门店";
    self.hintLabel.hidden = !model.customType;
}

@end

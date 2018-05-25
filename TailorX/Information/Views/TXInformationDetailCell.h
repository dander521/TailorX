//
//  TXInformationDetailCell.h
//  TailorX
//
//  Created by 温强 on 2017/4/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXInformationDetailDesListModel.h"

@protocol TXInformationOrderDelegate <NSObject>

@optional
-(void)orderButtonActionDelegate:(NSDictionary *)info;
-(void)browseBigImageWithIndex:(NSInteger)index;

@end

@interface TXInformationDetailCell : UITableViewCell

@property (nonatomic, strong) TXInformationDetailDesListModel *model;
@property (weak, nonatomic)id <TXInformationOrderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *infoPicImageView;
/** 当前大图的下标*/
@property (nonatomic, assign) NSInteger index;

@end

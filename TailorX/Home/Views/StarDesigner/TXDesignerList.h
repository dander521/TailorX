//
//  TXDesignerList.h
//  TailorX
//
//  Created by Qian Shen on 16/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXFindStarDesignerModel.h"
@class TXDesignerList;

@protocol TXDesignerListDelegate <NSObject>

@required

- (void)didSelectedDesignerList:(TXDesignerList *)designerList ofIndex:(NSInteger)index;

@end

@interface TXDesignerList : UITableViewCell

/** 底部分割线*/
@property (weak, nonatomic) IBOutlet UIView *botoomView;
/** 数据源*/
@property (nonatomic, strong) NSArray *dataSource;
/** 模型*/
@property (nonatomic, strong) TXFindStarDesignerModel *model;
/** 下标*/
@property (nonatomic, assign) NSInteger index;

/** 代理*/
@property (nonatomic, weak) id<TXDesignerListDelegate> delegate;


@end

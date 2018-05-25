//
//  TXHotSearchView.h
//  TailorX
//
//  Created by 程荣刚 on 2017/12/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXHotSearchViewDelegate <NSObject>

- (void)didSelectItemWithString:(NSString *)searchString;

@end

@interface TXHotSearchView : UIView

@property (nonatomic, weak) id <TXHotSearchViewDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;


/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end

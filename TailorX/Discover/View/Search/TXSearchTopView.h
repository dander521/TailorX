//
//  TXSearchTopView.h
//  TailorX
//
//  Created by 程荣刚 on 2017/12/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TXSearchTopViewType) {
    TXSearchTopViewTypeOrigin,
    TXSearchTopViewTypeSearch
};

@protocol TXSearchTopViewDelegate <NSObject>

- (void)touchCancelButton;

@end

@interface TXSearchTopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic, assign) TXSearchTopViewType viewType;
@property (nonatomic, weak) id <TXSearchTopViewDelegate> delegate;
/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end

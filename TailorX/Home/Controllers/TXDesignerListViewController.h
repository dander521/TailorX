//
//  TXDesignerListViewController.h
//  TailorX
//
//  Created by 程荣刚 on 2017/8/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXDesignerListTableViewCell.h"
#import "ZJScrollPageViewDelegate.h"
#import "TXDesignerDetailController.h"

@interface TXDesignerListViewController : UIViewController <ZJScrollPageViewChildVcDelegate>

/** 设计师排序方式 */
@property (nonatomic, assign) TXDesignerOrderType designerType;
/** <#description#> */
@property (nonatomic, assign) BOOL isSelect;

@end

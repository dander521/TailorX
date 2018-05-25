//
//  TXReplaceImageViewController.h
//  TailorX
//
//  Created by 程荣刚 on 2017/12/13.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBodyDataModel.h"

@interface TXReplaceImageViewController : UIViewController

/** <#description#> */
@property (nonatomic, strong) TXBodyDataModel *model;
/** <#description#> */
@property (nonatomic, assign) NSInteger index;
/** <#description#> */
@property (nonatomic, strong) NSString *title;

@end

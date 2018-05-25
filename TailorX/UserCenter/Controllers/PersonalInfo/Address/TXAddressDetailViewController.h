//
//  TXAddressDetailViewController.h
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXAddressModel.h"

@interface TXAddressDetailViewController : UIViewController

/** 是否首次创建地址 */
@property (nonatomic, assign) BOOL isFirstAddAddress;
/** 是否为编辑地址 */
@property (nonatomic, assign) BOOL isEdit;
/** 需要编辑的地址对象 */
@property (nonatomic, strong) TXAddressModel *address;

@end

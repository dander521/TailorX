//
//  TXPhoneBingView.h
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXPhoneBingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneStatusLabel;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end

//
//  TXProductionListViewController.h
//  TailorX
//
//  Created by 程荣刚 on 2017/11/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXProductionListViewController : UIViewController <ZJScrollPageViewChildVcDelegate>

/** 发现id */
@property (nonatomic, strong) NSString *pictureId;
@property (nonatomic, strong) NSString *designerId;
@property (nonatomic, assign) BOOL isCollection;

@end

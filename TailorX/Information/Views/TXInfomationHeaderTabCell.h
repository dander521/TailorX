//
//  TXInfomationHeaderTabCell.h
//  TailorX
//
//  Created by Qian Shen on 27/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXInformationDetailModel.h"
#import "TXFindPictureDetailModel.h"



@interface TXInfomationHeaderTabCell : UITableViewCell

/** 资讯详情 */
@property (nonatomic, strong) TXInformationDetailModel *informationDetailModel;
/** 发现详情 */
@property (nonatomic, strong) TXFindPictureDetailModel *pictureDetailModel;
/** 分割线 */
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@interface TagsCommonInfo : NSObject

@property (nonatomic, assign) NSInteger author;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger delFlag;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) NSInteger type;

@end







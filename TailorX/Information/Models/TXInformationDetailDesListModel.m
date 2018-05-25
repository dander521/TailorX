//
//  TXInformationDetailDesListModel.m
//  TailorX
//
//  Created by 温强 on 2017/4/7.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXInformationDetailDesListModel.h"

@implementation TXInformationDetailDesListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"des" : @"description",
             @"ID" : @"id",};
}
@end

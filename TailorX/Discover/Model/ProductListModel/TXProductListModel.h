//
//  TXProductListModel.h
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXProductListModel : NSObject

/** <#description#> */
@property (nonatomic, assign) float headPicHeight;
/** <#description#> */
@property (nonatomic, assign) float headPicWidth;
/** <#description#> */
@property (nonatomic, strong) NSString *ID;
/** <#description#> */
@property (nonatomic, strong) NSString *price;
/** <#description#> */
@property (nonatomic, strong) NSString *workHeadPicture;
/** <#description#> */
@property (nonatomic, strong) NSString *title;

@end

@interface TXProductListCollectionModel : NSObject

@property (nonatomic, strong) NSMutableArray <TXProductListModel*> *data;

@end

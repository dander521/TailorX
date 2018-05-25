//
//  TXFindAllTagsModel.h
//  TailorX
//
//  Created by Qian Shen on 18/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagInfo : NSObject

@property (nonatomic, assign) NSInteger author;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger delFlag;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface SystemTag : NSObject

@property (nonatomic, strong) NSArray<TagInfo*> *season;
@property (nonatomic, strong) NSArray<TagInfo*> *sex;
@property (nonatomic, strong) NSArray<TagInfo*> *style;

@end

@interface TXFindAllTagsModel : NSObject

@property (nonatomic, strong) NSArray<TagInfo*> *commonTags;
@property (nonatomic, strong) SystemTag *systemTags;

@end

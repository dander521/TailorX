//
//  PickerCell.m
//  DatePopView
//
//  Created by wangtian on 16/4/20.
//  Copyright © 2016年 maliang. All rights reserved.
//

#import "LocationPickerCell.h"

@implementation LocationPickerCell

- (instancetype)init
{
    if (self == [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/3, 50);
        
        self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width/3, 40)];
        self.cellLabel.font = [UIFont systemFontOfSize:15];
        self.cellLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.cellLabel];
        
        self.cellSeparate = [[UIView alloc] initWithFrame:CGRectMake(5, 59, [UIScreen mainScreen].bounds.size.width/3, 1)];
        [self addSubview:self.cellSeparate];
    }
    
    return self;
}


@end

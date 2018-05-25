//
//  LocationObject.m
//  CustomLocationPicker
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 yuantuan. All rights reserved.
//

#import "LocationObject.h"


@implementation LocationObject

+ (LocationObject *)configObject
{
    LocationObject *object = [[LocationObject alloc] init];
    
    object.dataArray = [object configLocationDataWithDataSource:object.dataSource];
    
    return object;
}

- (NSArray *)configLocationDataWithDataSource:(NSString *)dataSource
{
    NSArray *array = nil;
    NSData *dataJson = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityNew" ofType:@"json"]];
    
    NSAssert(dataJson != nil, @"请检查你的数据源文件是否存在，格式是否正确");
    
    NSArray *arrayCity = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:nil];
    
    array = [Province provinceWithArray:arrayCity];
    
    return array;
}


@end

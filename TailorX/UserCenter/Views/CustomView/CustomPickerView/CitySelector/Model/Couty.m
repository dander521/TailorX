//
//  Couty.m
//  CustomLocationPicker
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 yuantuan. All rights reserved.
//

#import "Couty.h"

@implementation Couty

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (instancetype)coutyWithDict:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

+ (NSArray *)coutyWithArray:(NSArray *)array
{
    NSMutableArray *arrayCouty = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayCouty addObject:[self coutyWithDict:dict]];
    }
    
    Couty *couty = [Couty new];
    couty.id = @"999999";
    couty.name = @"其他";
    couty.city = @[];
    
    [arrayCouty addObject:couty];
    
    return arrayCouty;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

int k = 0;
- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@:%p> {id:%@,name:%@,city:%@}---%d",self.class,self,self.id,self.name, self.city,k++];
}

@end

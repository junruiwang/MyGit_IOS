//
//  SpecialNeed.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-7-16.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "SpecialNeed.h"

@implementation SpecialNeed

- (id) initWithCodeAndName : (NSString *) code name:(NSString *) name
{
    if (self = [self init]) {
        self.code = code;
        self.name = name;
    }
    return self;
}

@end

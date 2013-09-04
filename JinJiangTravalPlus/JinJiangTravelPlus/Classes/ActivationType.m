//
//  ActivationType.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-19.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "ActivationType.h"

@implementation ActivationType

@synthesize enName = _enName;
@synthesize cnName = _cnName;

- (id)initWithCnName:(NSString*)chinese andEnName:(NSString*)english
{
    self = [super init];
    if (self)
    {
        _enName = [[NSString alloc] initWithString:english];
        _cnName = [[NSString alloc] initWithString:chinese];
    }
    return self;
}

@end

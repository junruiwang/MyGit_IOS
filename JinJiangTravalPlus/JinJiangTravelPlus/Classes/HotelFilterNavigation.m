//
//  HotelFilterNavigation.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/24/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "HotelFilterNavigation.h"

@implementation HotelFilterNavigation

- (id)initWithNameAndCode:(NSString *)name code:(NSString *) code
{
    if (self = [super init]) {
        self.name = name;
        self.code = code;
    }
    return self;
}


@end

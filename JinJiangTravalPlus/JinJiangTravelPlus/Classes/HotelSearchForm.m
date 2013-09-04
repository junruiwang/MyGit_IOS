//
//  HotelSearchForm.m
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-2.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "HotelSearchForm.h"
#import "PriceRange.h"
#import "Kal.h"

@implementation HotelSearchForm

- (id)init
{
    if (self = [super init]) {
        KalDate *today = [KalDate dateFromNSDate:[NSDate date]];
        _checkinDate = today;
        _checkoutDate = [today getNextKalDate];
        _nightNums = 1;
    }
    return self;
}

@end

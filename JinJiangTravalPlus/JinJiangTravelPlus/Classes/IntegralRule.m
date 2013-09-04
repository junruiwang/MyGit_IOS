//
//  IntegralRule.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-11.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "IntegralRule.h"

@implementation IntegralRule

+ (JJCouponExchangeType)couponTypeFromAmount:(NSString *) couponParVale
{
    NSDictionary *couponDict = @{@"10":@(JJCouponTen), @"50":@(JJCouponFifty), @"100":@(JJCouponHundred)};
    return (JJCouponExchangeType)[couponDict[couponParVale] intValue];
}

@end

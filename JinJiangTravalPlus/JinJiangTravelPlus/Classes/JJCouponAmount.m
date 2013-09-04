//
//  JJCouponAmount.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-28.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "JJCouponAmount.h"

@implementation JJCouponAmount

+ (NSString *)nameForCouponAmount:(JJCouponAmountType)amountType
{
    NSDictionary *couponAmountDict = @{@(JJCouponAmountTen):@"10", @(JJCouponAmountTwenty):@"20",
    @(JJCouponAmountThirty):@"30", @(JJCouponAmountFifty):@"50", @(JJCouponAmountHundred):@"100"};

    return (NSString *)couponAmountDict[@(amountType)];
}

@end

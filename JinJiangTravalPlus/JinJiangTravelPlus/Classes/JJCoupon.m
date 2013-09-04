//
//  JJCoupon.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-22.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "JJCoupon.h"

@implementation JJCoupon

- (NSString *)name
{
    return [NSString stringWithFormat:@"%d元%@券", self.amount, self.category];
}

+ (JJCouponStatus)couponStatusFromName:(NSString *)statusName
{
    NSDictionary *statusDict = @{@"未使用":@(UNUSED), @"已使用":@(USED), @"已作废":@(OBSOLETE), @"已过期":@(EXPIRED), @"已锁定":@(LOCKED)};
    return (JJCouponStatus)[statusDict[statusName] intValue];
}

@end

//
//  Coupon.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/8/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "UseCoupon.h"

@implementation UseCoupon


-(NSUInteger) totalAmount
{
    return _couponAmount * _useCouponNum;
}
@end

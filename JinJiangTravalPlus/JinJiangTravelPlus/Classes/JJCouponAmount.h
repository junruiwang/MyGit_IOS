//
//  JJCouponAmount.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-28.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    JJCouponAmountTen = 10,
    JJCouponAmountTwenty = 20,
    JJCouponAmountThirty = 30,
    JJCouponAmountFifty = 50,
    JJCouponAmountHundred = 100,
}   JJCouponAmountType;

@interface JJCouponAmount : NSObject

@property (nonatomic, assign) JJCouponAmountType amountType;
@property (nonatomic, assign) int couponCount;

+ (NSString *)nameForCouponAmount:(JJCouponAmountType)amountType;

@end

//
//  IntegralRule.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-11.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    JJCouponTen = 10,
    JJCouponFifty = 50,
    JJCouponHundred = 100,
}   JJCouponExchangeType;

@interface IntegralRule : NSObject

@property(nonatomic, copy) NSString *ruleId;
@property(nonatomic, copy) NSString *ruleName;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *couponRuleType;
@property(nonatomic, assign) JJCouponExchangeType couponTypeVal;
@property(nonatomic, assign) NSInteger cost;
@property(nonatomic, copy) NSString *effectDate;
@property(nonatomic, copy) NSString *invalidDate;
@property(nonatomic, copy) NSString *mobileScoreGoodsId;

+ (JJCouponExchangeType)couponTypeFromAmount:(NSString *) couponParVale;

@end

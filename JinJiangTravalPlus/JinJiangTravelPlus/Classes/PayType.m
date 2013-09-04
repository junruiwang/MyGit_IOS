//
//  PayType.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 12-12-13.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "PayType.h"

@implementation PayType

- (id) initWithPayTypeInfo : (NSString *) name cnName : (NSString *) cnName description : (NSString *) description label : (NSString *) label amount : (NSString *) amount totalChargePrice : (NSString *) totalChargePrice cancelPolicyDesc : (NSString *) cancelPolicyDesc;
{
    if (self = [super init]) {
        self.cnName = cnName;
        self.name = name;
        self.description = description;
        self.label = label;
        self.amount = amount;
        self.totalChargePrice = totalChargePrice;
        self.cancelPolicyDesc = cancelPolicyDesc;
    }
    return self;
}

@end

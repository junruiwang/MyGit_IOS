//
//  PayType.h
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 12-12-13.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayType : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *cnName;

@property (nonatomic, copy) NSString *description;

@property (nonatomic, copy) NSString *label;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *totalChargePrice;

@property (nonatomic, copy) NSString *cancelPolicyDesc;

- (id) initWithPayTypeInfo : (NSString *) name cnName : (NSString *) cnName description : (NSString *) description label : (NSString *) label amount : (NSString *) amount totalChargePrice : (NSString *) totalChargePrice cancelPolicyDesc : (NSString *) cancelPolicyDesc;

@end

//
//  JJPlan.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-11-20.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    JJBreakfastNone = 0,
    JJBreakfastSingle,
    JJBreakfastDouble,
} JJBreakfast;

@interface JJPlan : NSObject

@property(nonatomic, assign) NSInteger planId;
@property(nonatomic, copy) NSString *planName;
@property(nonatomic, copy) NSString *rateCode;
@property (nonatomic, assign) JJBreakfast breakfast;
@property (nonatomic, assign) BOOL network;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, assign) NSInteger price;
@property(nonatomic, copy) NSString *guarantee;
@property(nonatomic, assign) BOOL roomAvai;

+ (BOOL)roomavaiFromName:(NSString *)name;
+ (JJBreakfast)breakfastFromName:(NSString *)name;
+ (BOOL)networkFromName:(NSString *)name;

@end

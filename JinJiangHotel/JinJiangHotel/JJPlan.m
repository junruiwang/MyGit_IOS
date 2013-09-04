//
//  JJPlan.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-11-20.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "JJPlan.h"

@implementation JJPlan

+ (BOOL)roomavaiFromName:(NSString *)name
{
    if ([name isEqualToString:@"Y"]) {
        return YES;
    }
    return NO;
}

+ (JJBreakfast)breakfastFromName:(NSString *)name
{
    NSDictionary *breakfastDict = @{@"0":@(JJBreakfastNone), @"1":@(JJBreakfastSingle), @"2":@(JJBreakfastDouble)};
    return (JJBreakfast)[breakfastDict[name] intValue];
}

+ (BOOL)networkFromName:(NSString *)name
{
    if ([name isEqualToString:@"Y"]) {
        return YES;
    }
    return NO;
}

@end

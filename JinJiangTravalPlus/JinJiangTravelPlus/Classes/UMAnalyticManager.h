//
//  UMAnalyticManager.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 5/9/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMAnalyticManager : NSObject

+(void)initUMAnalytic;

+(void)monitorViewPage:(NSString *)title;

+(void)monitorQuitViewPage:(NSString *)title;

+(void)eventCount:(NSString *) event label:(NSString *) label;

+(void)countTypeEvent:(NSString *)event action:(NSString *) action type:(NSString *) type  buySize:(NSString *) buySize productName: (NSString *)productName;

@end

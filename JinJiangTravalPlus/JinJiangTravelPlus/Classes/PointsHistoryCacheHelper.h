//
//  PointsHistoryCacheHelper.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/18/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointsHistoryCacheHelper : NSObject

+(void)savePointsToCache:(NSArray *) pointsHistoryList;

+(BOOL)isExistMonthRecord;

+(NSMutableArray *)getHistoryFromCache;

@end

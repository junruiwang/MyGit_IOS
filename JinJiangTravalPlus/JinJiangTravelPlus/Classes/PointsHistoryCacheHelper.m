//
//  PointsHistoryCacheHelper.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/18/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "PointsHistoryCacheHelper.h"
#import "PointsHistory.h"
#import "UserDefaultHelper.h"

@implementation PointsHistoryCacheHelper

#define kKey  [@"key_pointsHistory" stringByAppendingFormat:@"_%@",TheAppDelegate.userInfo.cardNo] 

+(void)savePointsToCache:(NSArray *) pointsHistoryList
{
    const NSInteger N_ENTRIES = [pointsHistoryList count];
    NSDictionary *dict;
    NSMutableArray *keyArray = [NSMutableArray array];
    NSMutableArray  *valueArray = [NSMutableArray array];
    NSInteger i;
    
    for (i = 0; i < N_ENTRIES; i++) {
        PointsHistory  *pointsHistory = (PointsHistory *) pointsHistoryList[i];
        NSString *cstr = pointsHistory.month;
        keyArray[i] = cstr;
        NSData *data = [pointsHistory archived];
        [valueArray addObject:data];
    }
    

    dict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    if ([dict count]>0) {
        [UserDefaultHelper writeToCache:dict key:kKey];
    }
    
}

+(BOOL)isExistMonthRecord
{
    if ([UserDefaultHelper isExistCache:kKey]) {
       NSMutableDictionary *dict = [UserDefaultHelper readFromCache:kKey];
        KalDate *kDate = [KalDate dateFromNSDate:[NSDate date]];
        NSInteger year = kDate.year;
        NSInteger month = kDate.month;
        if (month == 1) {
            month = 12;
            year--;
        }else{
            month--;
        }
        NSString *kDateStr = [NSString stringWithFormat:@"%i-%i",year,month];
        NSData *data = [dict objectForKey:kDateStr];
        PointsHistory *pointsHistory = [PointsHistory unArchived:data];
        if (pointsHistory) {
            return YES;
        }
    }
    
    return NO;
}

+(NSMutableArray *)getHistoryFromCache
{
    NSMutableArray *pointsHistoryList = [NSMutableArray array];
    if ([UserDefaultHelper isExistCache:kKey]) {
        NSDictionary *dict = [UserDefaultHelper readFromCache:kKey];
        NSMutableArray *array = [[dict allValues] mutableCopy];
        for (int i =0; i<[array count]; i++) {
            NSData *data = [array objectAtIndex:i];
            PointsHistory *pointsHistory = [PointsHistory unArchived:data];
            [pointsHistoryList addObject:pointsHistory];
        }

    }
    return pointsHistoryList;
}

@end

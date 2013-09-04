//
//  UMAnalyticManager.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 5/9/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "UMAnalyticManager.h"
#import "MobClick.h"
#import "Constants.h"

@implementation UMAnalyticManager

+(void)initUMAnalytic{
    if (kUMEnable) {
        [MobClick startWithAppkey:kUMAppkey reportPolicy:REALTIME channelId:nil];
        //update OnlineConfig
        [MobClick updateOnlineConfig];
        [MobClick setAppVersion:kClientVersion];
        if (TheAppDelegate.locationInfo.currentPoint.latitude && TheAppDelegate.locationInfo.currentPoint.longitude) {
            [MobClick setLatitude:TheAppDelegate.locationInfo.currentPoint.latitude longitude:TheAppDelegate.locationInfo.currentPoint.longitude];
        }
        [MobClick setLogEnabled:kLogEnable];
    }
}

+(void)monitorViewPage:(NSString *)title
{
    if (kUMEnable) {
         [MobClick beginLogPageView:title];
    }
}

+(void)monitorQuitViewPage:(NSString *)title
{
    if (kUMEnable) {
         [MobClick endLogPageView:title];
    }
}

+(void)eventCount:(NSString *)event label:(NSString *)label
{
    if (kUMEnable) {
        if (label) {
           [MobClick event:(NSString *)event label:(NSString *)label];
        }else{
           [MobClick event:(NSString *)event];
        }
    }
}

+(void)countTypeEvent:(NSString *)event action:(NSString *) action type:(NSString *) type  buySize:(NSString *) buySize productName: (NSString *)productName
{
    if(kUMEnable){
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              event, type, buySize, productName, nil];
        [MobClick event:event attributes:dict];
    }

}

@end

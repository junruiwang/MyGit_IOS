//
//  Constants.h
//  OnlineBus
//
//  Created by jerry on 13-12-4.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

// URL
#define kBaseURL                          @"http://42.121.117.61:6068/bustime/api"

#define query_bus_line                 [kBaseURL stringByAppendingPathComponent:@"/queryLine"]
#define query_bus_single_line          [kBaseURL stringByAppendingPathComponent:@"/querySingleLine"]
#define query_bus_single_time          [kBaseURL stringByAppendingPathComponent:@"/queryRunSingleLine"]
#define query_bus_station              [kBaseURL stringByAppendingPathComponent:@"/queryStation"]
#define query_station_line             [kBaseURL stringByAppendingPathComponent:@"/queryStationBus"]

#define kCustomButtonHeight		30.0
#define kSampleAdUnitID @"a15153e9211c6b8"
#define kTrackingId  @"UA-39510485-3"
#define RGB(R,G,B) [UIColor colorWithRed:(float)R/255.0 green:(float)G/255.0 blue:(float)B/255.0 alpha:1]
#define kAppStoreUrl @"https://itunes.apple.com/us/app/su-zhou-zai-xian-gong-jiao/id639107014?ls=1&mt=8"

#define FROM_BUSLIST_TO_BUSDETAIL   @"fromBusListToBusDetail"

#import "AppDelegate.h"
#define TheAppDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion doubleValue]
#define RGBCOLOR(R,G,B) [UIColor colorWithRed:(float)R/255.0 green:(float)G/255.0 blue:(float)B/255.0 alpha:1]
